import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_role.dart';
import '../../providers/aeconnect_provider.dart';
import '../shell/main_shell_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.employee;

  // Controllers
  final _employeeIdController = TextEditingController(text: 'EMP104');
  final _managerEmailController = TextEditingController(text: 'priya.mehta@aeconnect.com');
  final _managerPasswordController = TextEditingController(text: 'admin123');
  final _warehouseEmailController = TextEditingController(text: 'warehouse@aeconnect.com');
  final _warehousePasswordController = TextEditingController(text: 'wh1234');

  @override
  void dispose() {
    _employeeIdController.dispose();
    _managerEmailController.dispose();
    _managerPasswordController.dispose();
    _warehouseEmailController.dispose();
    _warehousePasswordController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    final empId = _employeeIdController.text.trim().isEmpty ? 'EMP104' : _employeeIdController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(employeeId: empId),
      ),
    );
  }

  void _onManagerLogin() {
    final provider = context.read<AEConnectProvider>();
    provider.login(UserRole.manager);
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed in as Manager (Priya Mehta - ASM001)'),
        backgroundColor: AppColors.statusSuccessFg,
      ),
    );
  }

  void _onWarehouseLogin() {
    final provider = context.read<AEConnectProvider>();
    provider.login(UserRole.warehouse);
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed in as Warehouse Controller (Amit Shah - WH001)'),
        backgroundColor: AppColors.statusSuccessFg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visual Waves Banner matching prototype
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/photography/auth-network-waves.png',
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Top Brand Header with Portal Tag matching design
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: AppColors.primary,
                          ),
                          children: [
                            TextSpan(text: 'AE '),
                            TextSpan(text: 'C', style: TextStyle(color: AppColors.textPrimary)),
                            TextSpan(text: 'O', style: TextStyle(color: AppColors.accent)),
                            TextSpan(text: 'NNECT', style: TextStyle(color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                        ),
                        child: const Text(
                          'Employee portal',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 3-Role Segmented Selector Tabs matching screenshot
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF02587A), // Deep teal container
                      borderRadius: BorderRadius.circular(6),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        _buildTabItem(UserRole.employee, 'Employee'),
                        _buildTabItem(UserRole.manager, 'Manager / Admin'),
                        _buildTabItem(UserRole.warehouse, 'Warehouse'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Conditional Forms for the 3 Roles
                  if (_selectedRole == UserRole.employee) ...[
                    _buildEmployeeForm(),
                  ] else if (_selectedRole == UserRole.manager) ...[
                    _buildManagerForm(),
                  ] else ...[
                    _buildWarehouseForm(),
                  ],

                  const SizedBox(height: 32),
                  // Bottom prototype disclaimer
                  const Center(
                    child: Text(
                      'Prototype · Records stay in this browser.\nOTP, email and account verification are simulated.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppColors.textLight, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(UserRole role, String title) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFF02587A),
            border: isSelected
                ? const Border(bottom: BorderSide(color: AppColors.accent, width: 3))
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? AppColors.primary : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  // --- 1. Employee Form (OTP Based) ---
  Widget _buildEmployeeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Employee sign in',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Use your employee ID or work email.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _employeeIdController,
          decoration: const InputDecoration(
            labelText: 'Employee ID or email *',
            hintText: 'EMP104 or your.name@example.com',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _onSendOtp,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Send OTP', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                SizedBox(width: 6),
                Icon(Icons.chevron_right_rounded, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildHelperBox('ℹ️ Use EMP104 or EMP105. The local demo verification code is 123456.'),
      ],
    );
  }

  // --- 2. Manager / Admin Form ---
  Widget _buildManagerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign in',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Manager account',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _managerEmailController,
          decoration: const InputDecoration(
            labelText: 'Work email *',
            hintText: 'priya.mehta@aeconnect.com',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _managerPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Demo password *',
            hintText: '••••••••',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _onManagerLogin,
            child: const Text('Sign in', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
        const SizedBox(height: 16),
        _buildHelperBox('Any 4+ character sample password. It is never saved. This switches the local demo role; it does not sign in to the live ERP.'),
      ],
    );
  }

  // --- 3. Warehouse Form ---
  Widget _buildWarehouseForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign in',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Warehouse account',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _warehouseEmailController,
          decoration: const InputDecoration(
            labelText: 'Work email *',
            hintText: 'warehouse@aeconnect.com',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _warehousePasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Demo password *',
            hintText: '••••••••',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _onWarehouseLogin,
            child: const Text('Sign in', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
        const SizedBox(height: 16),
        _buildHelperBox('Any 4+ character sample password. It is never saved. This switches the local demo role; it does not sign in to the live ERP.'),
      ],
    );
  }

  Widget _buildHelperBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }
}
