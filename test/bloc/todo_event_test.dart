import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_event.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/vo/todo_vo.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('TodoEvent', () {

    group('TodoStartedEvent', () {
      test('supports value equality', () {
        expect(
          TodoStartedEvent(),
          equals(TodoStartedEvent()),
        );
      });

      test('props are correct', () {
        expect(
          TodoStartedEvent().props,
          equals(<Object?>[]),
        );
      });
    });

    group('TodoItemAddedEvent', () {
      var todoVO = TodoVO(id:1, title: "test", description: "description", isCompleted: false);
      test('supports value equality', () {
        expect(
          TodoItemAddedEvent(todoVO),
          equals(TodoItemAddedEvent(todoVO)),
        );
      });

      test('props are correct', () {
        expect(
          TodoItemAddedEvent(todoVO).props,
          equals(<Object?>[todoVO]),
        );
      });
    });

    group('TodoItemUpdatedEvent', () {
      var todoVO = TodoVO(id:1, title: "test", description: "description", isCompleted: false);
      test('supports value equality', () {
        expect(
          TodoItemUpdatedEvent(todoVO),
          equals(TodoItemUpdatedEvent(todoVO)),
        );
      });

      test('props are correct', () {
        expect(
          TodoItemUpdatedEvent(todoVO).props,
          equals(<Object?>[todoVO]),
        );
      });
    });

    group('TodoItemToggleCompletedEvent', () {
      var todoVO = TodoVO(id:1, title: "test", description: "description", isCompleted: false);
      test('supports value equality', () {
        expect(
          TodoItemToggleCompletedEvent(todoVO),
          equals(TodoItemToggleCompletedEvent(todoVO)),
        );
      });

      test('props are correct', () {
        expect(
          TodoItemToggleCompletedEvent(todoVO).props,
          equals(<Object?>[todoVO]),
        );
      });
    });

    group('TodoItemDeletedEvent', () {
      test('supports value equality', () {
        expect(
          TodoItemDeletedEvent(1),
          equals(TodoItemDeletedEvent(1)),
        );
      });

      test('props are correct', () {
        expect(
          TodoItemDeletedEvent(1).props,
          equals(<Object?>[]),
        );
      });
    });

    group('TodoItemUndoDeletedEvent', () {
      var todoVO = TodoVO(id:1, title: "test", description: "description", isCompleted: false);
      test('supports value equality', () {
        expect(
          TodoItemUndoDeletedEvent(todoVO),
          equals(TodoItemUndoDeletedEvent(todoVO)),
        );
      });

      test('props are correct', () {
        expect(
          TodoItemUndoDeletedEvent(todoVO).props,
          equals(<Object?>[]),
        );
      });
    });


  });
}