import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Ensure Firebase is initialized in your project:
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const FleetRunnerRadarApp());
// }

// class FleetRunnerRadarApp extends StatelessWidget {
//   const FleetRunnerRadarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FleetRunner Driver - Map Radar',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF051424),
//         fontFamily: 'Space Grotesk',
//         colorScheme: const ColorScheme.dark(
//           primary: Color(0xFF10B981),
//           surface: Color(0xFF051424),
//           surfaceContainerHighest: Color(0xFF0D1C2D),
//         ),
//       ),
//       home: const MapRadarFirestoreScreen(),
//     );
//   }
// }

class MapRadarFirestoreScreen extends StatefulWidget {
  const MapRadarFirestoreScreen({super.key});

  @override
  State<MapRadarFirestoreScreen> createState() => _MapRadarFirestoreScreenState();
}

class _MapRadarFirestoreScreenState extends State<MapRadarFirestoreScreen>
    with SingleTickerProviderStateMixin {
  bool isOnline = true;
  bool autoAcceptHighRate = true;
  int currentTabIndex = 0;
  late AnimationController _radarController;

  // Real-time Firestore query stream for incoming dispatch orders
  Stream<QuerySnapshot<Map<String, dynamic>>> get _pendingOrdersStream {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'accepted')
        .limit(1)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    // 360-degree radar sweep animation (4 seconds per loop)
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  /// Toggle Driver Online / Offline status in Firestore
  Future<void> _toggleOnlineStatus(bool value) async {
    setState(() {
      isOnline = value;
      if (isOnline) {
        _radarController.repeat();
      } else {
        _radarController.stop();
      }
    });

    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc('current_driver_id')
          .set({
        'is_online': isOnline,
        'last_active_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error syncing driver status to Firestore: $e");
    }
  }

  /// Accept incoming order from Firestore
  Future<void> _acceptOrder(String orderId, double payout) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'accepted',
        'driver_id': 'current_driver_id',
        'accepted_at': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Order accepted! (+\$${payout.toStringAsFixed(2)}) Routing to market loading dock...",
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint("Failed to accept order in Firestore: $e");
    }
  }

  /// Decline order (adds driver to declined_by list or dismisses offer)
  Future<void> _declineOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'declined_by': FieldValue.arrayUnion(['current_driver_id']),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order declined. Resuming radar search..."),
          backgroundColor: Color(0xFF0D1C2D),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint("Failed to decline order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            _buildAppBar(),

            // Main Radar Canvas with Live Firestore Bottom Sheet
            Expanded(
              child: Stack(
                children: [
                  // 1. Radar Coordinate Grid & Concentric Rings Background
                  const Positioned.fill(child: RadarGridBackground()),

                  // 2. Animated Rotating Green Radar Sector Sweep
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _radarController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RadarSweepPainter(
                            angle: _radarController.value * 2 * math.pi,
                            isOnline: isOnline,
                          ),
                        );
                      },
                    ),
                  ),

                  // 3. Central Driver Location Beacon
                  Align(
                    alignment: Alignment.center,
                    child: _buildCenterDriverBeacon(),
                  ),

                  // 4. Searching Top Pill Banner
                  Positioned(
                    top: 14,
                    left: 20,
                    right: 20,
                    child: _buildSearchingPill(),
                  ),

                  // 5. Floating Side Controls (Recenter, Hotspots, Layers)
                  Positioned(
                    top: 70,
                    right: 16,
                    child: _buildRadarSideControls(),
                  ),

                  // 6. Live Speedometer & Auto-Accept Toggle Bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Speedometer Pill
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              _buildSpeedometerBadge(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Auto-accept High-Rate Orders Toggle Card
                        _buildAutoAcceptCard(),
                        const SizedBox(height: 8),

                        // 7. Dynamic Firestore Order Detection Stream
                        _buildRealtimeOrderSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Persistent Bottom Tab Bar
            _buildBottomTabBar(),
          ],
        ),
      ),
    );
  }

  /// Top App Bar matching Kinetic Courier specifications
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF051424),
        border: Border(
          bottom: BorderSide(color: Color(0xFF0D1C2D), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo Icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Header Text
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FLEETRUNNER',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                'Map Radar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Online / Offline Switch Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1C2D),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOnline
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : const Color(0xFF2C3A4C),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
                    boxShadow: isOnline
                        ? [
                            const BoxShadow(
                              color: Color(0xFF10B981),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isOnline ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isOnline ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.65,
                  child: Switch(
                    value: isOnline,
                    onChanged: (val) => _toggleOnlineStatus(val),
                    activeThumbColor: const Color(0xFF10B981),
                    inactiveThumbColor: const Color(0xFF94A3B8),
                    inactiveTrackColor: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Driver Avatar
          Container(
            width: 38,
            height: 38,
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

  /// Searching indicator pill at top of radar
  Widget _buildSearchingPill() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1C2D).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2C3A4C), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Searching for nearby market orders...',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              '• 4.5 km zone',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Floating side control buttons
  Widget _buildRadarSideControls() {
    return Column(
      children: [
        _buildCircleButton(Icons.my_location_rounded),
        const SizedBox(height: 8),
        _buildCircleButton(Icons.local_fire_department_rounded),
        const SizedBox(height: 8),
        _buildCircleButton(Icons.tune_rounded),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0D1C2D),
        border: Border.all(color: const Color(0xFF2C3A4C), width: 1),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
    );
  }

  /// Speedometer & Telemetry Badge
  Widget _buildSpeedometerBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1C2D).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2C3A4C), width: 1),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '24',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 4),
          Text(
            'KM/H',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.explore_outlined, size: 14, color: Color(0xFF10B981)),
          SizedBox(width: 4),
          Text(
            'NE 42°',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  /// Auto-accept high-rate orders card
  Widget _buildAutoAcceptCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1C2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2C3A4C), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto-accept high-rate orders',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Minimum \$15+ per dispatch run',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: autoAcceptHighRate,
              onChanged: (val) {
                setState(() {
                  autoAcceptHighRate = val;
                });
              },
              activeThumbColor: const Color(0xFF10B981),
              inactiveThumbColor: const Color(0xFF94A3B8),
              inactiveTrackColor: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  /// Real-time Firestore Stream Builder for live orders
  Widget _buildRealtimeOrderSection() {
    if (!isOnline) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _pendingOrdersStream,
      builder: (context, snapshot) {
        // Handle Firestore waiting state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF10B981)),
            ),
          );
        }

        // When no active order exists in Firestore
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1C2D).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2C3A4C)),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Listening for dispatch offers in radar zone...',
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          );
        }

        // Active pending order document from Firestore
        final doc = snapshot.data!.docs.first;
        final data = doc.data();
        final orderId = doc.id;

        final payout = (data['total_payout'] ?? 18.50).toDouble();
        final tip = (data['guaranteed_tip'] ?? 4.00).toDouble();
        final totalDistanceKm = (data['distance_km'] ?? 5.5).toDouble();
        final estMins = data['estimated_duration_mins'] ?? 22;
        final marketName = data['market_name'] ?? 'Organic Green Market';
        final marketAddress = data['market_address'] ?? '482 Commerce St, Loading Dock B';
        final marketDist = data['market_distance_km'] ?? 2.1;
        final destAddress = data['destination_address'] ?? 'Highland Towers Apt 4B';
        final destDist = data['destination_distance_km'] ?? 3.4;
        final gatePin = data['gate_pin'] ?? '#7402';
        final bagCount = data['bag_count'] ?? 3;
        final itemCount = data['item_count'] ?? 12;
        final isFragile = data['is_fragile'] ?? true;

        return _buildFirestoreOrderSheet(
          orderId: orderId,
          payout: payout,
          tip: tip,
          totalDistanceKm: totalDistanceKm,
          estMins: estMins,
          marketName: marketName,
          marketAddress: marketAddress,
          marketDist: marketDist,
          destAddress: destAddress,
          destDist: destDist,
          gatePin: gatePin,
          bagCount: bagCount,
          itemCount: itemCount,
          isFragile: isFragile,
        );
      },
    );
  }

  /// Live Order Sheet populated directly from Firestore
  Widget _buildFirestoreOrderSheet({
    required String orderId,
    required double payout,
    required double tip,
    required double totalDistanceKm,
    required int estMins,
    required String marketName,
    required String marketAddress,
    required dynamic marketDist,
    required String destAddress,
    required dynamic destDist,
    required String gatePin,
    required int bagCount,
    required int itemCount,
    required bool isFragile,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF091B2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFF59E0B)),
              const SizedBox(width: 4),
              const Text(
                'NEW MARKET ORDER DETECTED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1C2D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2C3A4C)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 12, color: Color(0xFF94A3B8)),
                    SizedBox(width: 4),
                    Text(
                      '0:42s',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Payout and Distance Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$${payout.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10B981),
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '+\$${tip.toStringAsFixed(2)} Tip Included',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$totalDistanceKm km total',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Est. $estMins min',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Market Pickup Stop
          _buildRouteStopItem(
            iconColor: const Color(0xFF10B981),
            title: marketName,
            subtitle: marketAddress,
            tag: '$marketDist km away',
          ),
          const SizedBox(height: 10),

          // Destination Customer Stop
          _buildRouteStopItem(
            iconColor: const Color(0xFFF59E0B),
            title: destAddress,
            subtitle: 'Gate Pin $gatePin • Hand to recipient',
            tag: '$destDist km from market',
          ),
          const SizedBox(height: 14),

          // Cargo tags (Bags, Items, Fragile)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1C2D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Text(
                      '$bagCount Grocery bags • $itemCount items',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (isFragile) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFEF4444)),
                      SizedBox(width: 4),
                      Text(
                        'FRAGILE TAG',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Accept Order Button (Writes status 'ACCEPTED' to Firestore)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _acceptOrder(orderId, payout),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: const Color(0xFF010F1F),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 20, color: Color(0xFF010F1F)),
                  const SizedBox(width: 8),
                  Text(
                    'ACCEPT ORDER (\$${payout.toStringAsFixed(2)})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Decline Order Action
          Center(
            child: TextButton(
              onPressed: () => _declineOrder(orderId),
              child: const Text(
                'DECLINE ORDER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStopItem({
    required Color iconColor,
    required String title,
    required String subtitle,
    required String tag,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1C2D),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Center Driver Target with orientation arrow
  Widget _buildCenterDriverBeacon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(12, 10),
          painter: TrianglePointerPainter(
            color: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF051424),
            border: Border.all(
              color: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
              width: 3,
            ),
            boxShadow: [
              if (isOnline)
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? const Color(0xFF10B981) : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Persistent Bottom Navigation Bar
  Widget _buildBottomTabBar() {
    final navItems = [
      {'icon': Icons.radar_rounded, 'label': 'Radar'},
      {'icon': Icons.local_shipping_rounded, 'label': 'Tasks'},
      {'icon': Icons.access_time_rounded, 'label': 'History'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF030D18),
        border: Border(
          top: BorderSide(color: Color(0xFF0D1C2D), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = index == currentTabIndex;
          final color = isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                currentTabIndex = index;
              });
            },
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    navItems[index]['icon'] as IconData,
                    color: color,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    navItems[index]['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Custom Painter for Background Grid & Concentric Distance Rings
class RadarGridBackground extends StatelessWidget {
  const RadarGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _RadarBackgroundPainter(),
        );
      },
    );
  }
}

class _RadarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.2)
      ..strokeWidth = 1;

    const step = 36.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final ringPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final radii = [80.0, 160.0, 240.0, 320.0, 400.0];
    for (final r in radii) {
      canvas.drawCircle(center, r, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Painter for Rotating Radar Sweep Sector
class RadarSweepPainter extends CustomPainter {
  final double angle;
  final bool isOnline;

  RadarSweepPainter({
    required this.angle,
    required this.isOnline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isOnline) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.48;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    const sweepAngle = math.pi / 3;
    final rect = Rect.fromCircle(center: Offset.zero, radius: maxRadius);

    final sweepGradient = SweepGradient(
      startAngle: 0.0,
      endAngle: sweepAngle,
      colors: [
        const Color(0xFF10B981).withValues(alpha: 0.0),
        const Color(0xFF10B981).withValues(alpha: 0.28),
      ],
    );

    final sweepPaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      rect,
      0,
      sweepAngle,
      true,
      sweepPaint,
    );

    final edgePaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.85)
      ..strokeWidth = 1.5;

    final edgeX = maxRadius * math.cos(sweepAngle);
    final edgeY = maxRadius * math.sin(sweepAngle);
    canvas.drawLine(Offset.zero, Offset(edgeX, edgeY), edgePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RadarSweepPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.isOnline != isOnline;
  }
}

/// Orientation pointer triangle
class TrianglePointerPainter extends CustomPainter {
  final Color color;

  TrianglePointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePointerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
