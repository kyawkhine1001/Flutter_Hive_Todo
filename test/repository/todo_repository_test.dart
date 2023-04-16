import 'package:flutter_hive_todo_bloc_clean_architecture/domain/model/todo_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import '../di/dependency_injection.dart';

void main() {
  var mockTodoDomain1 = TodoDomain(1, "test1", "description1", false);
  var mockTodoDomain2 = TodoDomain(2, "test2", "description2", false);

  // Setup
  final todoRepository = provideTodoRepository();
  const updatedTitle = "Updated Title";
  const updatedDescription = "Updated Description";

  group('Todo Repository Test', () {
    test('should work curd process properly', () async {
      // Read
      var result = todoRepository.getTodoList();
      expect(result.length, 0);

      // Create
      todoRepository.addTodo(mockTodoDomain1);
      todoRepository.addTodo(mockTodoDomain2);
      expect(todoRepository.getTodoList().length, 2);

      // Delete
      todoRepository.deleteTodo(mockTodoDomain2.id);
      expect(todoRepository.getTodoList().length, 1);

      //Undo
      todoRepository.addTodo(mockTodoDomain2);
      result = todoRepository.getTodoList();
      expect(result.length, 2);
      mockTodoDomain2 = TodoDomain(3, mockTodoDomain2.title, mockTodoDomain2.description, mockTodoDomain2.isCompleted);//id is changed because of auto increment
      expect(result.last.id, mockTodoDomain2.id);
      expect(result.last.title, mockTodoDomain2.title);
      expect(result.last.description, mockTodoDomain2.description);
      expect(result.last.isCompleted, mockTodoDomain2.isCompleted);

      //Update
      todoRepository.updateTodo(TodoDomain(3, updatedTitle,
          updatedDescription, mockTodoDomain2.isCompleted));
      result = todoRepository.getTodoList();
      expect(result.length, 2);
      expect(result.last.id, 3);
      expect(result.last.title, updatedTitle);
      expect(result.last.description, updatedDescription);
      expect(result.last.isCompleted, mockTodoDomain2.isCompleted);

      //Toggle - true
      todoRepository.toggleCompleteTodo(mockTodoDomain2);
      result = todoRepository.getTodoList();
      expect(result.length, 2);
      expect(result.last.id, mockTodoDomain2.id);
      expect(result.last.title, mockTodoDomain2.title);
      expect(result.last.description, mockTodoDomain2.description);
      expect(result.last.isCompleted, true);

      //Toggle - false
      todoRepository.toggleCompleteTodo(result.last);
      result = todoRepository.getTodoList();
      expect(result.length, 2);
      expect(result.last.id, mockTodoDomain2.id);
      expect(result.last.title, mockTodoDomain2.title);
      expect(result.last.description, mockTodoDomain2.description);
      expect(result.last.isCompleted, false);
    });
  });
}
