import 'package:classwork/screens/home_page.dart';
import 'package:classwork/screens/todo_page.dart';
import 'package:firebase_core/firebase_core.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
