import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/visit_model.dart';
import '../../providers/aeconnect_provider.dart';
import '../../components/status_pill.dart';
import 'visit_form_screen.dart';
import 'active_visit_screen.dart';
import 'visit_summary_screen.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allVisits = provider.visits;
    final activeVisit = provider.activeVisit;

    final visits = allVisits.where((v) {
      if (_selectedFilter == 'Active') return v.status == VisitStatus.active;
      if (_selectedFilter == 'Awaiting Summary') return v.status == VisitStatus.awaitingSummary;
      if (_selectedFilter == 'Completed') return v.status == VisitStatus.completed;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Head: Title + Log new visit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Field visits',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VisitFormScreen()),
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Log new visit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          minimumSize: const Size(0, 40),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // If Active visit in progress: Notice Banner
                  if (activeVisit != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.tealLight,
                        border: Border.all(color: const Color(0xFFCCEBDD)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.teal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visit in progress · ${activeVisit.companyName}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${activeVisit.purpose} · Started at ${_formatTime(activeVisit.checkInTime)}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.teal),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ActiveVisitScreen(visit: activeVisit),
                                ),
                              );
                            },
                            icon: const Icon(Icons.timer_outlined, size: 14),
                            label: const Text('Resume'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.teal,
                              side: const BorderSide(color: AppColors.teal),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: const Size(0, 34),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Active', 'Awaiting Summary', 'Completed'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () => setState(() => _selectedFilter = filter),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryLight : Colors.white,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Visit Items List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: visits.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'No visits found.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final visit = visits[index];
                        final isActive = visit.status == VisitStatus.active;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              if (isActive) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ActiveVisitScreen(visit: visit),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VisitSummaryScreen(visit: visit),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Icon Badge
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isActive ? AppColors.tealLight : AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: 18,
                                      color: isActive ? AppColors.teal : AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                visit.companyName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.navy,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            StatusPill(label: visit.status.label),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${visit.purpose} · ${DateFormat('d MMM yyyy').format(visit.checkInTime)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${visit.id} · ${isActive ? 'In progress' : '${visit.durationSeconds ~/ 60}m'} · ${visit.isGpsVerified ? 'GPS' : 'Demo'} location',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 18,
                                    color: AppColors.textLight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: visits.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'pm' : 'am';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
