import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import '../../providers/aeconnect_provider.dart';
import 'mom_form_screen.dart';
import 'mom_detail_screen.dart';

class MomsScreen extends StatelessWidget {
  const MomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final moms = provider.moms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetings / MOM'),
        actions: [
          IconButton(
            tooltip: 'New MOM',
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MomFormScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: moms.length,
        itemBuilder: (context, index) {
          final mom = moms[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MomDetailScreen(momId: mom.id)),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.kpiFollowupsBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            mom.id,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.kpiFollowupsFg),
                          ),
                        ),
                        Text(AppFormatters.date(mom.date), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(mom.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Account: ${mom.accountName}', style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Text(
                      'Agenda: ${mom.agenda}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 20),
                    const Text('Action Items:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 6),
                    ...mom.actionItems.map((ai) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              ai.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                              size: 16,
                              color: ai.isDone ? AppColors.statusSuccessFg : AppColors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${ai.task} (${ai.assignee})',
                                style: TextStyle(
                                  fontSize: 12,
                                  decoration: ai.isDone ? TextDecoration.lineThrough : null,
                                  color: ai.isDone ? AppColors.textMuted : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
