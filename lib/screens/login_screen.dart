import 'package:flutter/material.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  final Function(User) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  static const Map<UserRole, String> _defaultEmails = {
    UserRole.admin: 'admin@gmail.com',
    UserRole.customer: 'customer@gmail.com',
    UserRole.seller: 'vendor@gmail.com',
  };

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.seller:
        return 'Vendor';
      case UserRole.customer:
        return 'Customer';
    }
  }

  void _handleRoleLogin(UserRole role) {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final user = User(
      id: '${role.name}-${now.millisecondsSinceEpoch}',
      name: '${_roleLabel(role)} User',
      email: _defaultEmails[role]!,
      password: 'password',
      phone: role == UserRole.customer
          ? '+1 (800) 123-4567'
          : '+1 (800) 555-0000',
      role: role,
      address: '123 Market Street',
      createdAt: now,
      isVerified: true,
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() => _isLoading = false);
      widget.onLoginSuccess(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in as ${_roleLabel(role)} (${user.email})'),
        ),
      );
    });
  }

  void _handleSkip() {
    final user = User(
      id: 'guest',
      name: 'Guest User',
      email: 'guest@shophub.com',
      password: '',
      phone: '',
      role: UserRole.customer,
      createdAt: DateTime.now(),
      isVerified: false,
    );
    widget.onLoginSuccess(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B7FBD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => _handleSkip(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // App Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 70,
                  color: Color(0xFF6B7FBD),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SHOPHUB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              // Login Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome to ShopHub.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover Amazing Things Near Around You.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _handleRoleLogin(UserRole.customer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B7FBD),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _handleRoleLogin(UserRole.customer),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFF6B7FBD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF6B7FBD),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Or connect using',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _SocialLoginButton(
                          icon: Icons.email,
                          color: const Color(0xFF3b5998),
                          onTap: () => _handleRoleLogin(UserRole.customer),
                        ),
                        _SocialLoginButton(
                          icon: Icons.mail,
                          color: const Color(0xFF00acee),
                          onTap: () => _handleRoleLogin(UserRole.customer),
                        ),
                        _SocialLoginButton(
                          icon: Icons.g_mobiledata,
                          color: const Color(0xFFdd4b39),
                          onTap: () => _handleRoleLogin(UserRole.customer),
                        ),
                        _SocialLoginButton(
                          icon: Icons.phone_android,
                          color: const Color(0xFF444444),
                          onTap: () => _handleRoleLogin(UserRole.customer),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE4E8F3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick role login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _RoleChip(
                                label: 'Admin Panel',
                                email: _defaultEmails[UserRole.admin]!,
                                color: Colors.deepOrange,
                                onTap: () => _handleRoleLogin(UserRole.admin),
                              ),
                              _RoleChip(
                                label: 'Vendor Dashboard',
                                email: _defaultEmails[UserRole.seller]!,
                                color: Colors.teal,
                                onTap: () => _handleRoleLogin(UserRole.seller),
                              ),
                              _RoleChip(
                                label: 'Customer',
                                email: _defaultEmails[UserRole.customer]!,
                                color: Colors.indigo,
                                onTap: () =>
                                    _handleRoleLogin(UserRole.customer),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Use default Gmail accounts: admin@gmail.com, vendor@gmail.com, customer@gmail.com',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Skip Button
              TextButton(
                onPressed: _handleSkip,
                child: const Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Social Login Button Widget
class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final String email;
  final Color color;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.email,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: color,
              child: const Icon(Icons.login, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
