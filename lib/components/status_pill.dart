import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusPill extends StatelessWidget {
  final String label;

  const StatusPill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (label.toLowerCase()) {
      case 'approved':
      case 'delivered':
      case 'closed won':
      case 'completed':
        bg = AppColors.statusSuccessBg;
        fg = AppColors.statusSuccessFg;
        break;
      case 'negotiation':
      case 'awaiting stock':
      case 'due today':
      case 'pending':
        bg = AppColors.statusWarningBg;
        fg = AppColors.statusWarningFg;
        break;
      case 'proposal':
      case 'under review':
      case 'qualified':
      case 'active':
        bg = AppColors.statusInfoBg;
        fg = AppColors.statusInfoFg;
        break;
      case 'overdue':
      case 'closed lost':
      case 'rejected':
        bg = AppColors.kpiDangerBg;
        fg = AppColors.kpiDangerFg;
        break;
      default:
        bg = AppColors.statusDraftBg;
        fg = AppColors.statusDraftFg;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
