import 'package:flutter/material.dart';

// ── Order Model ───────────────────────────────────────────────────────────────
class DriverOrder {
  final String id;
  final String seller;
  final String sellerAddr;
  final String buyer;
  final String buyerAddr;
  final String material;
  final String weight;
  final String price;
  final String distance;
  OrderStatus status;

  DriverOrder({
    required this.id,
    required this.seller,
    required this.sellerAddr,
    required this.buyer,
    required this.buyerAddr,
    required this.material,
    required this.weight,
    required this.price,
    required this.distance,
    this.status = OrderStatus.incoming,
  });
}

enum OrderStatus { incoming, active, completed, cancelled }

// ── Orders will come from Firestore when DB is connected ──────────────────────
// final List<DriverOrder> defaultOrders = [...]; // populate from DB



// ── Orders Screen ─────────────────────────────────────────────────────────────
class OrdersScreen extends StatefulWidget {
  /// Pass a mutable list so changes persist when navigating back to dashboard
  final List<DriverOrder> orders;

  const OrdersScreen({super.key, required this.orders});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bgColor = Color(0xFFF0F5F0);

  late TabController _tabController;

  List<DriverOrder> get _incoming =>
      widget.orders.where((o) => o.status == OrderStatus.incoming).toList();
  List<DriverOrder> get _active =>
      widget.orders.where((o) => o.status == OrderStatus.active).toList();
  List<DriverOrder> get _completed =>
      widget.orders.where((o) => o.status == OrderStatus.completed).toList();
  List<DriverOrder> get _cancelled =>
      widget.orders.where((o) => o.status == OrderStatus.cancelled).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateStatus(DriverOrder order, OrderStatus newStatus) {
    setState(() => order.status = newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(_incoming, OrderStatus.incoming),
                  _buildOrderList(_active, OrderStatus.active),
                  _buildCompletedList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_darkGreen, _green, _lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const Expanded(
            child: Text('My Orders',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
          ),
          // Badge showing total incoming
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle),
            child: Center(
              child: Text('${_incoming.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab bar ─────────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
              colors: [_darkGreen, _lightGreen]),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF888888),
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        tabs: [
          Tab(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Incoming'),
              if (_incoming.isNotEmpty) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${_incoming.length}',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ]),
          ),
          Tab(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Active'),
              if (_active.isNotEmpty) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                      color: _lightGreen,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${_active.length}',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ]),
          ),
          const Tab(text: 'Completed'),
        ],
      ),
    );
  }

  // ── Order lists ─────────────────────────────────────────────────────────────
  Widget _buildOrderList(List<DriverOrder> orders, OrderStatus tab) {
    if (orders.isEmpty) {
      return _buildEmptyState(
        tab == OrderStatus.incoming
            ? 'No Incoming Orders'
            : 'No Active Orders',
        tab == OrderStatus.incoming
            ? 'New orders will appear here'
            : 'Accept an order to start a trip',
        tab == OrderStatus.incoming
            ? Icons.inbox_rounded
            : Icons.local_shipping_rounded,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (_, i) => _buildOrderCard(orders[i], tab),
    );
  }

  Widget _buildCompletedList() {
    final all = [..._completed, ..._cancelled];
    if (all.isEmpty) {
      return _buildEmptyState(
          'No Completed Orders', 'Finished orders appear here',
          Icons.check_circle_outline_rounded);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: all.length,
      itemBuilder: (_, i) => _buildCompletedCard(all[i]),
    );
  }

  Widget _buildEmptyState(String title, String sub, IconData icon) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
              color: _lightGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle),
          child: Icon(icon, color: _lightGreen, size: 40),
        ),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A))),
        const SizedBox(height: 6),
        Text(sub,
            style:
                const TextStyle(fontSize: 13, color: Color(0xFF999999))),
      ]),
    );
  }

  // ── Order card ───────────────────────────────────────────────────────────────
  Widget _buildOrderCard(DriverOrder order, OrderStatus tab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header row
          Row(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(order.id,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _green)),
            ),
            const Spacer(),
            const Icon(Icons.route_rounded,
                size: 14, color: Color(0xFF888888)),
            const SizedBox(width: 4),
            Text(order.distance,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF888888))),
          ]),
          const SizedBox(height: 12),
          // Route
          _routeRow(Icons.store_rounded, const Color(0xFFF9A825),
              'Pickup', order.seller, order.sellerAddr),
          _routeDivider(),
          _routeRow(Icons.person_pin_circle_rounded,
              const Color(0xFF1E88E5), 'Delivery', order.buyer,
              order.buyerAddr),
          const SizedBox(height: 10),
          // Material chip
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.inventory_2_rounded,
                  color: _green, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${order.material} · ${order.weight}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333))),
              ),
              Text(order.price,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _darkGreen)),
            ]),
          ),
          const SizedBox(height: 12),
          // Action buttons
          if (tab == OrderStatus.incoming)
            Row(children: [
              Expanded(
                  child: _actionBtn('Accept', _lightGreen, true, () {
                _updateStatus(order, OrderStatus.active);
                _tabController.animateTo(1);
                _snack('Order ${order.id} accepted!');
              })),
              const SizedBox(width: 10),
              Expanded(
                  child: _actionBtn(
                      'Reject', const Color(0xFFE53935), false, () {
                _showRejectDialog(order);
              })),
            ])
          else if (tab == OrderStatus.active)
            Row(children: [
              Expanded(
                child: _actionBtn('Complete ✓', _lightGreen, true, () {
                  _updateStatus(order, OrderStatus.completed);
                  _tabController.animateTo(2);
                  _snack('Order ${order.id} completed! 🎉');
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: _actionBtn(
                      'Cancel', const Color(0xFFE53935), false, () {
                _showCancelDialog(order);
              })),
            ]),
        ]),
      ),
    );
  }

  Widget _buildCompletedCard(DriverOrder order) {
    final isDone = order.status == OrderStatus.completed;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: (isDone ? _lightGreen : const Color(0xFFE53935))
                .withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: isDone ? _lightGreen : const Color(0xFFE53935),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(order.id,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A))),
          Text('Buyer: ${order.buyer}',
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF888888))),
          Text('${order.material} · ${order.weight}',
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF888888))),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(order.price,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _darkGreen)),
          const SizedBox(height: 4),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: (isDone ? _lightGreen : const Color(0xFFE53935))
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(isDone ? 'Completed' : 'Cancelled',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isDone
                        ? _lightGreen
                        : const Color(0xFFE53935))),
          ),
        ]),
      ]),
    );
  }

  // ── Shared widgets ───────────────────────────────────────────────────────────
  Widget _routeRow(IconData icon, Color color, String role, String name,
      String addr) {
    return Row(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(role,
            style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF999999),
                fontWeight: FontWeight.w500)),
        Text(name,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A))),
        Text(addr,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF888888))),
      ]),
    ]);
  }

  Widget _routeDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
      child: Container(
          width: 2,
          height: 16,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2))),
    );
  }

  Widget _actionBtn(
      String label, Color color, bool filled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          gradient: filled
              ? LinearGradient(colors: [
                  color.withValues(alpha: 0.85),
                  color
                ])
              : null,
          color: filled ? null : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: filled
                  ? Colors.transparent
                  : color.withValues(alpha: 0.3)),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: filled ? Colors.white : color,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      ),
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────────────────────
  void _showRejectDialog(DriverOrder order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reject Order',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
            'Are you sure you want to reject order ${order.id}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF888888)))),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateStatus(order, OrderStatus.cancelled);
                _snack('Order ${order.id} rejected', error: true);
              },
              child: const Text('Reject',
                  style: TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _showCancelDialog(DriverOrder order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Order',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
            'Are you sure you want to cancel order ${order.id}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No',
                  style: TextStyle(color: Color(0xFF888888)))),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateStatus(order, OrderStatus.cancelled);
                _snack('Order ${order.id} cancelled', error: true);
              },
              child: const Text('Yes, Cancel',
                  style: TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          error ? const Color(0xFFE53935) : const Color(0xFF2E6B2E),
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }
}
