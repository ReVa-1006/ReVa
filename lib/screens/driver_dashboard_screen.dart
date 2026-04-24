import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'orders_screen.dart';

class DriverDashboardScreen extends StatefulWidget {
  // ── Inject real driver info here when DB is ready ──────────────────────
  final String driverName;
  final String driverRole;

  const DriverDashboardScreen({
    super.key,
    this.driverName = 'Driver',
    this.driverRole = 'Driver Dashboard',
  });

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen>
    with SingleTickerProviderStateMixin {
  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bgColor = Color(0xFFF0F5F0);

  bool _isOnline = true;
  int _currentIndex = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // ── Orders list — empty until DB is connected ─────────────────────────────
  final List<DriverOrder> _orders = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildStatsRow(),
                      const SizedBox(height: 20),
                      _buildMapSection(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Incoming Orders'),
                      const SizedBox(height: 12),
                      ..._orders
                          .where((o) => o.status == OrderStatus.incoming)
                          .map((o) => _buildOrderCard(o)),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Completed Today'),
                      const SizedBox(height: 12),
                      _buildCompletedList(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_darkGreen, _green, _lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
            ),
            child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.driverName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                Text(widget.driverRole,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13)),
              ],
            ),
          ),
          // Online/Offline toggle
          GestureDetector(
            onTap: () => setState(() => _isOnline = !_isOnline),
            child: AnimatedBuilder(
              animation: _pulseAnim,
              builder: (_, child) => Transform.scale(
                scale: _isOnline ? _pulseAnim.value : 1.0,
                child: child,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _isOnline ? Colors.white : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: _isOnline ? _lightGreen : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(_isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: _isOnline ? _green : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final incoming = _orders.where((o) => o.status == OrderStatus.incoming).length;
    final completed = _orders.where((o) => o.status == OrderStatus.completed).length;
    final stats = [
      {'label': "Today's Trips", 'value': '$completed', 'icon': Icons.route_rounded, 'color': _lightGreen},
      {'label': 'Incoming', 'value': '$incoming', 'icon': Icons.inbox_rounded, 'color': const Color(0xFF1E88E5)},
      {'label': 'Rating', 'value': '—', 'icon': Icons.star_rounded, 'color': const Color(0xFFF9A825)},
    ];
    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: s == stats.last ? 0 : 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Column(
              children: [
                Icon(s['icon'] as IconData, color: s['color'] as Color, size: 24),
                const SizedBox(height: 6),
                Text(s['value'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
                Text(s['label'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF888888)), textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Simulated map background
            CustomPaint(size: const Size(double.infinity, 200), painter: _MockMapPainter()),
            // Map overlay elements
            Positioned(
              top: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.my_location_rounded, color: _green, size: 16),
                    const SizedBox(width: 6),
                    Text(_isOnline ? 'Tracking Active' : 'Tracking Off',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _isOnline ? _green : Colors.grey)),
                  ],
                ),
              ),
            ),
            // Driver pin
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: _green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [BoxShadow(color: _green.withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 3)],
                    ),
                    child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 24),
                  ),
                  CustomPaint(size: const Size(2, 10), painter: _PinTailPainter()),
                ],
              ),
            ),
            // Seller pin (pickup)
            Positioned(
              top: 40, left: 60,
              child: _buildMapPin(Icons.store_rounded, const Color(0xFFF9A825), 'Seller'),
            ),
            // Buyer pin (delivery)
            Positioned(
              bottom: 40, right: 60,
              child: _buildMapPin(Icons.person_pin_circle_rounded, const Color(0xFF1E88E5), 'Buyer'),
            ),
            // Distance overlay
            Positioned(
              bottom: 12, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.route_rounded, color: _green, size: 14),
                    SizedBox(width: 4),
                    Text('3.2 km · ~12 min', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPin(IconData icon, Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6)]),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)));
  }

  Widget _buildOrderCard(DriverOrder order) {
    final isIncoming = order.status == OrderStatus.incoming;
    final isActive = order.status == OrderStatus.active;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(order.id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _green)),
                ),
                const Spacer(),
                Icon(Icons.route_rounded, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(order.distance, style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
              ],
            ),
            const SizedBox(height: 12),
            _buildRouteRow(Icons.store_rounded, const Color(0xFFF9A825), 'Pickup (Seller)', order.seller, order.sellerAddr),
            _buildRouteDivider(),
            _buildRouteRow(Icons.person_pin_circle_rounded, const Color(0xFF1E88E5), 'Delivery (Buyer)', order.buyer, order.buyerAddr),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_rounded, color: _green, size: 18),
                  const SizedBox(width: 8),
                  Text('${order.material} · ${order.weight}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333))),
                  const Spacer(),
                  Text(order.price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _darkGreen)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (isIncoming)
              Row(children: [
                Expanded(child: _orderActionBtn('Accept', _lightGreen, true, () {
                  setState(() => order.status = OrderStatus.active);
                })),
                const SizedBox(width: 10),
                Expanded(child: _orderActionBtn('Reject', const Color(0xFFE53935), false, () {
                  setState(() => order.status = OrderStatus.cancelled);
                })),
              ])
            else if (isActive)
              Row(children: [
                Expanded(child: _orderActionBtn('Complete ✓', _lightGreen, true, () {
                  setState(() => order.status = OrderStatus.completed);
                })),
                const SizedBox(width: 10),
                Expanded(child: _orderActionBtn('Cancel', const Color(0xFFE53935), false, () {
                  setState(() => order.status = OrderStatus.cancelled);
                })),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteRow(IconData icon, Color color, String role, String name, String addr) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role, style: const TextStyle(fontSize: 10, color: Color(0xFF999999), fontWeight: FontWeight.w500)),
            Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
            Text(addr, style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
      child: Container(width: 2, height: 18,
          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
    );
  }

  Widget _orderActionBtn(String label, Color color, bool filled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: filled ? 0 : 0.3)),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(color: filled ? Colors.white : color, fontWeight: FontWeight.w700, fontSize: 13)),
      ),
    );
  }

  Widget _buildCompletedList() {
    final completed = _orders
        .where((o) => o.status == OrderStatus.completed)
        .toList();
    if (completed.isEmpty) {
      return const Center(
        child: Text('No completed trips today.',
            style: TextStyle(color: Color(0xFF999999))),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: completed.asMap().entries.map((e) {
          final o = e.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: _lightGreen, size: 22),
                    const SizedBox(width: 10),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                        Text('Buyer: ${o.buyer}', style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                      ],
                    )),
                    Text(o.price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _darkGreen)),
                  ],
                ),
              ),
              if (e.key < completed.length - 1)
                const Divider(height: 1, indent: 48, color: Color(0xFFF0F0F0)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.map_rounded, 'label': 'Map'},
      {'icon': Icons.receipt_long_rounded, 'label': 'Orders'},
      {'icon': Icons.account_circle_rounded, 'label': 'Profile'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            if (i == 1) {
              Navigator.pushNamed(context, '/map');
            } else if (i == 2) {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => OrdersScreen(orders: _orders),
              ));
            } else if (i == 3) {
              Navigator.pushNamed(context, '/profile');
            } else {
              setState(() => _currentIndex = i);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: _green,
          unselectedItemColor: const Color(0xFF999999),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: items.map((it) => BottomNavigationBarItem(
            icon: Icon(it['icon'] as IconData, size: 24),
            label: it['label'] as String,
          )).toList(),
        ),
      ),
    );
  }
}

