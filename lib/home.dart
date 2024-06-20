import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/bloc/todo/todo_bloc.dart';
import 'package:todo_app/data/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  alterTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Todo App',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController textController = TextEditingController();
              TextEditingController subtitleController =
                  TextEditingController();

              return AlertDialog(
                title: Text(
                  'Add a Task',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: textController,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      decoration: InputDecoration(
                        hintText: 'Enter a task',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: subtitleController,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      decoration: InputDecoration(
                        hintText: 'Task description',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addTodo(
                        Todo(
                          title: textController.text,
                          subtitle: subtitleController.text,
                        ),
                      );
                      textController.text = '';
                      subtitleController.text = '';
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todo.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Slidable(
                      key: ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              removeTodo(state.todo[index]);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          )
                        ],
                      ),
                      child: ListTile(
                        title: Text(state.todo[index].title!),
                        subtitle: Text(state.todo[index].subtitle!),
                        trailing: Checkbox(
                          value: state.todo[index].isDone,
                          activeColor: Theme.of(context).colorScheme.secondary,
                          onChanged: (value) {
                            alterTodo(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TodoStatus.initial) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
