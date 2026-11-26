import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/task_model.dart';
import '../../providers/aeconnect_provider.dart';
import 'task_form_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'Completed';
  String _searchQuery = '';
  String _sortOption = 'Due date';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final allTasks = provider.tasks;

    final today = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(today);

    // Calculate Counts for 3-stat overview
    final dueTodayCount = allTasks.where((t) {
      if (t.isCompleted) return false;
      return DateFormat('yyyy-MM-dd').format(t.dueDate) == todayStr;
    }).length;

    final overdueCount = allTasks.where((t) {
      if (t.isCompleted) return false;
      return DateFormat('yyyy-MM-dd').format(t.dueDate).compareTo(todayStr) < 0;
    }).length;

    final completedCount = allTasks.where((t) => t.isCompleted).length;

    // Filter Tasks
    final filteredTasks = allTasks.where((t) {
      // 1. Search Query
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = t.title.toLowerCase().contains(q);
        final matchesAccount = t.accountName.toLowerCase().contains(q);
        final matchesNotes = t.notes?.toLowerCase().contains(q) ?? false;
        if (!matchesTitle && !matchesAccount && !matchesNotes) return false;
      }

      // 2. Tab Filter
      final dueStr = DateFormat('yyyy-MM-dd').format(t.dueDate);
      if (_selectedFilter == 'Today') {
        return !t.isCompleted && dueStr == todayStr;
      } else if (_selectedFilter == 'Upcoming') {
        return !t.isCompleted && dueStr.compareTo(todayStr) > 0;
      } else if (_selectedFilter == 'Overdue') {
        return !t.isCompleted && dueStr.compareTo(todayStr) < 0;
      } else if (_selectedFilter == 'Completed') {
        return t.isCompleted;
      }
      return true; // 'All'
    }).toList();

    // Sort Tasks
    if (_sortOption == 'Due date') {
      filteredTasks.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return a.dueDate.compareTo(b.dueDate);
      });
    } else if (_sortOption == 'Newest first') {
      filteredTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
    } else if (_sortOption == 'Name / reference') {
      filteredTasks.sort((a, b) => a.title.compareTo(b.title));
    }

    final currentDateFormatted = DateFormat('EEEE, d MMMM').format(today);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Title & Add Task Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tasks',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.6,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentDateFormatted,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TaskFormScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF935817),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 38),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 3-Stat Overview Box (.task-overview)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Due today
                      Expanded(
                        child: _buildStatCell(
                          count: dueTodayCount,
                          label: 'Due today',
                          color: AppColors.navy,
                          isSelected: _selectedFilter == 'Today',
                          activeBg: const Color(0xFFFFF8E9),
                          activeLine: const Color(0xFFB17A27),
                          onTap: () => setState(() => _selectedFilter = 'Today'),
                        ),
                      ),
                      Container(width: 1, height: 75, color: AppColors.border),

                      // Overdue
                      Expanded(
                        child: _buildStatCell(
                          count: overdueCount,
                          label: 'Overdue',
                          color: const Color(0xFF9C502E),
                          isSelected: _selectedFilter == 'Overdue',
                          activeBg: const Color(0xFFFFF1EF),
                          activeLine: const Color(0xFF9C502E),
                          onTap: () => setState(() => _selectedFilter = 'Overdue'),
                        ),
                      ),
                      Container(width: 1, height: 75, color: AppColors.border),

                      // Completed
                      Expanded(
                        child: _buildStatCell(
                          count: completedCount,
                          label: 'Completed',
                          color: const Color(0xFF286449),
                          isSelected: _selectedFilter == 'Completed',
                          activeBg: const Color(0xFFEDF8F1),
                          activeLine: const Color(0xFF288B65),
                          onTap: () => setState(() => _selectedFilter = 'Completed'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Search & Filter Toolbar (.record-tools .toolbar)
                Row(
                  children: [
                    // Search tasks input
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 20, color: Color(0xFF8A98AC)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                decoration: const InputDecoration(
                                  hintText: 'Search tasks',
                                  hintStyle: TextStyle(fontSize: 13.5, color: Color(0xFF8A98AC)),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () => setState(() => _searchQuery = ''),
                                child: const Icon(Icons.clear, size: 16, color: AppColors.textLight),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Filter / Options button
                    PopupMenuButton<String>(
                      initialValue: _sortOption,
                      tooltip: 'Sort and filter',
                      onSelected: (val) => setState(() => _sortOption = val),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Due date', child: Text('Sort by: Due date')),
                        const PopupMenuItem(value: 'Newest first', child: Text('Sort by: Newest first')),
                        const PopupMenuItem(value: 'Name / reference', child: Text('Sort by: Name / reference')),
                      ],
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8EE),
                          border: Border.all(color: const Color(0xFFE8DEC8)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF935817)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Segmented Tabs: All, Today, Upcoming, Overdue, Completed
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Today', 'Upcoming', 'Overdue', 'Completed'].map((tab) {
                        final isSelected = _selectedFilter == tab;
                        return InkWell(
                          onTap: () => setState(() => _selectedFilter = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected ? const Color(0xFF935817) : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? const Color(0xFF935817) : const Color(0xFF7A8798),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Group Header (e.g. Completed  2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedFilter == 'All' ? 'Tasks' : _selectedFilter,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E4740),
                        ),
                      ),
                      Text(
                        '${filteredTasks.length}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E4740),
                        ),
                      ),
                    ],
                  ),
                ),

                // Task Records Card (.record-results)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: filteredTasks.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.task_alt, size: 36, color: Color(0xFF8A98AC)),
                                SizedBox(height: 10),
                                Text(
                                  'No matching tasks',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Try another search or filter, or create a new task.',
                                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredTasks.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1, thickness: 1, color: Color(0xFFEDF0F5)),
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return _buildTaskRow(context, provider, task);
                          },
                        ),
                ),
                const SizedBox(height: 12),

                // Footer (.list-footer): 2 records · Showing all
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredTasks.length} records',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF8A98AC)),
                      ),
                      const Text(
                        'Showing all',
                        style: TextStyle(fontSize: 11, color: Color(0xFF8A98AC)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCell({
    required int count,
    required String label,
    required Color color,
    required bool isSelected,
    required Color activeBg,
    required Color activeLine,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.white,
          border: isSelected
              ? Border(bottom: BorderSide(color: activeLine, width: 3))
              : null,
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskRow(BuildContext context, AEConnectProvider provider, TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox (Green/Teal checkmark when completed)
          GestureDetector(
            onTap: () => provider.toggleTask(task.id),
            child: Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2, right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted ? const Color(0xFF087E6D) : Colors.white,
                border: Border.all(
                  color: task.isCompleted ? const Color(0xFF087E6D) : const Color(0xFFA4B3C4),
                  width: 1.5,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),

          // Main details (tapping opens edit form)
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (with line-through if completed)
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? const Color(0xFF7A8798) : AppColors.navy,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Company / Account name
                  Text(
                    task.accountName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF526680),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Meta footer: Icon, Time, Priority
                  Row(
                    children: [
                      Icon(
                        task.taskType == 'Call'
                            ? Icons.phone_outlined
                            : task.taskType == 'Visit'
                                ? Icons.location_on_outlined
                                : Icons.calendar_today_outlined,
                        size: 13,
                        color: const Color(0xFF8A98AC),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.time.isNotEmpty ? task.time : '10:00',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF62748C),
                        ),
                      ),
                      const Text(
                        ' · ',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF62748C),
                        ),
                      ),
                      Text(
                        task.priority.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: task.priority == TaskPriority.high
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: task.priority == TaskPriority.high
                              ? const Color(0xFFB36A20)
                              : const Color(0xFF62748C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // User Avatar on right
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 4, left: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEAF2FF),
              border: Border.all(color: const Color(0xFFD0E1FD)),
            ),
            child: const Center(
              child: Text(
                'JD',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
