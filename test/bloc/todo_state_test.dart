import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_event.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_state.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/model/todo_model.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/vo/todo_vo.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('TodoState', () {

    group('TodoLoadingState', () {
      test('supports value equality', () {
        expect(
          TodoLoadingState(),
          equals(TodoLoadingState()),
        );
      });
    });

    group('TodoLoadedState', () {
      var todoVO = TodoVO(id:1, title: "test", description: "description", isCompleted: false);
      test('supports value equality', () {
        expect(
          TodoLoadedState(TodoModel(todoList: [todoVO])),
          equals(TodoLoadedState(TodoModel(todoList: [todoVO]))),
        );
      });
    });

    group('TodoErrorState', () {
      test('supports value equality', () {
        expect(
          TodoErrorState(),
          equals(TodoErrorState()),
        );
      });
    });




  });
}