// ── Mock Map Painter ──────────────────────────────────────────────────────────
class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFFE8F5E9));

    final roadPaint = Paint()..color = Colors.white..strokeWidth = 10..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;

    // Draw fake road grid
    final random = math.Random(42);
    for (int i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x + 40, size.height), roadPaint);
    }
    for (int i = 0; i < 4; i++) {
      final y = random.nextDouble() * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 20), roadPaint);
    }

    // Blocks
    final blockPaint = Paint()..color = const Color(0xFFC8E6C9);
    for (int i = 0; i < 6; i++) {
      final rx = random.nextDouble() * size.width;
      final ry = random.nextDouble() * size.height;
      canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(rx, ry, 40 + random.nextDouble() * 40, 25 + random.nextDouble() * 25), const Radius.circular(6)),
          blockPaint);
    }

    // Green parks
    final parkPaint = Paint()..color = const Color(0xFFA5D6A7);
    for (int i = 0; i < 3; i++) {
      final px = random.nextDouble() * size.width;
      final py = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(px, py), 16, parkPaint);
    }

    // Route line
    final routePaint = Paint()
      ..color = const Color(0xFF2E6B2E)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(60, 40)
      ..cubicTo(100, 80, 200, 120, size.width / 2, size.height / 2)
      ..cubicTo(size.width / 2 + 60, size.height / 2 + 30, size.width - 80, size.height - 60, size.width - 60, size.height - 40);
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height),
        Paint()..color = const Color(0xFF2E6B2E)..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_) => false;
}
