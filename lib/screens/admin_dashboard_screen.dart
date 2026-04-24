import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bgColor = Color(0xFFF0F5F0);

  final List<Map<String, dynamic>> _stats = [
    {
      'label': 'Total Users',
      'value': '1,240',
      'icon': Icons.people_alt_rounded,
      'color': Color(0xFF43A047),
    },
    {
      'label': 'Pending Materials',
      'value': '34',
      'icon': Icons.inventory_2_rounded,
      'color': Color(0xFFF9A825),
    },
    {
      'label': 'Pending Posts',
      'value': '18',
      'icon': Icons.pending_actions_rounded,
      'color': Color(0xFFE53935),
    },
    {
      'label': 'Active Orders',
      'value': '57',
      'icon': Icons.local_shipping_rounded,
      'color': Color(0xFF1E88E5),
    },
    {
      'label': 'Deliveries Done',
      'value': '312',
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF00897B),
    },
    {
      'label': 'Points Issued',
      'value': '48.2K',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF2E7D32),
    },
  ];

  final List<Map<String, dynamic>> _communityPosts = [
    {
      'user': 'sandyy',
      'caption': 'Cleaned up the local park today! 🌿',
      'date': 'Apr 23 · 10:15 AM',
      'icon': Icons.park_rounded,
      'color': Color(0xFF66BB6A),
      'status': 'Pending Review',
    },
    {
      'user': 'Ahmed K.',
      'caption': 'My first recycled art piece from plastic bottles.',
      'date': 'Apr 23 · 08:40 AM',
      'icon': Icons.palette_rounded,
      'color': Color(0xFF42A5F5),
      'status': 'Pending Review',
    },
    {
      'user': 'Lina R.',
      'caption': 'Started composting at home! Join me 🌱',
      'date': 'Apr 22 · 05:30 PM',
      'icon': Icons.local_florist_rounded,
      'color': Color(0xFF81C784),
      'status': 'Pending Review',
    },
  ];

  final List<Map<String, dynamic>> _materialRequests = [
    {
      'name': 'Crushed Aluminum Cans',
      'category': 'Metal',
      'seller': 'Omar F.',
      'price': '\$8.00 / kg',
      'points': '80 pts',
      'icon': Icons.settings_rounded,
      'color': Color(0xFF90A4AE),
    },
    {
      'name': 'Clear PET Bottles',
      'category': 'Plastic',
      'seller': 'Nour S.',
      'price': '\$3.50 / kg',
      'points': '35 pts',
      'icon': Icons.local_drink_rounded,
      'color': Color(0xFF4FC3F7),
    },
    {
      'name': 'Old Newspapers Bundle',
      'category': 'Paper',
      'seller': 'Khaled A.',
      'price': '\$2.00 / kg',
      'points': '20 pts',
      'icon': Icons.description_rounded,
      'color': Color(0xFFFFCC02),
    },
  ];

  final List<Map<String, dynamic>> _recentOrders = [
    {
      'id': '#ORD-0041',
      'driver': 'Youssef M.',
      'status': 'In Progress',
      'statusColor': Color(0xFF1E88E5),
    },
    {
      'id': '#ORD-0040',
      'driver': 'Hana B.',
      'status': 'Delivered',
      'statusColor': Color(0xFF43A047),
    },
    {
      'id': '#ORD-0039',
      'driver': 'Ziad R.',
      'status': 'Pending',
      'statusColor': Color(0xFFF9A825),
    },
    {
      'id': '#ORD-0038',
      'driver': 'Maya K.',
      'status': 'Delivered',
      'statusColor': Color(0xFF43A047),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Overview'),
                    const SizedBox(height: 12),
                    _buildStatsGrid(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Community Post Requests'),
                    const SizedBox(height: 12),
                    ..._communityPosts.map(_buildCommunityCard),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Material Upload Requests'),
                    const SizedBox(height: 12),
                    ..._materialRequests.map(_buildMaterialCard),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Orders & Drivers'),
                    const SizedBox(height: 12),
                    _buildOrdersSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_darkGreen, _green, _lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Eco decorative icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.eco_rounded,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.recycling_rounded,
                    color: Colors.white.withValues(alpha: 0.25),
                    size: 16,
                  ),
                ],
              ),
              Icon(
                Icons.water_drop_rounded,
                color: Colors.white.withValues(alpha: 0.25),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Admin avatar
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, Admin',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5252),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: _stats.length,
      itemBuilder: (_, i) {
        final s = _stats[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (s['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  s['icon'] as IconData,
                  color: s['color'] as Color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s['value'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s['label'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommunityCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (post['color'] as Color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    post['icon'] as IconData,
                    color: post['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['user'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        post['date'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Text(
                    post['status'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFF9A825),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post['caption'] as String,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF444444),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    'Approve',
                    _lightGreen,
                    Icons.check_circle_outline_rounded,
                    true,
                    post,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _actionButton(
                    'Reject',
                    const Color(0xFFE53935),
                    Icons.cancel_outlined,
                    false,
                    post,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> mat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (mat['color'] as Color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    mat['icon'] as IconData,
                    color: mat['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mat['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.label_outline_rounded,
                            size: 13,
                            color: Color(0xFF888888),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            mat['category'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 13,
                            color: Color(0xFF888888),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            mat['seller'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            mat['price'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.eco_rounded,
                            size: 13,
                            color: _lightGreen,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            mat['points'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _lightGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    'Approve',
                    _lightGreen,
                    Icons.check_circle_outline_rounded,
                    true,
                    mat,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _actionButton(
                    'Reject',
                    const Color(0xFFE53935),
                    Icons.cancel_outlined,
                    false,
                    mat,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    Color color,
    IconData icon,
    bool isApprove,
    Map<String, dynamic> item,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item['user'] ?? item['name']} — $label'),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isApprove ? 0.1 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: _recentOrders.asMap().entries.map((entry) {
          final i = entry.key;
          final order = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: _green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['id'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          Text(
                            'Driver: ${order['driver']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: (order['statusColor'] as Color).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: order['statusColor'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i < _recentOrders.length - 1)
                const Divider(height: 1, indent: 68, color: Color(0xFFF0F0F0)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.people_alt_rounded, 'label': 'Users'},
      {'icon': Icons.article_rounded, 'label': 'Posts'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Materials'},
      {'icon': Icons.local_shipping_rounded, 'label': 'Orders'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: _green,
          unselectedItemColor: const Color(0xFF999999),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: items
              .map(
                (it) => BottomNavigationBarItem(
                  icon: Icon(it['icon'] as IconData, size: 24),
                  label: it['label'] as String,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
