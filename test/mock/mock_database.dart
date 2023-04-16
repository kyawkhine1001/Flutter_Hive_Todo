import 'package:flutter_hive_todo_bloc_clean_architecture/cache/database/entity/todo.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/data/datasource/crud_datasource.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/data/entity/todo_data.dart';

class MockDatabase extends CRUDDataSource{
  static final Map<int,TodoEntity> _todoList = {};
  int latestId = 0;
  @override
  void deleteAllTodoList() {
    _todoList.clear();
  }

  @override
  void deleteTodo(int id) {
    _todoList.remove(id);
  }

  @override
  List<TodoData> getAllTodoList() {
    var todoList =  _todoList.values.map((e) => TodoData(e.id, e.title, e.description, e.isCompleted))
        .toList();
    return todoList;
  }

  @override
  void saveTodo(TodoData todo) {
    int newLatestId = latestId + 1;
    var todoEntity = TodoEntity(
        id: newLatestId,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted);
    _todoList[newLatestId] = todoEntity;
    latestId = newLatestId;
  }

  @override
  void updateTodo(int id, TodoData todo) {
    _todoList[todo.id] = TodoEntity(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted);
  }

}