import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_bloc.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_event.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_state.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/model/todo_model.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/page/add/add_todo_screen.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/page/home/home_screen.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/vo/todo_vo.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/model/todo_domain.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/repository/todo_repository.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/add_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/delete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/get_all_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/toggle_complete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/undo_deleted_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/update_todo_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'di/dependency_injection.dart';
import 'helper/pump_app.dart';
import 'mock/fake_todo_domain.dart';
import 'mock/mock_add_todo_usecase.dart';
import 'mock/mock_delete_todo_usecase.dart';
import 'mock/mock_get_all_todo_usecase.dart';
import 'mock/mock_toggle_complete_todo_usecase.dart';
import 'mock/mock_undo_deleted_todo_usecase.dart';
import 'mock/mock_update_todo_usecase.dart';

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

  final mockTodoDomainList = [
    mockTodoDomain1,
    mockTodoDomain2,
  ];
  var todoVOToAdd1 = TodoVO(
      id: 3, title: "new test1", description: "new description1", isCompleted: false);

  var todoVOToAdd2 = TodoVO(
      id: 4, title: "new test2", description: "new description2", isCompleted: false);

  var todoVOToUpdate = TodoVO(
      id: 4, title: "updated test", description: "updated description", isCompleted: false);


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
    when(getAllTodoUseCase.execute).thenAnswer((_)  => mockTodoDomainList);
  });

  setUpAll(() {
    registerFallbackValue(FakeTodoDomain());
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

  group('TodoListScreen', () {
    late TodoBloc todoBloc;

    setUp(() {
      todoBloc = provideTodoBloc();
    });

    tearDown(() => {
      todoBloc.close()
    });

    const addTitleTextFormField = Key('addTodo_title_textFormField');
    const addDescriptionTextFormField =
    Key('addTodo_description_textFormField');
    const updateTitleTextFormField = Key('updateTodo_title_textFormField');
    const updateDescriptionTextFormField =
    Key('updateTodo_description_textFormField');

    Future<void> startApp(tester) async {
      final todoBloc = provideTodoBloc();
      await tester.pumpApp(todoBloc:todoBloc..add(TodoStartedEvent()) ,child:const MaterialApp(
        home: HomeScreen(),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('should display todo items', (tester) async {
      final bloc = buildTodoBloc();
      await tester.pumpApp(todoBloc:bloc ,child:const MaterialApp(
        home: HomeScreen(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Hive Todo'), findsOneWidget);
      expect(find.text('Empty'), findsNothing);
      expect(find.text(mockTodoDomain1.title), findsOneWidget);
      expect(find.text(mockTodoDomain1.description), findsOneWidget);
      expect(find.text(mockTodoDomain2.title), findsOneWidget);
      expect(find.text(mockTodoDomain2.description), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      verify(getAllTodoUseCase.execute).called(1);
    });

    testWidgets('should work curd process properly', (tester) async {
      final todoBloc = provideTodoBloc();
      await tester.pumpApp(todoBloc:todoBloc ,child:const MaterialApp(
        home: HomeScreen(),
      ));
      await tester.pumpAndSettle();

      //region R- Read
      expect(find.text('Hive Todo'), findsOneWidget);
      expect(find.text('Empty'), findsOneWidget);
      //endregion

      //region C- Create
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      //Check Add Todo views
      expect(find.text('Add Todo'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      // Add first todo
      await tester.enterText(find.byKey(addTitleTextFormField), todoVOToAdd1.title);
      await tester.enterText(find.byKey(addDescriptionTextFormField), todoVOToAdd1.description);

      // Tap the "Add" button
      final addButton = find.text('Add');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify that the new
      final newTodoItemTitle = find.text(todoVOToAdd1.title);
      final newTodoItemDescription = find.text(todoVOToAdd1.description);
      expect(newTodoItemTitle, findsOneWidget);
      expect(newTodoItemDescription, findsOneWidget);
      final firstCheckbox = tester.widget<Checkbox>(find.byKey(const Key('todo_item_checkbox_1')));
      expect(firstCheckbox.value, isFalse);
      expect(find.text('Add Todo'), findsNothing);
      expect(find.text('Empty'), findsNothing);
      expect(find.text('Hive Todo'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Add second todo
      // Find the input fields and enter some text
      await tester.enterText(find.byKey(addTitleTextFormField), todoVOToAdd2.title);
      await tester.enterText(find.byKey(addDescriptionTextFormField), todoVOToAdd2.description);

      // Tap the "Add" button
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify that the new
      expect(find.text(todoVOToAdd2.title), findsOneWidget);
      expect(find.text(todoVOToAdd2.description), findsOneWidget);
      var secondCheckbox = tester.widget<Checkbox>(find.byKey(const Key('todo_item_checkbox_2')));
      expect(secondCheckbox.value, isFalse);
      expect(find.text('Add Todo'), findsNothing);
      expect(find.text('Empty'), findsNothing);
      expect(find.text('Hive Todo'), findsOneWidget);
      //endregion

      //region U-Update
      //Click item
      await tester.tap(find.text(todoVOToAdd2.title));
      await tester.pumpAndSettle();

      //Check Update Todo views
      expect(find.text('Update Todo'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      // Find the input fields and enter some text
      await tester.enterText(find.byKey(updateTitleTextFormField), todoVOToUpdate.title);
      await tester.enterText(find.byKey(updateDescriptionTextFormField), todoVOToUpdate.description);

      // Tap the "Add" button
      final updateButton = find.text('Update');
      await tester.tap(updateButton);
      await tester.pumpAndSettle();

      // Verify that the new
      expect(find.text(todoVOToUpdate.title), findsOneWidget);
      expect(find.text(todoVOToUpdate.description), findsOneWidget);
      expect(find.text('Update Todo'), findsNothing);
      expect(find.text('Empty'), findsNothing);
      expect(find.text('Hive Todo'), findsOneWidget);
      // Verify that the old is not showing
      expect(find.text(todoVOToAdd2.title), findsNothing);
      expect(find.text(todoVOToAdd2.description), findsNothing);

      //Check toggle checkbox
      await tester.tap(find.byKey(const Key('todo_item_checkbox_2')));
      await tester.pump();

      secondCheckbox = tester.widget<Checkbox>(find.byKey(const Key('todo_item_checkbox_2')));
      expect(secondCheckbox.value, isTrue);

      //endregion

      //region D-Delete
      var latestTodoList = [];
      if (todoBloc.state is TodoLoadedState){
        if (todoBloc.state.props.first is TodoModel){
      latestTodoList = (todoBloc.state.props.first as TodoModel).todoList;
      }
      }
      var lastTodoList =
      await tester.fling(
        find.text(todoVOToAdd1.title),
        const Offset(-300, 0),
        3000,
      );
      await tester.pumpAndSettle();

      // Verify that the last one is deleted
      expect(find.text(todoVOToAdd1.title), findsNothing);
      expect(find.text(todoVOToAdd1.description), findsNothing);

      // Tap the "Add" button
      final undoButton = find.text('Undo');
      await tester.tap(undoButton);
      await tester.pumpAndSettle();

      // Verify that undo todo
      expect(find.text(todoVOToAdd1.title), findsOneWidget);
      expect(find.text(todoVOToAdd1
          .description), findsOneWidget);
      expect(find.text(todoVOToUpdate.title), findsOneWidget);
      expect(find.text(todoVOToUpdate.description), findsOneWidget);
      //endregion

    });
  });
}
