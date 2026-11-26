import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/app_header.dart';
import '../../core/constants/app_colors.dart';
import '../../models/task_model.dart';
import '../../providers/aeconnect_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _notesController;

  String? _selectedLeadId;
  String? _selectedAccountName;
  String _taskType = 'Call';
  String _assignedTo = 'John Doe';
  late DateTime _dueDate;
  late TimeOfDay _time;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleController = TextEditingController(text: t?.title ?? '');
    _notesController = TextEditingController(text: t?.notes ?? '');

    _selectedLeadId = t?.leadId;
    _selectedAccountName = t?.accountName;
    _taskType = t?.taskType ?? 'Call';
    _assignedTo = t?.assignedTo ?? 'John Doe';
    _dueDate = t?.dueDate ?? DateTime.now();

    if (t?.time != null && t!.time.contains(':')) {
      final parts = t.time.split(':');
      final hour = int.tryParse(parts[0]) ?? 10;
      final minute = int.tryParse(parts[1].split(' ')[0]) ?? 0;
      _time = TimeOfDay(hour: hour, minute: minute);
    } else {
      _time = const TimeOfDay(hour: 10, minute: 0);
    }

    _priority = t?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF935817),
              onPrimary: Colors.white,
              onSurface: AppColors.navy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF935817),
              onPrimary: Colors.white,
              onSurface: AppColors.navy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AEConnectProvider>();
    final account = _selectedAccountName ??
        (provider.leads.isNotEmpty ? provider.leads.first.companyName : 'Acme Technologies');

    final timeString =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

    if (widget.task == null) {
      final newTask = TaskModel(
        id: 't${DateTime.now().millisecondsSinceEpoch % 10000}',
        title: _titleController.text.trim(),
        accountName: account,
        leadId: _selectedLeadId ?? (provider.leads.isNotEmpty ? provider.leads.first.id : null),
        dueDate: _dueDate,
        time: timeString,
        taskType: _taskType,
        assignedTo: _assignedTo,
        priority: _priority,
        isCompleted: false,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      provider.addTask(newTask);
    } else {
      final updated = widget.task!.copyWith(
        title: _titleController.text.trim(),
        accountName: account,
        leadId: _selectedLeadId,
        dueDate: _dueDate,
        time: timeString,
        taskType: _taskType,
        assignedTo: _assignedTo,
        priority: _priority,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      provider.updateTask(updated);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.task == null ? 'Task created successfully' : 'Task updated successfully'),
        backgroundColor: const Color(0xFF087E6D),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AEConnectProvider>();
    final leads = provider.leads;
    final isEditing = widget.task != null;

    final formattedDate = DateFormat('MM/dd/yyyy').format(_dueDate);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
    final formattedTime = DateFormat('hh:mm a').format(dt);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back & Title Row
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isEditing ? 'Edit follow-up' : 'New task',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0),
                    child: Text(
                      'Set the customer, assignee and due date.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Main Form Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task title *
                        _buildLabel('Task title *'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Enter task title',
                            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF935817), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Task title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Related lead / customer *
                        _buildLabel('Related lead / customer *'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedAccountName != null &&
                                  leads.any((l) => l.companyName == _selectedAccountName)
                              ? _selectedAccountName
                              : (leads.isNotEmpty ? leads.first.companyName : null),
                          hint: const Text('Select a customer or lead',
                              style: TextStyle(fontSize: 13, color: AppColors.textLight)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF935817), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          items: leads.map((lead) {
                            return DropdownMenuItem<String>(
                              value: lead.companyName,
                              child: Text(
                                '${lead.companyName} (${lead.city})',
                                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedAccountName = val;
                              final match = leads.firstWhere(
                                (l) => l.companyName == val,
                                orElse: () => leads.first,
                              );
                              _selectedLeadId = match.id;
                            });
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please select a related customer or lead';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Two column row: Task type & Assigned to
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Task type'),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    value: _taskType,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: AppColors.border),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: AppColors.border),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            const BorderSide(color: Color(0xFF935817), width: 1.5),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    ),
                                    items: ['Call', 'Visit', 'Meeting', 'Quotation', 'Follow-up', 'Other']
                                        .map((t) => DropdownMenuItem(
                                              value: t,
                                              child: Text(t, style: const TextStyle(fontSize: 13)),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _taskType = val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Assigned to'),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    value: _assignedTo,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: AppColors.border),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(color: AppColors.border),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            const BorderSide(color: Color(0xFF935817), width: 1.5),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    ),
                                    items: ['John Doe', 'Priya Mehta', 'Rahul Sharma', 'Ankit Shah']
                                        .map((name) => DropdownMenuItem(
                                              value: name,
                                              child: Text(name, style: const TextStyle(fontSize: 13)),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _assignedTo = val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Two column row: Due date * & Time
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Due date *'),
                                  const SizedBox(height: 6),
                                  InkWell(
                                    onTap: _selectDate,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.border),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                fontSize: 13, color: AppColors.textPrimary),
                                          ),
                                          const Icon(Icons.calendar_today_outlined,
                                              size: 16, color: AppColors.textSecondary),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Time'),
                                  const SizedBox(height: 6),
                                  InkWell(
                                    onTap: _selectTime,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.border),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formattedTime,
                                            style: const TextStyle(
                                                fontSize: 13, color: AppColors.textPrimary),
                                          ),
                                          const Icon(Icons.access_time_outlined,
                                              size: 16, color: AppColors.textSecondary),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Priority
                        _buildLabel('Priority'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<TaskPriority>(
                          value: _priority,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF935817), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          items: TaskPriority.values.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p.label, style: const TextStyle(fontSize: 13)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _priority = val);
                          },
                        ),
                        const SizedBox(height: 18),

                        // Description
                        _buildLabel('Description'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 4,
                          minLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter task notes or agenda...',
                            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF935817), width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Autosave note
                  const Center(
                    child: Text(
                      'Draft changes stay in this browser',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Actions: Cancel & Save
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF935817),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text(
                          isEditing ? 'Save changes' : 'Save task',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}
