import 'package:flutter/material.dart';
import '../../components/app_header.dart';
import '../../core/constants/app_colors.dart';
import '../../core/rbac/role_guard.dart';
import '../../core/utils/app_formatters.dart';
import '../../models/permission.dart';
import '../leads/leads_screen.dart';
import 'opportunity_detail_screen.dart';

class DealItem {
  final String id;
  final String title;
  final String client;
  final double value;
  final int probability;
  final String closeDate;
  final String owner;

  const DealItem({
    required this.id,
    required this.title,
    required this.client,
    required this.value,
    required this.probability,
    required this.closeDate,
    required this.owner,
  });
}

class PipelineStage {
  final String name;
  final List<DealItem> deals;

  const PipelineStage({
    required this.name,
    required this.deals,
  });

  double get totalAmount => deals.fold(0.0, (sum, d) => sum + d.value);
}

class PipelineScreen extends StatelessWidget {
  const PipelineScreen({super.key});

  static const List<PipelineStage> pipelineStages = [
    PipelineStage(
      name: 'Qualification',
      deals: [],
    ),
    PipelineStage(
      name: 'Discovery',
      deals: [],
    ),
    PipelineStage(
      name: 'Proposal',
      deals: [
        DealItem(
          id: 'op1',
          title: 'Campus fiber backbone',
          client: 'Acme Technologies',
          value: 29500.0,
          probability: 60,
          closeDate: '14 Dec 2026',
          owner: 'emp104',
        ),
      ],
    ),
    PipelineStage(
      name: 'Negotiation',
      deals: [
        DealItem(
          id: 'op3',
          title: 'City fiber expansion',
          client: 'Bharat Infotech Solutions',
          value: 650000.0,
          probability: 80,
          closeDate: '18 Dec 2026',
          owner: 'emp104',
        ),
      ],
    ),
    PipelineStage(
      name: 'Closed Won',
      deals: [
        DealItem(
          id: 'op2',
          title: 'Office network upgrade',
          client: 'Bright Infra Solutions',
          value: 616432.0,
          probability: 100,
          closeDate: '1 Dec 2026',
          owner: 'emp104',
        ),
        DealItem(
          id: 'op4',
          title: 'Government campus',
          client: 'Westlink Networks',
          value: 420000.0,
          probability: 100,
          closeDate: '26 Nov 2026',
          owner: 'emp105',
        ),
        DealItem(
          id: 'op5',
          title: 'Data Center Interconnect',
          client: 'Global Net Corp',
          value: 616432.0,
          probability: 100,
          closeDate: '15 Nov 2026',
          owner: 'emp104',
        ),
        DealItem(
          id: 'op6',
          title: 'Express Highway CCTV Cable',
          client: 'Road Transport Auth',
          value: 1845000.0,
          probability: 100,
          closeDate: '10 Nov 2026',
          owner: 'emp104',
        ),
      ],
    ),
    PipelineStage(
      name: 'Closed Lost',
      deals: [
        DealItem(
          id: 'op7',
          title: 'Metro Fiber Link',
          client: 'Central Rail Infra',
          value: 250000.0,
          probability: 0,
          closeDate: 'Price Too High',
          owner: 'emp104',
        ),
        DealItem(
          id: 'op8',
          title: 'Substation Connectivity',
          client: 'State Power Grid',
          value: 200000.0,
          probability: 0,
          closeDate: 'Competitor Beat Spec',
          owner: 'emp104',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Open pipeline value is sum of non-closed stages (Proposal + Negotiation = 29,500 + 650,000 = 6,79,500)
    final openPipelineValue = pipelineStages
        .where((s) => !s.name.startsWith('Closed'))
        .fold(0.0, (sum, s) => sum + s.totalAmount);

    final totalOpportunities = pipelineStages.fold(0, (sum, s) => sum + s.deals.length);

    return RoleGuard(
      feature: AppFeature.pipeline,
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Page Header (Opportunity pipeline + Open leads button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Opportunity pipeline',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: AppColors.navy,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LeadsScreen()),
                    );
                  },
                  icon: const Icon(Icons.people_alt_outlined, size: 16, color: Color(0xFF036E97)),
                  label: const Text(
                    'Open leads',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF036E97)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0E7F5)),
                    backgroundColor: const Color(0xFFE8F5FC),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Open Pipeline Value Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Open pipeline value',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppFormatters.rupee(openPipelineValue),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$totalOpportunities opportunities',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Vertical Stage Cards (Qualification, Discovery, Proposal, Negotiation, Closed Won, Closed Lost)
            ...pipelineStages.map((stage) => _buildStageCard(context, stage)),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildStageCard(BuildContext context, PipelineStage stage) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stage.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              Text(
                '${stage.deals.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            AppFormatters.rupee(stage.totalAmount),
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 12),
          if (stage.deals.isEmpty)
            const Text(
              'No deals in this stage',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            )
          else
            ...stage.deals.map((deal) => _buildDealCard(context, deal)),
        ],
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, DealItem deal) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OpportunityDetailScreen(opportunityId: deal.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deal.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                deal.client,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppFormatters.rupee(deal.value),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${deal.probability}% · ${deal.closeDate}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                      image: DecorationImage(
                        image: AssetImage('assets/people/${deal.owner.toLowerCase()}.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
