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
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edge-to-edge Top Waves Banner with cyan bottom line (matching prototype)
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF00A9DA), width: 2),
                      ),
                    ),
                    child: Image.asset(
                      'assets/photography/auth-network-waves.png',
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF6FC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _selectedRole == UserRole.manager
                              ? 'Manager portal'
                              : _selectedRole == UserRole.warehouse
                                  ? 'Warehouse portal'
                                  : 'Employee portal',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF08769C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // 3-Role Segmented Selector Tabs matching prototype
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF036E97),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFDCE6EC)),
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
            color: isSelected ? const Color(0xFFF0F9FD) : const Color(0xFF036E97),
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF00A9DA) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? const Color(0xFF036E97) : Colors.white.withValues(alpha: 0.85),
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
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(width: 3, color: const Color(0xFF00A9DA)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Text(
                text,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF626E79), height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
