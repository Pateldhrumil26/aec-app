import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_formatters.dart';
import 'opportunity_detail_screen.dart';

class PipelineScreen extends StatelessWidget {
  const PipelineScreen({super.key});

  static const List<Map<String, dynamic>> stages = [
    {
      'name': 'Qualification',
      'count': 3,
      'total': 450000.0,
      'deals': [
        {'title': 'Metro Fiber Link', 'client': 'Central Rail Infra', 'value': 250000.0, 'prob': '30%'},
        {'title': 'Substation Connectivity', 'client': 'State Power Grid', 'value': 200000.0, 'prob': '40%'},
      ]
    },
    {
      'name': 'Proposal',
      'count': 2,
      'total': 506050.0,
      'deals': [
        {'title': 'Campus Backbone Upgrade', 'client': 'Acme Technologies', 'value': 56050.0, 'prob': '70%'},
        {'title': 'Industrial Park 48F Cable', 'client': 'Titanium Logistics', 'value': 450000.0, 'prob': '60%'},
      ]
    },
    {
      'name': 'Negotiation',
      'count': 1,
      'total': 1200000.0,
      'deals': [
        {'title': 'Smart City Hardware Tender', 'client': 'Bharat Infotech', 'value': 1200000.0, 'prob': '85%'},
      ]
    },
    {
      'name': 'Closed Won',
      'count': 3,
      'total': 2461432.0,
      'deals': [
        {'title': 'Data Center Interconnect', 'client': 'Global Net Corp', 'value': 616432.0, 'prob': '100%'},
        {'title': 'Express Highway CCTV Cable', 'client': 'Road Transport Auth', 'value': 1845000.0, 'prob': '100%'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals Pipeline Kanban'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner summary
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL PIPELINE VALUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    SizedBox(height: 2),
                    Text('₹46,17,482', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Text('9 Opportunities', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ],
            ),
          ),

          // Kanban Horizontal Board
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];
                final deals = stage['deals'] as List<Map<String, dynamic>>;

                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stage Header
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              stage['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${stage['count']}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      // Deals List
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: deals.length,
                          itemBuilder: (ctx, dIdx) {
                            final deal = deals[dIdx];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const OpportunityDetailScreen(opportunityId: 'op1'),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deal['title'] as String,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        deal['client'] as String,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppFormatters.compactRupee(deal['value'] as double),
                                            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                                          ),
                                          Text(
                                            'Win: ${deal['prob']}',
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.statusSuccessFg),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
