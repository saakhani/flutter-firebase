import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
  }

  final _todoTitleController = TextEditingController();
  final _todoDescController = TextEditingController();

  Future<void> addData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection('to-do list').add({
      'title': _todoTitleController.text,
      'description': _todoDescController.text,
    });
    print('Data added successfully');
  } catch (e) {
    print('Error adding data: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add To-do"),
        backgroundColor: Color.fromARGB(255, 132, 202, 243),
      ),
      body: Center(child: 
      Column(children: [TextField()],),),
    );
  }
}
