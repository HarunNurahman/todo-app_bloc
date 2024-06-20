import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/bloc/todo/todo_bloc.dart';
import 'package:todo_app/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => TodoBloc()..add(TodoStarted()),
        child: const HomePage(),
      ),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Colors.white,
          onSurface: Colors.black,
          primary: Colors.yellowAccent,
          onPrimary: Colors.black,
          secondary: Colors.lightGreen,
          onSecondary: Colors.white,
        ),
      ),
    );
  }
}
