import 'package:flutter/material.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _step = 0; // 0=enter contact, 1=new password
  bool _isLoading = false;
  bool _isEmail = true;

  final _formKey = GlobalKey<FormState>();
  final _passFormKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  static const _green = Color(0xFF2E6B2E);
  static const _darkGreen = Color(0xFF1B5E20);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bg = Color(0xFFF2F4F2);

  @override
  void dispose() {
    _contactController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // ─── Send code then navigate to OTP ────────────────────────────────────────
  void _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // TODO: call your API to send the code
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final verified = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          contactInfo: _contactController.text.trim(),
          isEmail: _isEmail,
        ),
      ),
    );

    if (verified == true && mounted) {
      setState(() => _step = 1);
    }
  }

  // ─── Reset password ────────────────────────────────────────────────────────
  void _resetPassword() {
    if (!_passFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: call your reset password API
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully!'),
          backgroundColor: _green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: _green,
                        ),
                        onPressed: () {
                          if (_step > 0) {
                            setState(() => _step--);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'ReVa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _green,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _step == 0 ? _buildStep1() : _buildStep2(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  STEP 1 — Enter email or phone
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey(0),
        children: [
          const SizedBox(height: 24),
          _heroIcon(Icons.lock_reset_rounded),
          const SizedBox(height: 24),
          const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Enter your email address or phone number\nand we'll send you a code to reset\nyour password.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // ── Email / Phone toggle ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _toggleChip(
                'Email',
                _isEmail,
                () => setState(() {
                  _isEmail = true;
                  _contactController.clear();
                }),
              ),
              const SizedBox(width: 12),
              _toggleChip(
                'Phone',
                !_isEmail,
                () => setState(() {
                  _isEmail = false;
                  _contactController.clear();
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _label(_isEmail ? 'Email Address' : 'Phone Number'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _contactController,
            keyboardType: _isEmail
                ? TextInputType.emailAddress
                : TextInputType.phone,
            style: const TextStyle(fontSize: 15, color: Color(0xFF222222)),
            decoration: _inputDecoration(
              hint: _isEmail ? 'hello@reva.eco' : '+1 234 567 8900',
              prefix: _isEmail
                  ? Icons.mail_outline_rounded
                  : Icons.phone_outlined,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return _isEmail
                    ? 'Please enter your email address'
                    : 'Please enter your phone number';
              }
              if (_isEmail) {
                final regex = RegExp(
                  r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$',
                  caseSensitive: false,
                );
                if (!regex.hasMatch(v.trim()))
                  return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          _gradientButton(
            label: 'Send Code',
            icon: Icons.send_rounded,
            onTap: _sendCode,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Remembered your password? ",
                style: TextStyle(color: Color(0xFF555555), fontSize: 14),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: _green,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  STEP 2 — Create new password
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildStep2() {
    final pass = _newPassController.text;
    final has8 = pass.length >= 8;
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pass);

    return Form(
      key: _passFormKey,
      child: Column(
        key: const ValueKey(1),
        children: [
          const SizedBox(height: 24),
          _heroIcon(Icons.lock_reset_rounded),
          const SizedBox(height: 24),
          const Text(
            'Create New Password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your new password must be different\nfrom previous passwords.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _green.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('New Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newPassController,
                  obscureText: _obscureNew,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF222222),
                  ),
                  decoration: _inputDecoration(
                    hint: '••••••••',
                    prefix: Icons.lock_outline_rounded,
                    suffix: GestureDetector(
                      onTap: () => setState(() => _obscureNew = !_obscureNew),
                      child: Icon(
                        _obscureNew
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF7A9A7A),
                        size: 22,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please enter a password';
                    if (v.length < 8)
                      return 'Password must be at least 8 characters';
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v))
                      return 'Must contain at least 1 special character';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _label('Confirm Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPassController,
                  obscureText: _obscureConfirm,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF222222),
                  ),
                  decoration: _inputDecoration(
                    hint: '••••••••',
                    prefix: Icons.lock_outline_rounded,
                    suffix: GestureDetector(
                      onTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF7A9A7A),
                        size: 22,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please confirm your password';
                    if (v != _newPassController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _reqChip('8+ CHARACTERS', has8),
                    const SizedBox(width: 8),
                    _reqChip('1 SPECIAL', hasSpecial),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _gradientButton(
            label: 'Reset Password',
            icon: Icons.arrow_forward_rounded,
            onTap: _resetPassword,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SHARED WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _heroIcon(IconData icon) => Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: _green.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 52, color: _green),
      ),
      Positioned(
        right: -4,
        top: -4,
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: _green,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    ),
  );

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
      prefixIcon: Icon(prefix, color: const Color(0xFF7A9A7A), size: 22),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFFD0E4D0), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFFD0E4D0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: _green, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFFCC4444), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Color(0xFFCC4444), width: 1.5),
      ),
    );
  }

  Widget _toggleChip(String label, bool selected, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [_darkGreen, _green, _lightGreen],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: selected ? null : const Color(0xFFE8F0E8),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : _green,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      );

  Widget _gradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_darkGreen, _green, _lightGreen],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: _green.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.transparent,
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(icon, size: 22),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _reqChip(String text, bool met) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: met ? _green.withValues(alpha: 0.1) : const Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: met ? _green : const Color(0xFFD0D0D0),
        width: 1,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: met ? _green : const Color(0xFF999999),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: met ? _green : const Color(0xFF999999),
          ),
        ),
      ],
    ),
  );
}
