import 'package:flutter/material.dart';
import 'package:flutter_project/add_todo.dart';
import 'package:flutter_project/edit_todo.dart';
import 'package:flutter_project/firebase_options.dart';
import 'package:provider/provider.dart';
import 'model/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'provider/todo_provider.dart';

// Main.dart - main UI Application of the App

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TODO List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the TODOs from both Firebase and the API when the screen is first loaded
    Provider.of<TodoProvider>(context, listen: false).fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.white,
            onPressed: () {
              _showDeleteConfirmationDialog(context, Provider.of<TodoProvider>(context, listen: false));
            },
          )
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (todoProvider.todos.isEmpty) {
            return const Center(child: Text('No TODOs available.'));
          } else {
            return ListView.builder(
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                return Padding(
                  padding: EdgeInsets.only(top: index == 0 ? 25.0 : 0.0), // Add space before the first item
                  child: ListTile(
                    title: Text(todo.todo ?? ''),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (todo.dueDate != null && todo.dueTime != null)
                          Text(
                            '${DateFormat('EEE, d MMM yyyy,').format(todo.dueDate!)} ${todo.dueTime!.format(context)}',
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Shrink the row to fit its children
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTodoScreen(todo: todo),
                              ),
                            );
                          },
                        ),
                        Checkbox(
                          value: todo.completed,
                          onChanged: (value) {
                            todoProvider.toggleTodoCompletion(todo.id!);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTodoScreen(todo: todo),
                        ),
                      );
                    },
                    onLongPress: () {
                      todoProvider.deleteTodoInFirebase(todo.id!);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, TodoProvider todoProvider){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Row(
            children: [
              Image.asset(
                'assets/icons/confirmation-icon.png',
                width: 45,
                height: 45,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Are you sure you want to delete checked TODOs?'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                todoProvider.deleteCheckedTodos();
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
            ),
          ],
        );
      },
    );
  }
}


