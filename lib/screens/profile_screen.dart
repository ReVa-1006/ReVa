import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── Theme colors (matching driver dashboard) ─────────────────────────────
  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bgColor = Color(0xFFF0F5F0);

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildStatsCards(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Account'),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _SettingsItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: 'Name, phone, email',
                        color: _lightGreen,
                      ),
                      _SettingsItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your password',
                        color: const Color(0xFF1E88E5),
                      ),
                      _SettingsItem(
                        icon: Icons.location_on_outlined,
                        title: 'Address Book',
                        subtitle: 'Saved pickup locations',
                        color: const Color(0xFFF9A825),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Preferences'),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _SettingsItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: 'Push & email alerts',
                        color: const Color(0xFFEF5350),
                        trailing: _buildToggle(_notificationsEnabled, (v) {
                          setState(() => _notificationsEnabled = v);
                        }),
                      ),
                      _SettingsItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Toggle dark appearance',
                        color: const Color(0xFF6A1B9A),
                        trailing: _buildToggle(_darkModeEnabled, (v) {
                          setState(() => _darkModeEnabled = v);
                        }),
                      ),
                      _SettingsItem(
                        icon: Icons.language_rounded,
                        title: 'Language',
                        subtitle: 'English',
                        color: const Color(0xFF00897B),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Support'),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _SettingsItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Help Center',
                        subtitle: 'FAQs & guides',
                        color: const Color(0xFF1E88E5),
                      ),
                      _SettingsItem(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Contact Us',
                        subtitle: 'Get in touch',
                        color: _lightGreen,
                      ),
                      _SettingsItem(
                        icon: Icons.description_outlined,
                        title: 'Terms & Privacy',
                        subtitle: 'Legal documents',
                        color: const Color(0xFF78909C),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildLogoutButton(),
                    const SizedBox(height: 12),
                    Text(
                      'ReVa v1.0.0',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade400),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ────────────────────────────────────────────────────────
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
          // Top row with back & settings
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              const Spacer(),
              const Text('Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Avatar
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.5), width: 3),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              child: const Text('YM',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Youssef M.',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_shipping_rounded,
                    color: Colors.white70, size: 14),
                SizedBox(width: 6),
                Text('Driver',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text('youssef.m@reva.app',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
        ],
      ),
    );
  }

  // ── Stats Cards ───────────────────────────────────────────────────────────
  Widget _buildStatsCards() {
    final stats = [
      {
        'label': 'Total Trips',
        'value': '128',
        'icon': Icons.route_rounded,
        'color': _lightGreen,
      },
      {
        'label': 'Earnings',
        'value': '\$1,240',
        'icon': Icons.attach_money_rounded,
        'color': const Color(0xFF1E88E5),
      },
      {
        'label': 'Rating',
        'value': '4.9',
        'icon': Icons.star_rounded,
        'color': const Color(0xFFF9A825),
      },
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
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                Icon(s['icon'] as IconData,
                    color: s['color'] as Color, size: 24),
                const SizedBox(height: 6),
                Text(s['value'] as String,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A))),
                Text(s['label'] as String,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF888888)),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Section title ─────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A))),
    );
  }

  // ── Settings group ────────────────────────────────────────────────────────
  Widget _buildSettingsGroup(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: item.trailing == null ? () {} : null,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            Icon(item.icon, color: item.color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A))),
                            Text(item.subtitle,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF999999))),
                          ],
                        ),
                      ),
                      item.trailing ??
                          Icon(Icons.chevron_right_rounded,
                              color: Colors.grey.shade400, size: 22),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                    height: 1,
                    indent: 70,
                    color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Toggle switch ─────────────────────────────────────────────────────────
  Widget _buildToggle(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: value
              ? const LinearGradient(colors: [_darkGreen, _lightGreen])
              : null,
          color: value ? null : Colors.grey.shade300,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  // ── Logout button ─────────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: const Text('Log Out',
                style: TextStyle(fontWeight: FontWeight.w700)),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel',
                    style: TextStyle(color: Color(0xFF888888))),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement logout logic
                },
                child: const Text('Log Out',
                    style: TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFE53935).withValues(alpha: 0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded,
                color: Color(0xFFE53935), size: 18),
            SizedBox(width: 8),
            Text('Log Out',
                style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

// ── Settings item model ───────────────────────────────────────────────────────
class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;

  _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.trailing,
  });
}
