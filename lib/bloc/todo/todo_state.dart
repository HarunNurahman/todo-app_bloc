part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final List<Todo> todo;
  final TodoStatus status;
  const TodoState({
    this.todo = const <Todo>[],
    this.status = TodoStatus.initial,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todo,
  }) {
    return TodoState(
      todo: todo ?? this.todo,
      status: status ?? this.status,
    );
  }

  @override
  factory TodoState.fromJson(Map<String, dynamic> json) {
    try {
      var listOfTodo = (json['todo'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();

      return TodoState(
          todo: listOfTodo,
          status: TodoStatus.values.firstWhere(
            (element) => element.toString() == json['status'],
          ));
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'todo': todo,
      'status': status.name,
    };
  }

  @override
  List<Object> get props => [todo, status];
}
