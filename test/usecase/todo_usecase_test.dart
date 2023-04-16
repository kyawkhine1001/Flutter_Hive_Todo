import 'package:flutter_hive_todo_bloc_clean_architecture/domain/model/todo_domain.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/add_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/delete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/get_all_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/toggle_complete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/undo_deleted_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/update_todo_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import '../di/dependency_injection.dart';

void main() {
  var mockTodoDomain1 = TodoDomain(1, "test1", "description1", false);
  var mockTodoDomain2 = TodoDomain(2, "test2", "description2", false);

  // Setup
  final todoRepository = provideTodoRepository();
  final GetAllTodoUseCase getAllTodoUseCase = GetAllTodoUseCase(todoRepository);
  final AddTodoUseCase addTodoUseCase = AddTodoUseCase(todoRepository);
  final DeleteTodoUseCase deleteTodoUseCase = DeleteTodoUseCase(todoRepository);
  final UndoDeletedTodoUseCase undoDeletedTodoUseCase =
      UndoDeletedTodoUseCase(todoRepository);
  final UpdateTodoUseCase updateTodoUseCase = UpdateTodoUseCase(todoRepository);
  final ToggleCompleteTodoUseCase toggleCompleteTodoUseCase =
      ToggleCompleteTodoUseCase(todoRepository);
  const updatedTitle = "Updated Title";
  const updatedDescription = "Updated Description";

  group('Use Case Test', () {
    test('check item list count and values after crud actions', () async {
      // Read
      var result = getAllTodoUseCase.execute();
      expect(result.length, 0);

      // Create
      addTodoUseCase.execute(mockTodoDomain1);
      addTodoUseCase.execute(mockTodoDomain2);
      expect(getAllTodoUseCase.execute().length, 2);

      // Delete
      deleteTodoUseCase.execute(mockTodoDomain2.id);
      expect(getAllTodoUseCase.execute().length, 1);

      //Undo
      undoDeletedTodoUseCase.execute(mockTodoDomain2);
      result = getAllTodoUseCase.execute();
      expect(result.length, 2);
      mockTodoDomain2 = TodoDomain(3, mockTodoDomain2.title, mockTodoDomain2.description, mockTodoDomain2.isCompleted);//id is changed because of auto increment
      expect(result.last.id, mockTodoDomain2.id);
      expect(result.last.title, mockTodoDomain2.title);
      expect(result.last.description, mockTodoDomain2.description);
      expect(result.last.isCompleted, mockTodoDomain2.isCompleted);

      //Update
      updateTodoUseCase.execute(TodoDomain(mockTodoDomain2.id, updatedTitle,
          updatedDescription, mockTodoDomain2.isCompleted));
      result = getAllTodoUseCase.execute();
      expect(result.length, 2);
      expect(result.last.id, mockTodoDomain2.id);
      expect(result.last.title, updatedTitle);
      expect(result.last.description, updatedDescription);
      expect(result.last.isCompleted, mockTodoDomain2.isCompleted);

      //Toggle - true
      toggleCompleteTodoUseCase.execute(mockTodoDomain2);
      result = getAllTodoUseCase.execute();
      expect(result.length, 2);
      expect(result.last.id, mockTodoDomain2.id);
      expect(result.last.title, mockTodoDomain2.title);
      expect(result.last.description, mockTodoDomain2.description);
      expect(result.last.isCompleted, true);

      //Toggle - false
      toggleCompleteTodoUseCase.execute(result.last);
      result = getAllTodoUseCase.execute();
      expect(result.length, 2);
      expect(result.last.id, mockTodoDomain2.id);
      expect(result.last.title, mockTodoDomain2.title);
      expect(result.last.description, mockTodoDomain2.description);
      expect(result.last.isCompleted, false);
    });
  });
}
