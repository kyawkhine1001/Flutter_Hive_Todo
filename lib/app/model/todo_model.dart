import 'package:equatable/equatable.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/vo/todo_vo.dart';

class TodoModel extends Equatable {

  const TodoModel({required this.todoList});

  final List<TodoVO> todoList;

  @override
  List<Object> get props => [todoList];
}