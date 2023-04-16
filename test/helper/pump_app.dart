import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_bloc.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_event.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_state.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/app/routing/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTodoBloc extends MockBloc<TodoEvent, TodoState> implements TodoBloc {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp({
    TodoBloc? todoBloc,
    required Widget child,
  }) {
    return pumpWidget(MultiBlocProvider(
        providers: [
          if (todoBloc != null)
            BlocProvider(create: (_) => todoBloc..add(TodoStartedEvent()))
          else
            BlocProvider(
                create: (_) => MockTodoBloc()..add(TodoStartedEvent())),
        ],
        child: MaterialApp.router(
          title: 'Hive Todo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: goRouter,
        )));
  }
}
