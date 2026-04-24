import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final int totalTrips;
  final double rating;

  const ProfileScreen({
    super.key,
    this.userName = 'User',
    this.userEmail = 'user@reva.app',
    this.userRole = 'Driver',
    this.totalTrips = 0,
    this.rating = 0.0,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bgColor = Color(0xFFF0F5F0);

  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  // -- Translations (English & Arabic only) -----------------------------------
  static const _translations = {
    'profile': {'English': 'Profile', 'العربية': 'الملف الشخصي'},
    'account': {'English': 'Account', 'العربية': 'الحساب'},
    'editProfile': {'English': 'Edit Profile', 'العربية': 'تعديل الملف'},
    'editProfileSub': {'English': 'Name, phone, email', 'العربية': 'الاسم، الهاتف، البريد'},
    'changePassword': {'English': 'Change Password', 'العربية': 'تغيير كلمة المرور'},
    'changePasswordSub': {'English': 'Update your password', 'العربية': 'تحديث كلمة المرور'},
    'preferences': {'English': 'Preferences', 'العربية': 'الإعدادات'},
    'notifications': {'English': 'Notifications', 'العربية': 'الإشعارات'},
    'enabled': {'English': 'Enabled', 'العربية': 'مفعّل'},
    'disabled': {'English': 'Disabled', 'العربية': 'معطّل'},
    'darkMode': {'English': 'Dark Mode', 'العربية': 'الوضع الداكن'},
    'on': {'English': 'On', 'العربية': 'مفعّل'},
    'off': {'English': 'Off', 'العربية': 'معطّل'},
    'language': {'English': 'Language', 'العربية': 'اللغة'},
    'support': {'English': 'Support', 'العربية': 'الدعم'},
    'contactUs': {'English': 'Contact Us', 'العربية': 'اتصل بنا'},
    'contactUsSub': {'English': 'Get in touch', 'العربية': 'تواصل معنا'},
    'terms': {'English': 'Terms & Privacy', 'العربية': 'الشروط والخصوصية'},
    'termsSub': {'English': 'Legal documents', 'العربية': 'مستندات قانونية'},
    'logout': {'English': 'Log Out', 'العربية': 'تسجيل الخروج'},
    'logoutConfirm': {'English': 'Are you sure you want to log out?', 'العربية': 'هل أنت متأكد من تسجيل الخروج؟'},
    'cancel': {'English': 'Cancel', 'العربية': 'إلغاء'},
    'totalTrips': {'English': 'Total Trips', 'العربية': 'إجمالي الرحلات'},
    'rating': {'English': 'Rating', 'العربية': 'التقييم'},
    'saveChanges': {'English': 'Save Changes', 'العربية': 'حفظ التغييرات'},
    'updatePassword': {'English': 'Update Password', 'العربية': 'تحديث كلمة المرور'},
    'selectLanguage': {'English': 'Select Language', 'العربية': 'اختر اللغة'},
  };

  String _t(String key) =>
      _translations[key]?[_selectedLanguage] ??
      _translations[key]?['English'] ??
      key;

  // -- Mutable profile state --------------------------------------------------
  late String _displayName;
  late String _displayEmail;
  late String _displayPhone;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _displayName = widget.userName;
    _displayEmail = widget.userEmail;
    _displayPhone = '+20 100 123 4567';
    _nameController = TextEditingController(text: _displayName);
    _emailController = TextEditingController(text: _displayEmail);
    _phoneController = TextEditingController(text: _displayPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = _displayName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? const Color(0xFFE53935) : _green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkModeEnabled ? const Color(0xFF121212) : _bgColor,
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
                    _buildSectionTitle(_t('account')),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _SI(
                        Icons.person_outline_rounded,
                        _t('editProfile'),
                        _t('editProfileSub'),
                        _lightGreen,
                        onTap: _showEditProfileSheet,
                      ),
                      _SI(
                        Icons.lock_outline_rounded,
                        _t('changePassword'),
                        _t('changePasswordSub'),
                        const Color(0xFF1E88E5),
                        onTap: _showChangePasswordDialog,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSectionTitle(_t('preferences')),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _SI(
                        Icons.notifications_none_rounded,
                        _t('notifications'),
                        _notificationsEnabled ? _t('enabled') : _t('disabled'),
                        const Color(0xFFEF5350),
                        trailing: _buildToggle(_notificationsEnabled, (v) {
                          setState(() => _notificationsEnabled = v);
                          _snack(v ? _t('enabled') : _t('disabled'));
                        }),
                      ),
                      _SI(
                        Icons.dark_mode_outlined,
                        _t('darkMode'),
                        _darkModeEnabled ? _t('on') : _t('off'),
                        const Color(0xFF6A1B9A),
                        trailing: _buildToggle(_darkModeEnabled, (v) {
                          setState(() => _darkModeEnabled = v);
                          _snack(v ? _t('on') : _t('off'));
                        }),
                      ),
                      _SI(
                        Icons.language_rounded,
                        _t('language'),
                        _selectedLanguage,
                        const Color(0xFF00897B),
                        onTap: _showLanguagePicker,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSectionTitle(_t('support')),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _SI(
                        Icons.chat_bubble_outline_rounded,
                        _t('contactUs'),
                        _t('contactUsSub'),
                        _lightGreen,
                        onTap: _showContactUsSheet,
                      ),
                      _SI(
                        Icons.description_outlined,
                        _t('terms'),
                        _t('termsSub'),
                        const Color(0xFF78909C),
                        onTap: _showTermsSheet,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildLogoutButton(),
                    const SizedBox(height: 12),
                    Text(
                      'ReVa v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
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

  // ── Header (static, fixed height) ─────────────────────────────────────────
  Widget _buildProfileHeader() {
    return SizedBox(
      height: 120,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_darkGreen, _green, _lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _t('profile'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 34),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _displayEmail,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_shipping_rounded,
                        color: Colors.white70,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.userRole,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Stats ─────────────────────────────────────────────────────────────────
  Widget _buildStatsCards() {
    final stats = [
      {
        'label': _t('totalTrips'),
        'value': '${widget.totalTrips}',
        'icon': Icons.route_rounded,
        'color': _lightGreen,
      },
      {
        'label': _t('rating'),
        'value': '${widget.rating}',
        'icon': Icons.star_rounded,
        'color': const Color(0xFFF9A825),
      },
    ];

    final cardColor = _darkModeEnabled ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = _darkModeEnabled ? Colors.white : const Color(0xFF1A1A1A);
    return Row(
      children: stats
          .map(
            (s) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: s == stats.last ? 0 : 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      s['icon'] as IconData,
                      color: s['color'] as Color,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s['value'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    Text(
                      s['label'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF888888),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSectionTitle(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      t,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: _darkModeEnabled ? Colors.white : const Color(0xFF1A1A1A),
      ),
    ),
  );

  Widget _buildSettingsGroup(List<_SI> items) {
    final cardColor = _darkModeEnabled ? const Color(0xFF1E1E1E) : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
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
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: item.color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _darkModeEnabled
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                            Text(
                              item.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ),
                      item.trailing ??
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey.shade400,
                            size: 22,
                          ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(height: 1, indent: 70, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }

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

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF888888)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (r) => false);
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE53935).withValues(alpha: 0.2),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFE53935), size: 18),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Edit Profile — updates header name/email/initials on save ─────────────
  void _showEditProfileSheet() {
    _nameController.text = _displayName;
    _emailController.text = _displayEmail;
    _phoneController.text = _displayPhone;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          String? nameErr, emailErr, phoneErr;
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),
                  _field(
                    'Full Name',
                    _nameController,
                    Icons.person_outline_rounded,
                    nameErr,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Email',
                    _emailController,
                    Icons.email_outlined,
                    emailErr,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Phone',
                    _phoneController,
                    Icons.phone_outlined,
                    phoneErr,
                    keyboard: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _gradientBtn('Save Changes', () {
                    final n = _nameController.text.trim();
                    final e = _emailController.text.trim();
                    final p = _phoneController.text.trim();
                    bool valid = true;
                    if (n.isEmpty) {
                      nameErr = 'Name is required';
                      valid = false;
                    }
                    if (e.isEmpty || !e.contains('@')) {
                      emailErr = 'Valid email required';
                      valid = false;
                    }
                    if (p.isEmpty) {
                      phoneErr = 'Phone is required';
                      valid = false;
                    }
                    if (!valid) {
                      setSheetState(() {});
                      return;
                    }
                    setState(() {
                      _displayName = n;
                      _displayEmail = e;
                      _displayPhone = p;
                    });
                    Navigator.pop(ctx);
                    _snack('Profile updated successfully');
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Change Password — validates fields ────────────────────────────────────
  void _showChangePasswordDialog() {
    final curCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confCtrl = TextEditingController();
    bool showCur = false, showNew = false, showConf = false;
    String? curErr, newErr, confErr;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Change Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),
                  _pwField(
                    'Current Password',
                    curCtrl,
                    showCur,
                    curErr,
                    () => setSheetState(() => showCur = !showCur),
                  ),
                  const SizedBox(height: 12),
                  _pwField(
                    'New Password',
                    newCtrl,
                    showNew,
                    newErr,
                    () => setSheetState(() => showNew = !showNew),
                  ),
                  const SizedBox(height: 12),
                  _pwField(
                    'Confirm Password',
                    confCtrl,
                    showConf,
                    confErr,
                    () => setSheetState(() => showConf = !showConf),
                  ),
                  const SizedBox(height: 20),
                  _gradientBtn('Update Password', () {
                    curErr = newErr = confErr = null;
                    bool valid = true;
                    if (curCtrl.text.isEmpty) {
                      curErr = 'Enter current password';
                      valid = false;
                    }
                    if (newCtrl.text.length < 6) {
                      newErr = 'Min 6 characters';
                      valid = false;
                    }
                    if (confCtrl.text != newCtrl.text) {
                      confErr = 'Passwords do not match';
                      valid = false;
                    }
                    if (!valid) {
                      setSheetState(() {});
                      return;
                    }
                    Navigator.pop(ctx);
                    _snack('Password changed successfully');
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Language Picker ───────────────────────────────────────────────────────
  void _showLanguagePicker() {
    final langs = ['English', 'العربية'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            ...langs.map(
              (l) => ListTile(
                leading: Icon(
                  l == _selectedLanguage
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: _green,
                ),
                title: Text(
                  l,
                  style: TextStyle(
                    fontWeight: l == _selectedLanguage
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedLanguage = l);
                  Navigator.pop(context);
                  _snack('Language set to $l');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Contact Us ────────────────────────────────────────────────────────────
  void _showContactUsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _contactTile(Icons.email_outlined, 'Email', 'support@reva.app'),
            _contactTile(Icons.phone_outlined, 'Phone', '+20 111 934 1678'),
          ],
        ),
      ),
    );
  }

  Widget _contactTile(IconData icon, String title, String value) => ListTile(
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _lightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: _green, size: 20),
    ),
    title: Text(
      title,
      style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
    ),
    subtitle: Text(
      value,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
      ),
    ),
  );

  // ── Terms & Privacy ───────────────────────────────────────────────────────
  void _showTermsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, sc) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: sc,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Terms & Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              const Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'By using the ReVa application, you agree to these terms. ReVa provides a platform connecting recycling material sellers, buyers, and delivery drivers. Users must provide accurate information and comply with local regulations regarding waste management and recycling.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We collect and process personal data to provide our services. This includes your name, contact information, location data, and transaction history. We do not sell your data to third parties. Your data is stored securely and you may request its deletion at any time.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Shared widgets ────────────────────────────────────────────────────────
  Widget _field(
    String label,
    TextEditingController c,
    IconData icon,
    String? err, {
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        errorText: err,
        prefixIcon: Icon(icon, color: _green, size: 20),
        filled: true,
        fillColor: _bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
      ),
    );
  }

  Widget _pwField(
    String label,
    TextEditingController c,
    bool show,
    String? err,
    VoidCallback toggle,
  ) {
    return TextField(
      controller: c,
      obscureText: !show,
      decoration: InputDecoration(
        labelText: label,
        errorText: err,
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: _green,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: _bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
      ),
    );
  }

  Widget _gradientBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_darkGreen, _green, _lightGreen],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _SI {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;
  final VoidCallback? onTap;
  _SI(
    this.icon,
    this.title,
    this.subtitle,
    this.color, {
    this.trailing,
    this.onTap,
  });
}
