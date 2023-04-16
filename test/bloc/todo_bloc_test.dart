import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_bloc.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_event.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_state.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/model/todo_model.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/vo/todo_vo.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/model/todo_domain.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/add_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/delete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/get_all_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/toggle_complete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/undo_deleted_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/update_todo_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../mock/fake_todo_domain.dart';
import '../mock/mock_add_todo_usecase.dart';
import '../mock/mock_delete_todo_usecase.dart';
import '../mock/mock_get_all_todo_usecase.dart';
import '../mock/mock_toggle_complete_todo_usecase.dart';
import '../mock/mock_undo_deleted_todo_usecase.dart';
import '../mock/mock_update_todo_usecase.dart';


void main() {
  var mockTodoDomain1 = TodoDomain(1, "test1", "description1", false);
  var mockTodoDomain2 = TodoDomain(2, "test2", "description2", false);
  var mockTodoVO1 = TodoVO(
      id: mockTodoDomain1.id,
      title: mockTodoDomain1.title,
      description: mockTodoDomain1.description,
      isCompleted: mockTodoDomain1.isCompleted);
  var mockTodoVO2 = TodoVO(
      id: mockTodoDomain2.id,
      title: mockTodoDomain2.title,
      description: mockTodoDomain2.description,
      isCompleted: mockTodoDomain2.isCompleted);

  final mockTodoVOList = [
    mockTodoVO1,
    mockTodoVO2,
  ];
  final mockTodoDomainList = [
    mockTodoDomain1,
    mockTodoDomain2,
  ];
  var todoVOToAdd = TodoVO(
      id: 3, title: "test", description: "description", isCompleted: false);

  var todoDomainToAdd = TodoDomain(todoVOToAdd.id, todoVOToAdd.title,
      todoVOToAdd.description, todoVOToAdd.isCompleted);

  group('TodoBloc', () {
    late GetAllTodoUseCase getAllTodoUseCase;
    late AddTodoUseCase addTodoUseCase;
    late UpdateTodoUseCase updateTodoUseCase;
    late ToggleCompleteTodoUseCase toggleCompleteTodoUseCase;
    late DeleteTodoUseCase deleteTodoUseCase;
    late UndoDeletedTodoUseCase undoDeletedTodoUseCase;

    setUp(() {
      getAllTodoUseCase = MockGetAllTodoUseCase();
      addTodoUseCase = MockAddTodoUseCase();
      updateTodoUseCase = MockUpdateTodoUseCase();
      toggleCompleteTodoUseCase = MockToggleCompleteTodoUseCase();
      deleteTodoUseCase = MockDeleteTodoUseCase();
      undoDeletedTodoUseCase = MockUndoDeletedTodoUseCase();
    });

    TodoBloc buildTodoBloc() {
      return TodoBloc(
          getAllTodoUseCase: getAllTodoUseCase,
          addTodoUseCase: addTodoUseCase,
          updateTodoUseCase: updateTodoUseCase,
          toggleCompleteTodoUseCase: toggleCompleteTodoUseCase,
          deleteTodoUseCase: deleteTodoUseCase,
          undoDeletedTodoUseCase: undoDeletedTodoUseCase);
    }

    setUpAll(() {
      registerFallbackValue(FakeTodoDomain());
    });

    group('constructor', () {
      test('work properly', () {
        expect(buildTodoBloc, returnsNormally);
      });
      test('has correct initial state', () {
        expect(
          buildTodoBloc().state,
          equals(TodoLoadingState()),
        );
      });
    });

    group('TodoStarted', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when loaded list is empty',
        setUp: () {
          when(
            () => getAllTodoUseCase.execute(),
          ).thenAnswer((_) => []);
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoStartedEvent()),
        expect: () => [TodoLoadingState(), TodoLoadedState(TodoModel(todoList: []))],
        verify: (bloc) => {verify(getAllTodoUseCase.execute).called(1)},
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when list is loaded successfully',
        setUp: () {
          when(
            () => getAllTodoUseCase.execute(),
          ).thenAnswer((_) => mockTodoDomainList);
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoStartedEvent()),
        expect: () =>
            [TodoLoadingState(), TodoLoadedState(TodoModel(todoList: mockTodoVOList))],
        verify: (bloc) => {verify(getAllTodoUseCase.execute).called(1)},
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError] when loading the list throws an error',
        setUp: () {
          when(getAllTodoUseCase.execute).thenThrow(Exception('Error'));
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoStartedEvent()),
        expect: () => <TodoState>[TodoLoadingState(), TodoErrorState()],
        verify: (_) => verify(getAllTodoUseCase.execute).called(1),
      );
    });

    group('TodoItemAdded', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when item is added successfully',
        setUp: () {
          when(getAllTodoUseCase.execute)
              .thenAnswer((_) => [...mockTodoDomainList, todoDomainToAdd]);
          when(
            () => addTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemAddedEvent(todoVOToAdd)),
        expect: () => <TodoState>[
          TodoLoadingState(),
          TodoLoadedState(TodoModel(todoList: [...mockTodoVOList, todoVOToAdd]))
        ],
        verify: (bloc) => {
          verify(
            () => addTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError]when adding the item throws an error',
        setUp: () {
          when(getAllTodoUseCase.execute).thenThrow(Exception('Error'));
          when(
            () => addTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemAddedEvent(todoVOToAdd)),
        expect: () => <TodoState>[TodoLoadingState(), TodoErrorState()],
        verify: (bloc) => {
          verify(
            () => addTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );
    });

    group('TodoItemUpdated', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when item is updated successfully',
        setUp: () {
          when(getAllTodoUseCase.execute)
              .thenAnswer((_) => [...mockTodoDomainList]);
          when(
            () => updateTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemUpdatedEvent(todoVOToAdd)),
        expect: () => <TodoState>[
          TodoLoadingState(),
          TodoLoadedState(TodoModel(todoList: [...mockTodoVOList]))
        ],
        verify: (bloc) => {
          verify(
                () => updateTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError]when updating the item throws an error',
        setUp: () {
          when(getAllTodoUseCase.execute).thenThrow(Exception('Error'));
          when(
            () => updateTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemUpdatedEvent(todoVOToAdd)),
        expect: () => <TodoState>[TodoLoadingState(), TodoErrorState()],
        verify: (bloc) => {
          verify(
            () => updateTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );
    });

    group('TodoItemToggleCompleted', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when item is toggled successfully',
        setUp: () {
          when(getAllTodoUseCase.execute)
              .thenAnswer((_) => [...mockTodoDomainList]);
          when(
                () => toggleCompleteTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemToggleCompletedEvent(todoVOToAdd)),
        expect: () => <TodoState>[
          TodoLoadingState(),
          TodoLoadedState(TodoModel(todoList: [...mockTodoVOList]))
        ],
        verify: (bloc) => {
          verify(
                () => toggleCompleteTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError]when toggling the item throws an error',
        setUp: () {
          when(getAllTodoUseCase.execute).thenThrow(Exception('Error'));
          when(
                () => toggleCompleteTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemToggleCompletedEvent(todoVOToAdd)),
        expect: () => <TodoState>[TodoLoadingState(), TodoErrorState()],
        verify: (bloc) => {
          verify(
                () => toggleCompleteTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );
    });

    group('TodoItemDeleted', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when item is deleted successfully',
        setUp: () {
          when(getAllTodoUseCase.execute)
              .thenAnswer((_) => [...mockTodoDomainList]);
          when(
                () => deleteTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemDeletedEvent(todoVOToAdd.id)),
        expect: () => <TodoState>[
          TodoLoadingState(),
          TodoLoadedState(TodoModel(todoList: [...mockTodoVOList]))
        ],
        verify: (bloc) => {
          verify(
                () => deleteTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError]when deleting the item throws an error',
        setUp: () {
          when(getAllTodoUseCase.execute).thenThrow(Exception('Error'));
          when(
                () => deleteTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemDeletedEvent(todoVOToAdd.id)),
        expect: () => <TodoState>[TodoLoadingState(), TodoErrorState()],
        verify: (bloc) => {
          verify(
                () => deleteTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );
    });

    group('TodoItemUndoDeleted', () {
      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when item is undone successfully',
        setUp: () {
          when(getAllTodoUseCase.execute)
              .thenAnswer((_) => [...mockTodoDomainList]);
          when(
                () => undoDeletedTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemUndoDeletedEvent(todoVOToAdd)),
        expect: () => <TodoState>[
          TodoLoadingState(),
          TodoLoadedState(TodoModel(todoList: [...mockTodoVOList]))
        ],
        verify: (bloc) => {
          verify(
                () => undoDeletedTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError]when undoing item throws an error',
        setUp: () {
          when(getAllTodoUseCase.execute).thenThrow(Exception('Error'));
          when(
                () => undoDeletedTodoUseCase.execute(any()),
          ).thenAnswer((_) async {});
        },
        build: () => buildTodoBloc(),
        act: (bloc) => bloc.add(TodoItemUndoDeletedEvent(todoVOToAdd)),
        expect: () => <TodoState>[TodoLoadingState(), TodoErrorState()],
        verify: (bloc) => {
          verify(
                () => undoDeletedTodoUseCase.execute(any()),
          ).called(1),
          verify(getAllTodoUseCase.execute).called(1)
        },
      );});
  });

}
