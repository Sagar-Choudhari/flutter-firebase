import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/user.dart';

class Add extends StatelessWidget {
  Add({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final mailCtrl = TextEditingController();
  final numCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Client"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  return value!.isNotEmpty ? null : "Enter any name";
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: mailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: const Icon(Icons.mail_outline_rounded),
                  labelText: 'Email address',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  return value!.isNotEmpty ? null : "Enter any address";
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: numCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: const Icon(Icons.call),
                  labelText: 'Phone number',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  return value!.isNotEmpty ? null : "Enter any number";
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  icon: const Icon(Icons.password),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  return value!.isNotEmpty ? null : "Enter any password";
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton(style: ElevatedButton.styleFrom(fixedSize: const Size(280, 40)),
                child: const Text('Add to Firebase'),
                onPressed: () {
                  final user = User(
                      name: nameCtrl.text,
                      email: mailCtrl.text,
                      number: numCtrl.text,
                      password: passCtrl.text);
                  addData(user);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addData(User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    // final user = User(id: docUser.id, name: name, email: '', number: '', password: '');
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json);
  }
}
