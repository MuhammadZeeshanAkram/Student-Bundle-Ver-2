import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('ToDo')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var todos = snapshot.data!.docs;
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            var todo = todos[index];
            return ListTile(
              title: Text(todo['title']),
              leading: Checkbox(
                value: todo['completed'],
                onChanged: (bool? value) {
                  FirebaseFirestore.instance.collection('ToDo').doc(todo.id).update({
                    'completed': value,
                  });
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  FirebaseFirestore.instance.collection('ToDo').doc(todo.id).delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}
