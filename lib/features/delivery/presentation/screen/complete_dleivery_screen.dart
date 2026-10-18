import 'package:flutter/material.dart';
import 'package:rice_delivery/features/orders/domain/order.dart' as model;

class DeliverySuccessScreen extends StatelessWidget {
  final model.Order order;

  const DeliverySuccessScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051424),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Scrollable Delivery Success Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Success Graphic: Glowing Animated Badge with Checkmark
                    _buildSuccessGlowBadge(),
                    const SizedBox(height: 18),

                    // "MISSION LOGGED" Telemetry Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1C2D),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'MISSION LOGGED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title & Description
                    const Text(
                      'Delivery Completed!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Proof of Delivery verified & recorded to dispatch registry.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Trip Summary Card
                    _buildTripSummaryCard(order),
                    const SizedBox(height: 28),

                    // Primary CTA: FIND NEXT ORDER (RADAR)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to home screen
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: const Color(0xFF010F1F),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.radar_rounded,
                              size: 20,
                              color: Color(0xFF010F1F),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'FIND NEXT ORDER (RADAR)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                                color: Color(0xFF010F1F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // TOP APP BAR
  // ------------------------------------------
  Widget _buildAppBar(BuildContext context) {
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

          // Header Text
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FLEETRUNNER',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                'TASKS',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Active presence dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),

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
  // SUCCESS GLOW BADGE
  // ------------------------------------------
  Widget _buildSuccessGlowBadge() {
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.3),
                  const Color(0xFF10B981).withOpacity(0.08),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.6),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.25),
                  blurRadius: 28,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                color: Color(0xFF10B981),
                size: 46,
              ),
            ),
          ),
          // Small lightning badge indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF59E0B),
              border: Border.all(color: const Color(0xFF051424), width: 2),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Color(0xFF010F1F),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // TRIP SUMMARY CARD
  // ------------------------------------------
  Widget _buildTripSummaryCard(model.Order order) {
    return Container(
      padding: const EdgeInsets.all(18),
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
          // Header Row: Icon, Title & Order Code
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              const Text(
                'Trip Summary',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1C2D),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF2C3A4C)),
                ),
                child: Text(
                  '#${order.number}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Recipient & Destination Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1C2D),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2C3A4C).withOpacity(0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.address,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Telemetry Row: Total & Time
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1C2D),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF2C3A4C).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.attach_money_rounded,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${order.total} SAR',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1C2D),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF2C3A4C).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'COMPLETED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${order.updatedAt.hour}:${order.updatedAt.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Payment Method Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1C2D),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.payment_outlined,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'PAYMENT METHOD',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      order.paymentStatus.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  order.paymentLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
