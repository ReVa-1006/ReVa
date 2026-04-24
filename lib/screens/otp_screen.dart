import 'dart:async';
import 'package:flutter/material.dart';

/// Reusable OTP verification screen.
/// Returns `true` via Navigator.pop when verification succeeds.
///
/// Usage:
/// ```dart
/// final verified = await Navigator.push<bool>(context,
///   MaterialPageRoute(builder: (_) => OtpVerificationScreen(
///     contactInfo: 'user@example.com', isEmail: true)));
/// if (verified == true) { /* proceed */ }
/// ```
class OtpVerificationScreen extends StatefulWidget {
  final String contactInfo;
  final bool isEmail;

  const OtpVerificationScreen({
    super.key,
    required this.contactInfo,
    required this.isEmail,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  int _secondsLeft = 60;
  Timer? _timer;

  static const _green = Color(0xFF2E6B2E);
  static const _darkGreen = Color(0xFF1B5E20);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bg = Color(0xFFF2F4F2);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  void _resend() {
    for (final c in _otpControllers) c.clear();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code resent!'), backgroundColor: _green),
    );
  }

  void _verify() {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the full 4-digit code'),
          backgroundColor: _green,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    // TODO: verify code with backend
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.isEmail ? 'Email' : 'Mobile';
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
                        onPressed: () => Navigator.pop(context, false),
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
                // ── Body ────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // ── Hero icon ─────────────────────────────
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: _green.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.mark_email_read_outlined,
                                size: 52,
                                color: _green,
                              ),
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
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Verify $label',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            text: "We've sent a 4-digit code to your\n",
                            children: [
                              TextSpan(
                                text: widget.contactInfo,
                                style: const TextStyle(
                                  color: _green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: '. Please enter it below.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // ── OTP boxes ─────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (i) => Container(
                              width: 56,
                              height: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              child: TextField(
                                controller: _otpControllers[i],
                                focusNode: _otpFocusNodes[i],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF222222),
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD0E4D0),
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD0E4D0),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: _green,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (v) {
                                  if (v.isNotEmpty && i < 3)
                                    _otpFocusNodes[i + 1].requestFocus();
                                  if (v.isEmpty && i > 0)
                                    _otpFocusNodes[i - 1].requestFocus();
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ── Verify button ─────────────────────────
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
                              onPressed: _isLoading ? null : _verify,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Verify',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.verified_outlined, size: 22),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // ── Resend / Timer ────────────────────────
                        _secondsLeft > 0
                            ? Text(
                                'Resend code in ${_secondsLeft}s',
                                style: const TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 14,
                                ),
                              )
                            : GestureDetector(
                                onTap: _resend,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.refresh_rounded,
                                      size: 18,
                                      color: _green,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Resend Code',
                                      style: TextStyle(
                                        color: _green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 36),
                        // ── Secure verification badge ─────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _green.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _green.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.shield_outlined,
                                  color: _green,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Secure Verification',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF222222),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Your account security is our top\neco-priority.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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
}
