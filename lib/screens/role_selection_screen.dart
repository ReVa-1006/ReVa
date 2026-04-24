import 'package:flutter/material.dart';
import '../models/signup_model.dart';
import 'buyer_home_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  final SignupModel signup;

  const RoleSelectionScreen({super.key, required this.signup});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole; // 'buyer' | 'seller'

  static const _green = Color(0xFF2E6B2E);
  static const _darkGreen = Color(0xFF1B5E20);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bg = Color(0xFFF2F4F2);

  void _confirm() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role to continue.'),
          backgroundColor: Color(0xFF2E6B2E),
        ),
      );
      return;
    }

    final finalModel = widget.signup.copyWith(role: _selectedRole);
    debugPrint('Registration complete: $finalModel');

    if (_selectedRole == 'buyer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BuyerHomeScreen(userName: finalModel.fullName),
        ),
      );
    } else {
      // TODO: Navigate to SellerHomeScreen when implemented
      debugPrint('Seller home screen not yet implemented.');
    }
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Back ──────────────────────────────────────────────
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

                  // ── Logo ──────────────────────────────────────────────
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
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _green,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Heading ───────────────────────────────────────────
                  const Text(
                    'I am a...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose how you want to use ReVa',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 36),

                  // ── Role cards ────────────────────────────────────────
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _RoleCard(
                            role: 'buyer',
                            icon: Icons.shopping_cart_outlined,
                            title: 'Buyer',
                            description:
                                'Discover and purchase materials for recycling',
                            selected: _selectedRole == 'buyer',
                            onTap: () =>
                                setState(() => _selectedRole = 'buyer'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _RoleCard(
                            role: 'seller',
                            icon: Icons.storefront_outlined,
                            title: 'Seller',
                            description:
                                'List and sell your unusable materials',
                            selected: _selectedRole == 'seller',
                            onTap: () =>
                                setState(() => _selectedRole = 'seller'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Confirm button ────────────────────────────────────
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
                        onPressed: _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login_rounded, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Get Started',
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Role selection card ──────────────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final String role;
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  static const _green = Color(0xFF2E6B2E);
  static const _darkGreen = Color(0xFF1B5E20);
  static const _lightGreen = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [_darkGreen, _green, _lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? _darkGreen : const Color(0xFFD0E4D0),
            width: selected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _green.withValues(alpha: selected ? 0.25 : 0.06),
              blurRadius: selected ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.15)
                    : const Color(0xFFE8F0E8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: selected ? Colors.white : _green,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : _green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: selected
                    ? Colors.white.withValues(alpha: 0.85)
                    : const Color(0xFF666666),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: selected ? Colors.white : const Color(0xFFB0C8B0),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 16, color: _green)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
