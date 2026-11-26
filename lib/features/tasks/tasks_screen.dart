import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/task_model.dart';
import '../../providers/aeconnect_provider.dart';
import 'task_dialog.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allTasks = provider.tasks;

    final tasks = allTasks.where((t) {
      if (_selectedFilter == 'Pending') return !t.isCompleted;
      if (_selectedFilter == 'Completed') return t.isCompleted;
      if (_selectedFilter == 'Due today') {
        return !t.isCompleted && t.dueDate.day == DateTime.now().day;
      }
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
                  // Title + New Task
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tasks & follow-ups',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: AppColors.navy,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const TaskDialog(),
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('New task'),
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

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Pending', 'Due today', 'Completed'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
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
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 11,
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

          // Tasks List (.list-row in prototype)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            sliver: tasks.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'No follow-ups found.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = tasks[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Checkbox
                                InkWell(
                                  onTap: () => provider.toggleTask(task.id),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      color: task.isCompleted ? AppColors.primary : Colors.white,
                                      border: Border.all(
                                        color: task.isCompleted ? AppColors.primary : AppColors.borderDark,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: task.isCompleted
                                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: task.isCompleted ? AppColors.textMuted : AppColors.navy,
                                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        task.accountName,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textLight),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat('d MMM yyyy').format(task.dueDate),
                                            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: task.priority == TaskPriority.high
                                                  ? AppColors.dangerLight
                                                  : AppColors.primaryLight,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: Text(
                                              task.priority.name.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color: task.priority == TaskPriority.high
                                                    ? AppColors.danger
                                                    : AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: tasks.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
