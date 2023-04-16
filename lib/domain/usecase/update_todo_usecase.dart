import 'package:flutter_hive_todo_bloc_clean_architecture/domain/model/todo_domain.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/repository/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;
  UpdateTodoUseCase(this.repository);

  void execute(TodoDomain todoDomain) {
    return repository.updateTodo(todoDomain);
  }
}
