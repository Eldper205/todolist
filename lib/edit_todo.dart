import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'provider/todo_provider.dart';
import 'model/todo_model.dart';

class EditTodoScreen extends StatefulWidget {

  final Todos todo; // instantiate 'Todos' class object in todo_model.dart

  const EditTodoScreen({super.key, required this.todo});

    @override
    _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {

  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo.todo ?? '';
    _selectedDate = widget.todo.dueDate;
    _selectedTime = widget.todo.dueTime;
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: _selectedDate == null
                          ? 'Enter Task Here'
                          : DateFormat('EEE, d MMM yyyy').format(_selectedDate!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Due date', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: _selectedDate == null
                          ? 'Select Due Date'
                          : DateFormat('EEE, d MMM yyyy').format(_selectedDate!),
                      suffixIcon: _selectedDate != null
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                          });
                        },
                      )
                          : null,
                    ),
                    onTap: _pickDueDate,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDueDate,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: _selectedTime == null
                          ? 'Select Due Time'
                          : _selectedTime!.format(context),
                      suffixIcon: _selectedTime != null
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _selectedTime = null;
                          });
                        },
                      )
                          : null,
                    ),
                    onTap: _pickDueTime,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: _pickDueTime,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isFormValid() ? () {
                // Create an updated TODOs object
                final updatedTodo = Todos(
                  id: widget.todo.id,
                  todo: _titleController.text,
                  completed: widget.todo.completed,
                  userId: widget.todo.userId,
                  dueDate: _selectedDate,
                  dueTime: _selectedTime,
                );
                todoProvider.updateTodoInFirebase(updatedTodo);
                Navigator.pop(context);
              } : null,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _pickDueTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  bool _isFormValid() {
    return _titleController.text.isNotEmpty && _selectedDate != null && _selectedTime != null;
  }
}

