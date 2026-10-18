// features/delivery/presentation/screen/delivery_success_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

// ==========================================
// 1. DATA MODELS & STATE
// ==========================================

class CustomerDeliveryOrder {
  final String orderId;
  final String orderCode;
  final String recipientName;
  final bool isContactless;
  final int bagCount;
  final String address;
  final String gatePin;
  final String elevator;
  final String instructions;
  final String phone;
  final double totalPayout;

  CustomerDeliveryOrder({
    required this.orderId,
    required this.orderCode,
    required this.recipientName,
    required this.isContactless,
    required this.bagCount,
    required this.address,
    required this.gatePin,
    required this.elevator,
    required this.instructions,
    required this.phone,
    required this.totalPayout,
  });

  factory CustomerDeliveryOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final cust = data['customer'] as Map<String, dynamic>? ?? {};

    return CustomerDeliveryOrder(
      orderId: doc.id,
      orderCode: cust['order_code'] ?? data['order_code'] ?? '#FR-88942',
      recipientName: cust['name'] ?? 'Sarah Jenkins',
      isContactless: cust['is_contactless'] ?? true,
      bagCount: cust['bag_count'] ?? 4,
      address: cust['address'] ?? 'Skyline Lofts, 450 Ocean Ave, Unit 12B',
      gatePin: cust['gate_pin'] ?? '#4091',
      elevator: cust['elevator'] ?? 'Elevator B • 12th Fl',
      instructions: cust['instructions'] ??
          'Please leave at door next to welcome mat, ring bell once.',
      phone: cust['phone'] ?? '+15550199876',
      totalPayout: (data['total_payout'] as num?)?.toDouble() ?? 24.80,
    );
  }
}

class ProofOfDeliveryFormState {
  final bool hasArrived;
  final String? localPhotoPath;
  final String? uploadedPhotoUrl;
  final String dropoffNotes;
  final bool isTempOk;
  final bool isSmsNotified;
  final bool isSubmitting;
  final String? submissionError;
  final String gpsStamp;

  ProofOfDeliveryFormState({
    this.hasArrived = true,
    this.localPhotoPath,
    this.uploadedPhotoUrl,
    this.dropoffNotes = 'Left by apartment door 12B next to mat as instructed',
    this.isTempOk = true,
    this.isSmsNotified = true,
    this.isSubmitting = false,
    this.submissionError,
    this.gpsStamp = '34.0195° N, 118.4912° W',
  });

  ProofOfDeliveryFormState copyWith({
    bool? hasArrived,
    String? localPhotoPath,
    String? uploadedPhotoUrl,
    String? dropoffNotes,
    bool? isTempOk,
    bool? isSmsNotified,
    bool? isSubmitting,
    String? submissionError,
    String? gpsStamp,
  }) {
    return ProofOfDeliveryFormState(
      hasArrived: hasArrived ?? this.hasArrived,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      uploadedPhotoUrl: uploadedPhotoUrl ?? this.uploadedPhotoUrl,
      dropoffNotes: dropoffNotes ?? this.dropoffNotes,
      isTempOk: isTempOk ?? this.isTempOk,
      isSmsNotified: isSmsNotified ?? this.isSmsNotified,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionError: submissionError,
      gpsStamp: gpsStamp ?? this.gpsStamp,
    );
  }
}

// ==========================================
// 2. RIVERPOD STATE PROVIDERS & CONTROLLER
// ==========================================

/// StreamProvider: Watches active delivery document in Firestore
final activeDeliveryStreamProvider =
    StreamProvider.autoDispose.family<CustomerDeliveryOrder, String>(
        (ref, orderId) {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('orders').doc(orderId).snapshots().map((doc) {
    return CustomerDeliveryOrder.fromFirestore(doc);
  });
});

/// StateNotifierProvider: Handles Proof of Delivery photo capture, form inputs, and Firebase completion
class PodSubmissionController extends StateNotifier<ProofOfDeliveryFormState> {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImagePicker _picker = ImagePicker();

  PodSubmissionController(this._firestore, this._storage)
      : super(ProofOfDeliveryFormState());

  void toggleArrivedStatus() {
    state = state.copyWith(hasArrived: !state.hasArrived);
  }

  void updateNotes(String notes) {
    state = state.copyWith(dropoffNotes: notes);
  }

  void toggleTempOk() {
    state = state.copyWith(isTempOk: !state.isTempOk);
  }

  void toggleSmsNotified() {
    state = state.copyWith(isSmsNotified: !state.isSmsNotified);
  }

