import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';

class BuyerHomeScreen extends StatefulWidget {
  final String userName;

  const BuyerHomeScreen({super.key, this.userName = 'Dalia'});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  int _currentIndex = 0;
  final int _userPoints = 120;

  // ── Colors ──────────────────────────────────────────────────────────────
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _darkGreen = Color(0xFF1B5E20);
  static const _bgColor = Color(0xFFF5F7F5);
  static const _cardBg = Colors.white;

  // ── Category data ──────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _allCategories = [
    {
      'icon': Icons.local_drink_outlined,
      'label': 'Plastic',
      'color': const Color(0xFF43A047),
    },
    {
      'icon': Icons.description_outlined,
      'label': 'Paper',
      'color': const Color(0xFF66BB6A),
    },
    {
      'icon': Icons.wine_bar_outlined,
      'label': 'Glass',
      'color': const Color(0xFF2E7D32),
    },
    {
      'icon': Icons.settings_outlined,
      'label': 'Metal',
      'color': const Color(0xFF388E3C),
    },
    {
      'icon': Icons.phone_android_outlined,
      'label': 'Electronics',
      'color': const Color(0xFF2E7D32),
    },
    {
      'icon': Icons.checkroom_outlined,
      'label': 'Fabric',
      'color': const Color(0xFF43A047),
    },
    {
      'icon': Icons.inventory_2_outlined,
      'label': 'Cardboard',
      'color': const Color(0xFF66BB6A),
    },
    {
      'icon': Icons.park_outlined,
      'label': 'Wood',
      'color': const Color(0xFF388E3C),
    },
    {
      'icon': Icons.dry_cleaning_outlined,
      'label': 'Denim',
      'color': const Color(0xFF1B5E20),
    },
    {
      'icon': Icons.water_drop_rounded,
      'label': 'Oil',
      'color': const Color(0xFF2E7D32),
    },
    {
      'icon': Icons.circle_outlined,
      'label': 'Tires',
      'color': const Color(0xFF43A047),
    },
    {
      'icon': Icons.star_outline_rounded,
      'label': 'Leather',
      'color': const Color(0xFF1B5E20),
    },
  ];

  // ── Featured items data ────────────────────────────────────────────────
  final List<Map<String, dynamic>> _featuredItems = [
    {
      'name': 'Eco Water Bottle',
      'price': '\$12.00',
      'points': '120 Points',
      'icon': Icons.water_drop_outlined,
      'color': const Color(0xFF81C784),
    },
    {
      'name': 'Recycled Tote Bag',
      'price': '\$15.00',
      'points': '200 Points',
      'icon': Icons.shopping_bag_outlined,
      'color': const Color(0xFFA5D6A7),
    },
    {
      'name': 'Mini Plant',
      'price': '\$10.00',
      'points': '180 Points',
      'icon': Icons.local_florist_outlined,
      'color': const Color(0xFF66BB6A),
    },
    {
      'name': 'Eco Notebook',
      'price': '\$8.00',
      'points': '100 Points',
      'icon': Icons.menu_book_outlined,
      'color': const Color(0xFF4CAF50),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: _currentIndex == 4
            ? _buildCommunityPage()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      _buildCategoriesSection(),
                      const SizedBox(height: 24),
                      _buildPromoBanner(),
                      const SizedBox(height: 24),
                      _buildFeaturedSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildAIChatFAB(context),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left – greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${widget.userName} 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Let\'s shop sustainably for\na better tomorrow 🌿',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // Right – Points badge + Cart
        Row(
          children: [
            // ── Points badge (replaces notification bell) ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco_rounded, color: _green, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$_userPoints',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // ── Cart icon ──
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: _green,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Search Bar ────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search for eco-friendly items...',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune_rounded, color: _green, size: 20),
          ),
        ],
      ),
    );
  }

  // ─── Categories ────────────────────────────────────────────────────────
  Widget _buildCategoriesSection() {
    // Show first 4 categories on home screen
    final displayCategories = _allCategories.take(4).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            GestureDetector(
              onTap: _showAllCategories,
              child: const Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _green,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, size: 18, color: _green),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: displayCategories.map((cat) {
            return _buildCategoryItem(
              icon: cat['icon'] as IconData,
              label: cat['label'] as String,
              color: cat['color'] as Color,
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── All Categories Bottom Sheet ───────────────────────────────────────
  void _showAllCategories() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0D0D0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 12, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Categories',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF666666),
                            size: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0xFFF0F0F0)),

                  // Category list
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _allCategories.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        indent: 76,
                        color: Color(0xFFF5F5F5),
                      ),
                      itemBuilder: (context, index) {
                        final cat = _allCategories[index];
                        return _buildCategoryListTile(cat);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryListTile(Map<String, dynamic> cat) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: (cat['color'] as Color).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(cat['icon'] as IconData, color: _darkGreen, size: 24),
      ),
      title: Text(
        cat['label'] as String,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF999999),
        size: 22,
      ),
      onTap: () {
        Navigator.pop(context);
        // TODO: Navigate to category detail screen
      },
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF444444),
          ),
        ),
      ],
    );
  }

  // ─── Promo Banner ──────────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_darkGreen, _green, _lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left – leaf icon area
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.eco_rounded, size: 44, color: Colors.white),
          ),
          const SizedBox(width: 16),

          // Middle – text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Explore Eco Market',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Discover eco-friendly items\nand shop sustainably.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          // Arrow button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: _green,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Featured Items ────────────────────────────────────────────────────
  Widget _buildFeaturedSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _green,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, size: 18, color: _green),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _featuredItems.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = _featuredItems[index];
              return _buildFeaturedCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> item) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.15),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  size: 48,
                  color: item['color'] as Color,
                ),
              ),
              // Favorite icon
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_outline_rounded,
                    size: 16,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['price'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.eco_rounded, size: 14, color: _lightGreen),
                    const SizedBox(width: 4),
                    Text(
                      item['points'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _lightGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Community Page ────────────────────────────────────────────────────
  Widget _buildCommunityPage() {
    final posts = [
      {'user': 'Sara M.', 'caption': 'Cleaned up the local park today! 🌿 Every action counts.', 'likes': '42', 'icon': Icons.park_rounded, 'color': const Color(0xFF66BB6A)},
      {'user': 'Ahmed K.', 'caption': 'Made art from plastic bottles ♻️ reuse, repurpose, recycle!', 'likes': '87', 'icon': Icons.palette_rounded, 'color': const Color(0xFF42A5F5)},
      {'user': 'Lina R.', 'caption': 'Started composting at home 🌱 It\'s easier than you think!', 'likes': '55', 'icon': Icons.local_florist_rounded, 'color': const Color(0xFF81C784)},
    ];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_darkGreen, _lightGreen], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: Row(
            children: [
              const Icon(Icons.people_alt_rounded, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text('Community', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (_, i) {
              final p = posts[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: (p['color'] as Color).withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      ),
                      child: Center(child: Icon(p['icon'] as IconData, size: 56, color: p['color'] as Color)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['user'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                          const SizedBox(height: 6),
                          Text(p['caption'] as String, style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.4)),
                          const SizedBox(height: 10),
                          Row(children: [
                            const Icon(Icons.favorite_rounded, color: Color(0xFFE57373), size: 18),
                            const SizedBox(width: 4),
                            Text(p['likes'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF888888), fontWeight: FontWeight.w600)),
                            const SizedBox(width: 14),
                            const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF888888), size: 18),
                            const SizedBox(width: 4),
                            const Text('Comment', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
                            const Spacer(),
                            const Icon(Icons.share_rounded, color: Color(0xFF888888), size: 18),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Bottom Navigation ─────────────────────────────────────────────────
  Widget _buildBottomNav() {
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
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: _green,
          unselectedItemColor: const Color(0xFF999999),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 24), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined, size: 24), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_rounded, size: 24), label: 'Rewards'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 24), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined, size: 24), label: 'Community'),
          ],
        ),
      ),
    );
  }

  // ─── AI Chatbot FAB ────────────────────────────────────────────────────
  Widget _buildAIChatFAB(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiChatScreen())),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [_darkGreen, _lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: _green.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: const Icon(Icons.smart_toy_rounded, size: 28, color: Colors.white),
      ),
    );
  }
}
