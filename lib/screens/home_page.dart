import 'package:classwork/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  // final _usernameController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('to-do list').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-do List"),
        backgroundColor: Color.fromARGB(255, 132, 202, 243),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/todo");
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['description']),
              );
            }).toList(),
          );
        },
      )
    );
  }
}
