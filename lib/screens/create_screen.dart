import 'package:firebase_assignment/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore db;

  const CloudFirestoreService(this.db);

  Future<String> add(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = await db.collection('resources').add(data);
    return document.id;
  }
}

class CreatePage extends StatefulWidget {
  final User userVer;
  CreatePage({super.key, required user}) : userVer = user;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late User _user;
  CloudFirestoreService? service;

  @override
  void initState() {
    // Initialize an instance of Cloud Firestore
    service = CloudFirestoreService(FirebaseFirestore.instance);
    _user = widget.userVer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final creatorController = TextEditingController();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Tile'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: creatorController,
                decoration: const InputDecoration(hintText: 'Creator'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // get first, last name from controllers
            final created = DateTime.timestamp();
            final profile = "https://i.pravatar.cc/300";
            final title = titleController.text.trim();
            final description = descriptionController.text.trim();
            final uploaderName = creatorController.text.trim();

            // call `add` to create new record
            print(service?.add({
              'created': created,
              'description': description,
              'profile': profile,
              'title': title,
              'uploaderName': uploaderName
            }));

                  Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: widget.userVer,),
        ),
      );;
          }),
    );
  }
}
