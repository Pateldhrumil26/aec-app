import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../components/status_pill.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isPunchedIn = true;
  String _punchInTime = '09:30 AM';
  String _selectedMonth = 'November 2026';

  final List<Map<String, dynamic>> _punches = [
    {
      'date': 'Today, 26 Nov 2026',
      'in': '09:30 AM',
      'out': 'In progress',
      'hours': '3h 15m',
      'status': 'Present',
      'isLate': false,
      'inLocation': '28.6280° N, 77.3649° E · Sector 62, Noida (GPS)',
      'outLocation': 'Pending',
    },
    {
      'date': 'Wed, 25 Nov 2026',
      'in': '09:28 AM',
      'out': '06:34 PM',
      'hours': '9h 06m',
      'status': 'Present',
      'isLate': false,
      'inLocation': '28.6280° N, 77.3649° E · Sector 62, Noida (GPS)',
      'outLocation': '28.6285° N, 77.3655° E · Sector 62, Noida (GPS)',
    },
    {
      'date': 'Tue, 24 Nov 2026',
      'in': '09:42 AM',
      'out': '06:30 PM',
      'hours': '8h 48m',
      'status': 'Present',
      'isLate': true,
      'inLocation': '28.6282° N, 77.3650° E · Sector 62, Noida (GPS)',
      'outLocation': '28.6280° N, 77.3649° E · Sector 62, Noida (GPS)',
    },
    {
      'date': 'Mon, 23 Nov 2026',
      'in': '09:25 AM',
      'out': '06:40 PM',
      'hours': '9h 15m',
      'status': 'Present',
      'isLate': false,
      'inLocation': '28.6280° N, 77.3649° E · Sector 62, Noida (GPS)',
      'outLocation': '28.6280° N, 77.3649° E · Sector 62, Noida (GPS)',
    },
    {
      'date': 'Fri, 20 Nov 2026',
      'in': '09:35 AM',
      'out': '01:30 PM',
      'hours': '3h 55m',
      'status': 'Half Day',
      'isLate': false,
      'inLocation': '28.6280° N, 77.3649° E · Sector 62, Noida (GPS)',
      'outLocation': '28.6280° N, 77.3649° E · Sector 62, Noida (GPS)',
    },
  ];

  void _showRegularizationDialog() {
    final dateCtrl = TextEditingController(text: '20 Nov 2026');
    final inCtrl = TextEditingController(text: '09:30 AM');
    final outCtrl = TextEditingController(text: '06:00 PM');
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request regularization', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Attendance date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              TextField(controller: dateCtrl, decoration: const InputDecoration()),
              const SizedBox(height: 12),
              const Text('Corrected punch-in', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              TextField(controller: inCtrl, decoration: const InputDecoration()),
              const SizedBox(height: 12),
              const Text('Corrected punch-out', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              TextField(controller: outCtrl, decoration: const InputDecoration()),
              const SizedBox(height: 12),
              const Text('Reason for correction', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              TextField(controller: reasonCtrl, maxLines: 2, decoration: const InputDecoration(hintText: 'e.g. Field visit biometric delay')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Regularization request submitted to manager.')),
              );
            },
            child: const Text('Submit request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Attendance & work hours'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Head
            const Text(
              'Attendance & work hours',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            const SizedBox(height: 4),
            const Text(
              'Daily punches, monthly hours and correction requests.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            // Card 1: hr-punch-card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('26 Nov 2026', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
                      StatusPill(label: _isPunchedIn ? 'Punched In' : 'Punched Out'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isPunchedIn ? 'Punched in' : 'Record attendance',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.navy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isPunchedIn
                        ? 'Punched in at $_punchInTime. Punch out when you finish.'
                        : 'Punch with a device location stamp.',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isPunchedIn = !_isPunchedIn;
                            });
                          },
                          icon: const Icon(Icons.location_on, size: 16),
                          label: Text(_isPunchedIn ? 'GPS punch out' : 'GPS punch in'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isPunchedIn ? AppColors.danger : AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 42),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isPunchedIn = !_isPunchedIn;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 42),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: Text(_isPunchedIn ? 'Demo punch out' : 'Demo punch in'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'GPS is requested only when you choose GPS punch. Demo mode uses illustrative coordinates.',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stat Strip: Recorded hours, Late marks, Half days
            Row(
              children: [
                _buildStatBox('168 hrs', 'Recorded hours'),
                const SizedBox(width: 8),
                _buildStatBox('1', 'Late marks', highlightColor: AppColors.amber),
                const SizedBox(width: 8),
                _buildStatBox('1', 'Half days'),
              ],
            ),
            const SizedBox(height: 20),

            // Card 2: Punch history
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Punch history', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _punches.length,
                    separatorBuilder: (_, __) => const Divider(height: 24, color: AppColors.border),
                    itemBuilder: (context, idx) {
                      final p = _punches[idx];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(p['date'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.navy)),
                              Row(
                                children: [
                                  StatusPill(label: p['status']),
                                  if (p['isLate'] == true) ...[
                                    const SizedBox(width: 4),
                                    const StatusPill(label: 'Late'),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildTimeCol('Punch in', p['in']),
                              const SizedBox(width: 24),
                              _buildTimeCol('Punch out', p['out']),
                              const SizedBox(width: 24),
                              _buildTimeCol('Work hours', p['hours']),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('In: ${p['inLocation']}', style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card 3: Attendance regularization
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Attendance regularization', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
                      OutlinedButton.icon(
                        onPressed: _showRegularizationDialog,
                        icon: const Icon(Icons.edit_calendar, size: 14),
                        label: const Text('Request correction'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Missed a punch? Request corrected times for manager review.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String val, String label, {Color? highlightColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              val,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: highlightColor ?? AppColors.navy),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCol(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
      ],
    );
  }
}
