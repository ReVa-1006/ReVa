import 'package:flutter/material.dart';
import '../models/signup_model.dart';
import 'role_selection_screen.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEmail = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Username availability state
  bool _checkingUsername = false;
  bool? _usernameAvailable; // null = unchecked

  // ── Simulated taken usernames (replace with real API call) ──────────────────
  static const _takenUsernames = {'admin', 'reva', 'buyer1', 'seller1', 'test'};

  // ─── Colours ────────────────────────────────────────────────────────────────
  static const _green = Color(0xFF2E6B2E);
  static const _darkGreen = Color(0xFF1B5E20);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bg = Color(0xFFF2F4F2);

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Username availability check (debounced) ─────────────────────────────
  void _onUsernameChanged(String value) {
    setState(() {
      _usernameAvailable = null;
      _checkingUsername = false;
    });

    final trimmed = value.trim().toLowerCase();
    if (trimmed.length < 3) return;

    setState(() => _checkingUsername = true);

    // Simulate a 600ms network delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final current = _usernameController.text.trim().toLowerCase();
      if (current != trimmed) return; // user kept typing
      setState(() {
        _checkingUsername = false;
        _usernameAvailable = !_takenUsernames.contains(trimmed);
      });
    });
  }

  // ─── Submit ─────────────────────────────────────────────────────────────────
  void _continue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_usernameAvailable != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose an available username.'),
          backgroundColor: Color(0xFF2E6B2E),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final model = SignupModel(
      fullName: _nameController.text.trim(),
      username: _usernameController.text.trim().toLowerCase(),
      email: _isEmail ? _identifierController.text.trim() : null,
      phoneNumber: !_isEmail ? _identifierController.text.trim() : null,
      password: _passwordController.text,
    );

    // Simulate a brief async action then navigate to OTP
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final verified = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          contactInfo: _identifierController.text.trim(),
          isEmail: _isEmail,
        ),
      ),
    );

    if (verified == true && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RoleSelectionScreen(signup: model)),
      );
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Background image ───────────────────────────────────────────
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Back + Logo ────────────────────────────────────────
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: _green,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: _green.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.recycling_rounded,
                      size: 70,
                      color: _green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ReVa',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _green,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Create your account',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 24),

                  // ── Form card ─────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _green.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Full Name ──────────────────────────────────
                          _FieldLabel('Full Name'),
                          const SizedBox(height: 8),
                          _PillField(
                            controller: _nameController,
                            hintText: 'John Doe',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF7A9A7A),
                              size: 22,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              if (v.trim().split(' ').length < 2) {
                                return 'Enter at least first and last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // ── Username ───────────────────────────────────
                          _FieldLabel('Username'),
                          const SizedBox(height: 8),
                          _PillField(
                            controller: _usernameController,
                            hintText: 'your_username',
                            onChanged: _onUsernameChanged,
                            prefixIcon: _buildUsernameSuffix(),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter a username';
                              }
                              if (v.trim().length < 3) {
                                return 'Username must be at least 3 characters';
                              }
                              final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
                              if (!usernameRegex.hasMatch(v.trim())) {
                                return 'Only letters, numbers, and _ allowed';
                              }
                              return null;
                            },
                          ),
                          if (_usernameAvailable == false)
                            const Padding(
                              padding: EdgeInsets.only(top: 6, left: 16),
                              child: Text(
                                'Username is already taken',
                                style: TextStyle(
                                  color: Color(0xFFCC4444),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          if (_usernameAvailable == true)
                            const Padding(
                              padding: EdgeInsets.only(top: 6, left: 16),
                              child: Text(
                                'Username is available!',
                                style: TextStyle(
                                  color: Color(0xFF2E6B2E),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 18),

                          // ── Email / Phone toggle ───────────────────────
                          Row(
                            children: [
                              _ToggleChip(
                                label: 'Email',
                                selected: _isEmail,
                                onTap: () => setState(() {
                                  _isEmail = true;
                                  _identifierController.clear();
                                }),
                              ),
                              const SizedBox(width: 8),
                              _ToggleChip(
                                label: 'Phone',
                                selected: !_isEmail,
                                onTap: () => setState(() {
                                  _isEmail = false;
                                  _identifierController.clear();
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _PillField(
                            controller: _identifierController,
                            hintText: _isEmail
                                ? 'youremail@example.com'
                                : '+1 234 567 8900',
                            keyboardType: _isEmail
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                            prefixIcon: Icon(
                              _isEmail
                                  ? Icons.mail_outline_rounded
                                  : Icons.phone_outlined,
                              color: const Color(0xFF7A9A7A),
                              size: 22,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return _isEmail
                                    ? 'Please enter your email'
                                    : 'Please enter your phone number';
                              }
                              if (_isEmail) {
                                final emailRegex = RegExp(
                                  r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$',
                                  caseSensitive: false,
                                );
                                if (!emailRegex.hasMatch(v.trim())) {
                                  return 'Enter a valid email address';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // ── Password ───────────────────────────────────
                          _FieldLabel('Password'),
                          const SizedBox(height: 8),
                          _PillField(
                            controller: _passwordController,
                            hintText: '••••••••••',
                            obscureText: _obscurePassword,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF7A9A7A),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (v.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Continue button with gradient ─────────────────────
                  SizedBox(
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
                        onPressed: _isLoading ? null : _continue,
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
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login_rounded, size: 22),
                                  SizedBox(width: 8),
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Back to login ──────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 13.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: _green,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Username suffix icon ────────────────────────────────────────────────
  Widget _buildUsernameSuffix() {
    if (_checkingUsername) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF2E6B2E),
          ),
        ),
      );
    }
    if (_usernameAvailable == true) {
      return const Icon(Icons.check_circle_outline, color: Color(0xFF2E6B2E));
    }
    if (_usernameAvailable == false) {
      return const Icon(Icons.cancel_outlined, color: Color(0xFFCC4444));
    }
    return const Icon(Icons.alternate_email, color: Color(0xFF7A9A7A));
  }
}

// ─── Shared: field label ──────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF2E6B2E),
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ),
    );
  }
}

// ─── Shared: toggle chip ──────────────────────────────────────────────────────
class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
  }
}

// ─── Shared: pill text field ──────────────────────────────────────────────────
class _PillField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const _PillField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Color(0xFF222222)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: const BorderSide(color: Color(0xFFD0E4D0), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: const BorderSide(color: Color(0xFFD0E4D0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          borderSide: const BorderSide(color: Color(0xFF2E6B2E), width: 1.8),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Color(0xFFCC4444), width: 1.2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          borderSide: BorderSide(color: Color(0xFFCC4444), width: 1.5),
        ),
      ),
    );
  }
}
