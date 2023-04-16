import 'package:flutter/material.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/vo/todo_vo.dart';
import 'component/update_todo_form.dart';

class UpdateTodoScreen extends StatefulWidget {
  final TodoVO todo;

  const UpdateTodoScreen({
    super.key,
    required this.todo,
  });

  @override
  _UpdateTodoScreenState createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UpdateTodoForm(
          todo: widget.todo,
        ),
      ),
    );
  }
}
