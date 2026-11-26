import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/aeconnect_provider.dart';

class TaskDialog extends StatefulWidget {
  const TaskDialog({super.key});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _accountController = TextEditingController();
  final DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.call;

  @override
  void dispose() {
    _titleController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isNotEmpty) {
      final task = TaskModel(
        id: 'TSK-${DateTime.now().millisecondsSinceEpoch % 1000}',
        title: _titleController.text.trim(),
        accountName: _accountController.text.trim().isEmpty ? 'General Account' : _accountController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        category: _category,
      );

      context.read<AEConnectProvider>().addTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task / Follow-up'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Description *', hintText: 'e.g., Call client regarding quotation'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _accountController,
                decoration: const InputDecoration(labelText: 'Related Account / Client', hintText: 'e.g., Acme Technologies'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskPriority>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values.map((p) {
                  return DropdownMenuItem(value: p, child: Text('${p.label} Priority'));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _priority = v);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: TaskCategory.values.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c.label));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Create Task')),
      ],
    );
  }
}