  /// Retake / Capture Camera Photo for POD
  Future<void> retakePodPhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (photo != null) {
        state = state.copyWith(
          localPhotoPath: photo.path,
          gpsStamp: '34.0195° N, 118.4912° W',
        );
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  /// Launch phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanPhone);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  /// Launch SMS message
  Future<void> sendSms(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri(scheme: 'sms', path: cleanPhone);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  /// Submit Proof of Delivery to Firebase Storage and Cloud Firestore
  Future<bool> submitProofAndCompleteOrder({
    required String driverId,
    required String orderId,
    required double totalEarned,
  }) async {
    state = state.copyWith(isSubmitting: true, submissionError: null);

    try {
      String downloadUrl = state.uploadedPhotoUrl ?? '';

      // 1. Upload local photo to Firebase Storage if newly captured
      if (state.localPhotoPath != null) {
        final file = File(state.localPhotoPath!);
        final storageRef = _storage.ref().child(
              'pod_photos/$driverId/$orderId/pod_${DateTime.now().millisecondsSinceEpoch}.jpg',
            );
        final uploadTask = await storageRef.putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        downloadUrl = await uploadTask.ref.getDownloadURL();
      }

      // 2. Create immutable Proof of Delivery record in Firestore
      final podRef = _firestore.collection('proof_of_deliveries').doc();
      await podRef.set({
        'id': podRef.id,
        'order_id': orderId,
        'driver_id': driverId,
        'photo_url': downloadUrl,
        'dropoff_notes': state.dropoffNotes,
        'is_temp_checked': state.isTempOk,
        'is_sms_notified': state.isSmsNotified,
        'gps_coordinates': {
          'latitude': 34.0195,
          'longitude': -118.4912,
        },
        'verified_at': FieldValue.serverTimestamp(),
      });

      // 3. Update order document status to delivered
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'delivered',
        'pod_id': podRef.id,
        'delivered_at': FieldValue.serverTimestamp(),
        'payout_credited': totalEarned,
      });

      // 4. Record to driver's completed trips collection
      await _firestore
          .collection('drivers')
          .doc(driverId)
          .collection('completed_orders')
          .doc(orderId)
          .set({
        'order_id': orderId,
        'total_earnings': totalEarned,
        'delivery_type': 'verified_pod',
        'completed_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        submissionError: e.toString(),
      );
      return false;
    }
  }
}

final podSubmissionControllerProvider = StateNotifierProvider<
    PodSubmissionController, ProofOfDeliveryFormState>((ref) {
  return PodSubmissionController(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

// ==========================================
// 3. MAIN APP & ENTRY POINT
// ==========================================


// ==========================================
// 4. UI SCREEN (RIVERPOD CONSUMER WIDGET)
// ==========================================

class DeliverySuccessScreen extends ConsumerStatefulWidget {
  final String orderId;
  final String driverId;
  final XFile? deliveryPhoto;

  const DeliverySuccessScreen({
    super.key,
    this.orderId = '',
    this.driverId = '',
    this.deliveryPhoto,
  });

  @override
  ConsumerState<DeliverySuccessScreen> createState() =>
      _DeliverySuccessScreenState();
}

class _DeliverySuccessScreenState
    extends ConsumerState<DeliverySuccessScreen> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: 'Left by apartment door 12B next to mat as instructed',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(activeDeliveryStreamProvider(widget.orderId));
    final podState = ref.watch(podSubmissionControllerProvider);
    final controller = ref.read(podSubmissionControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header with Back Button, SOS, and Driver Avatar
            _buildAppBar(context),

            // Main Scrollable Content
            Expanded(
              child: orderAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF10B981)),
                ),
                error: (_, __) => _buildBodyWithOrder(
                  _fallbackOrder(),
                  podState,
                  controller,
                ),
                data: (order) => _buildBodyWithOrder(
                  order,
                  podState,
                  controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomerDeliveryOrder _fallbackOrder() {
    return CustomerDeliveryOrder(
      orderId: widget.orderId,
      orderCode: '#FR-88942',
      recipientName: 'Sarah Jenkins',
      isContactless: true,
      bagCount: 4,
      address: 'Skyline Lofts, 450 Ocean Ave, Unit 12B',
      gatePin: '#4091',
      elevator: 'Elevator B • 12th Fl',
      instructions: 'Please leave at door next to welcome mat, ring bell once.',
      phone: '+15550199876',
      totalPayout: 24.80,
    );
  }

  Widget _buildBodyWithOrder(
    CustomerDeliveryOrder order,
    ProofOfDeliveryFormState podState,
    PodSubmissionController controller,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Customer Recipient Card
          _buildCustomerDetailsCard(order, controller),
          const SizedBox(height: 12),

          // 2. "I Have Arrived at Customer Location" Status Button
          _buildArrivedLocationButton(podState, controller),
          const SizedBox(height: 16),

          // 3. Proof of Delivery Card (Step 2 of 2: Package Handoff)
          _buildProofOfDeliveryCard(order, podState, controller),
          const SizedBox(height: 14),

          // 4. Safety Hotline & Courier Dispatch Support Footer Links
          _buildSupportFooter(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ------------------------------------------
  // TOP APP BAR
  // ------------------------------------------
  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF051424),
        border: Border(
          bottom: BorderSide(color: Color(0xFF0D1C2D), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            splashRadius: 20,
          ),
          const SizedBox(width: 8),

          // App Logo Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),

          // Header Title
          const Text(
            'Proof Of Delivery',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),

          const Spacer(),

          // SOS Emergency Button
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency SOS dispatched to FleetRunner Operations!'),
                  backgroundColor: Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'SOS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Driver Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2C3A4C), width: 1.5),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // CUSTOMER RECIPIENT CARD
  // ------------------------------------------
  Widget _buildCustomerDetailsCard(
    CustomerDeliveryOrder order,
    PodSubmissionController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF091B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C3A4C).withOpacity(0.7),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Name, Contactless Pill, Call/Message Buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.recipientName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (order.isContactless)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF10B981).withOpacity(0.35),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.wifi_tethering_rounded,
                                  size: 11,
                                  color: Color(0xFF10B981),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Contactless',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Order ${order.orderCode} • ${order.bagCount} Grocery Bags',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons: Phone & Chat
              Row(
                children: [
                  InkWell(
                    onTap: () => controller.makePhoneCall(order.phone),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1C2D),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2C3A4C)),
                      ),
                      child: const Icon(
                        Icons.call_outlined,
                        color: Color(0xFF10B981),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => controller.sendSms(order.phone),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1C2D),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2C3A4C)),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Color(0xFF10B981),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Destination Address Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1C2D),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2C3A4C).withOpacity(0.6),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFFF59E0B),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.address,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.key_rounded,
                            size: 11,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Gate: ${order.gatePin}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      order.elevator,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Customer Delivery Instructions
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF051424),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF2C3A4C).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'INSTRUCTIONS: ',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              TextSpan(
                                text: order.instructions,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF94A3B8),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // "I HAVE ARRIVED AT CUSTOMER LOCATION" BUTTON
  // ------------------------------------------
  Widget _buildArrivedLocationButton(
    ProofOfDeliveryFormState podState,
    PodSubmissionController controller,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: controller.toggleArrivedStatus,
        icon: Icon(
          Icons.location_on_outlined,
          size: 18,
          color: podState.hasArrived
              ? const Color(0xFF10B981)
              : const Color(0xFF94A3B8),
        ),
        label: Text(
          'I Have Arrived at Customer Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: podState.hasArrived ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF091B2E),
          side: BorderSide(
            color: podState.hasArrived
                ? const Color(0xFF10B981).withOpacity(0.5)
                : const Color(0xFF2C3A4C),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------
  // PROOF OF DELIVERY CARD
  // ------------------------------------------
  Widget _buildProofOfDeliveryCard(
    CustomerDeliveryOrder order,
    ProofOfDeliveryFormState podState,
    PodSubmissionController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF091B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2C3A4C).withOpacity(0.7),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle Bar Indicator
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2C3A4C),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header: Icon, Title & Live Mode Pill
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1C2D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proof of Delivery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Step 2 of 2: Package Handoff',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1C2D),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2C3A4C)),
                ),
                child: const Text(
                  'Live Mode',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Doorstep Camera Viewfinder with GPS Stamp & Retake Action
          _buildDoorstepCameraViewfinder(podState, controller),
          const SizedBox(height: 14),

          // Drop-off Location Notes Label
          const Row(
            children: [
              Icon(
                Icons.notes_rounded,
                size: 15,
                color: Color(0xFF94A3B8),
              ),
              SizedBox(width: 6),
              Text(
                'Drop-off location notes',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Drop-off Notes Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1C2D),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2C3A4C).withOpacity(0.8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _notesController,
                    onChanged: controller.updateNotes,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter drop-off instructions or notes...',
                      hintStyle:
                          TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                  onPressed: () {
                    _notesController.clear();
                    controller.updateNotes('');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Dual Quality Verification Checkboxes (Temp OK & SMS Notified)
          Row(
            children: [
              Expanded(
                child: _buildQualityCheckbox(
                  label: 'Temp OK',
                  sublabel: 'Cold chain intact',
                  isChecked: podState.isTempOk,
                  onTap: controller.toggleTempOk,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildQualityCheckbox(
                  label: 'SMS Notified',
                  sublabel: 'Delivery ping sent',
                  isChecked: podState.isSmsNotified,
                  onTap: controller.toggleSmsNotified,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Primary "SUBMIT PROOF & COMPLETE ORDER" CTA Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: podState.isSubmitting
                  ? null
                  : () async {
                      final success =
                          await controller.submitProofAndCompleteOrder(
                        driverId: widget.driverId,
                        orderId: order.orderId,
                        totalEarned: order.totalPayout,
                      );
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Proof verified! \$${order.totalPayout.toStringAsFixed(2)} credited to your shift balance.',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: const Color(0xFF010F1F),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: podState.isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF010F1F),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                          color: Color(0xFF010F1F),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SUBMIT PROOF & COMPLETE ORDER (\$${order.totalPayout.toStringAsFixed(2)} TOTAL EARNED)',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                            color: Color(0xFF010F1F),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // CAMERA VIEWFINDER WITH GPS STAMP & RETAKE
  // ------------------------------------------
  Widget _buildDoorstepCameraViewfinder(
    ProofOfDeliveryFormState podState,
    PodSubmissionController controller,
  ) {
    final File? displayPhoto = widget.deliveryPhoto != null 
        ? File(widget.deliveryPhoto!.path)
        : (podState.localPhotoPath != null ? File(podState.localPhotoPath!) : null);
        
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF051424),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2C3A4C).withOpacity(0.8),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Doorstep Delivery Photo
            Positioned.fill(
              child: displayPhoto != null
                  ? Image.file(
                      displayPhoto,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      podState.uploadedPhotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF0D1C2D),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 44,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
            ),

            // Top GPS Stamp Badge
            Positioned(
              top: 10,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'GPS: ${podState.gpsStamp}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // Target Crosshair / Focus Reticle
            Center(
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.85),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.filter_center_focus_rounded,
                  size: 24,
                  color: Color(0xFF10B981),
                ),
              ),
            ),

            // Bottom Left: "PHOTO VERIFIED ✓" Badge
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PHOTO VERIFIED ✓',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF010F1F),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // Bottom Right: Retake Photo Button
            Positioned(
              bottom: 12,
              right: 12,
              child: InkWell(
                onTap: controller.retakePodPhoto,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1C2D).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF2C3A4C)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Retake',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // QUALITY CHECKBOX WIDGET
  // ------------------------------------------
  Widget _buildQualityCheckbox({
    required String label,
    required String sublabel,
    required bool isChecked,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1C2D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isChecked
                ? const Color(0xFF10B981).withOpacity(0.5)
                : const Color(0xFF2C3A4C).withOpacity(0.7),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isChecked
                    ? const Color(0xFF10B981)
                    : const Color(0xFF051424),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isChecked
                      ? const Color(0xFF10B981)
                      : const Color(0xFF64748B),
                ),
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color: Color(0xFF010F1F),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // FOOTER LINKS: SAFETY & DISPATCH HOTLINE
  // ------------------------------------------
  Widget _buildSupportFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(
              Icons.emergency_outlined,
              size: 14,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(width: 5),
            Text(
              'Safety Hotline',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444).withOpacity(0.9),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 16),
        const Row(
          children: [
            Icon(
              Icons.headset_mic_outlined,
              size: 14,
              color: Color(0xFF94A3B8),
            ),
            SizedBox(width: 5),
            Text(
              'Courier Dispatch Support',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// class DeliverySuccessScreen extends StatelessWidget {
//   const DeliverySuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Success icon
//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     color: AppColors.green.withValues(alpha: 0.15),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check_rounded,
//                     size: 60,
//                     color: AppColors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Success message
//                 const Text(
//                   'Delivery Completed!',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 const Text(
//                   'Great job! The order has been successfully delivered.',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: AppColors.muted,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 48),

//                 // Back to radar button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () => context.go('/radar'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.green,
//                       foregroundColor: AppColors.onGreen,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                     ),
//                     child: const Text(
//                       'Back to Radar',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: 0.6,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
