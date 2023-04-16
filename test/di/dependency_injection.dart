import 'package:flutter_hive_todo_bloc_clean_architecture/app/bloc/todo_bloc.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/data/datasource/crud_datasource.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/data/repository_impl/todo_repository_impl.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/repository/todo_repository.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/add_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/delete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/get_all_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/toggle_complete_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/undo_deleted_todo_usecase.dart';
import 'package:flutter_hive_todo_bloc_clean_architecture/domain/usecase/update_todo_usecase.dart';
import '../mock/mock_database.dart';

//datasource
CRUDDataSource provideCRUDDataSource() => MockDatabase();

//repository
TodoRepository provideTodoRepository() =>
    TodoRepositoryImpl(provideCRUDDataSource());

//use case
GetAllTodoUseCase provideGetAllTodoUseCase() =>
    GetAllTodoUseCase(provideTodoRepository());
AddTodoUseCase provideAddTodoUseCase() =>
    AddTodoUseCase(provideTodoRepository());
UpdateTodoUseCase provideUpdateTodoUseCase() =>
    UpdateTodoUseCase(provideTodoRepository());
ToggleCompleteTodoUseCase provideToggleCompleteTodoUseCase() =>
    ToggleCompleteTodoUseCase(provideTodoRepository());
DeleteTodoUseCase provideDeleteTodoUseCase() =>
    DeleteTodoUseCase(provideTodoRepository());
UndoDeletedTodoUseCase provideUndoDeletedTodoUseCase() =>
    UndoDeletedTodoUseCase(provideTodoRepository());

//bloc
TodoBloc provideTodoBloc() => TodoBloc(
    getAllTodoUseCase: provideGetAllTodoUseCase(),
    addTodoUseCase: provideAddTodoUseCase(),
    updateTodoUseCase: provideUpdateTodoUseCase(),
    toggleCompleteTodoUseCase: provideToggleCompleteTodoUseCase(),
    deleteTodoUseCase: provideDeleteTodoUseCase(),
    undoDeletedTodoUseCase: provideUndoDeletedTodoUseCase());
