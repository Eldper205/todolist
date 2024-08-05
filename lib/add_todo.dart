import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'provider/todo_provider.dart';
import 'model/todo_model.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {

  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo', style: TextStyle(color: Colors.white)),
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
                final newTodo = Todos(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  todo: _titleController.text,
                  completed: false,
                  userId: 1, // Assuming a static userId for simplicity
                  dueDate: _selectedDate,
                  dueTime: _selectedTime,
                );
                todoProvider.addTodoToFirebase(newTodo);
                Navigator.pop(context);
              } : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
      initialTime: TimeOfDay.now(),
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
