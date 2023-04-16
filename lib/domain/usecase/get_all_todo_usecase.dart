import 'package:flutter_hive_todo_bloc_clean_architecture/domain/model/todo_domain.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/repository/todo_repository.dart';

class GetAllTodoUseCase {
  final TodoRepository repository;
  GetAllTodoUseCase(this.repository);

  List<TodoDomain> execute() {
    return repository.getTodoList();
  }
}
