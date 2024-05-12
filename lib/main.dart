import 'package:classwork/screens/home_page.dart';
import 'package:classwork/screens/todo_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Products',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const HomePage(),
        routes: {
          '/todo': (context) => const TodoPage(),
        },
      );
    }
}

void main() async {
  runApp(MyApp());
}
