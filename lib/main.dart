import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/add.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crud/user.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Firebase Cloud'),
        '/add': (context) => Add(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController unameCtrl = TextEditingController();
  final TextEditingController umailCtrl = TextEditingController();
  final TextEditingController unumCtrl = TextEditingController();
  final TextEditingController upassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<User>>(
        stream: readData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('wrong ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUser(User user) => Padding(
        padding:
            const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 0.0),
        child: Slidable(
          // key: const ValueKey(0),
          key: UniqueKey(),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                deleteUser(user.id);
              },
            ),
            children: [
              SlidableAction(
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                onPressed: (BuildContext context) {
                  deleteUser(user.id);
                },
              ),
              // SlidableAction(
              //   onPressed: printText(),
              //   backgroundColor: const Color(0xFF21B7CA),
              //   foregroundColor: Colors.white,
              //   icon: Icons.share,
              //   label: 'Share',
              // ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              // SlidableAction(
              //   flex: 2,
              //   onPressed: printText(),
              //   backgroundColor: const Color(0xFF7BC043),
              //   foregroundColor: Colors.white,
              //   icon: Icons.archive,
              //   label: 'Archive',
              // ),
              SlidableAction(
                // onPressed: updateUser(user.id),
                backgroundColor: const Color(0xFF0392CF),
                foregroundColor: Colors.white,
                icon: Icons.mode_edit,
                label: 'Edit',
                onPressed: (BuildContext context) async {
                  // updateUser(user.id);
                  await showUpdateDialog(context, user);
                },
              ),
            ],
          ),
          child: ListTile(
            title: Text('Name: ${user.name}'),
            subtitle: Text('Email: ${user.email}, Phone: ${user.number}'),
            hoverColor: Colors.white30,
            onTap: () {
              showInformationDialog(context, user);
            },
          ),
        ),
      );

  Future updateUser(userId, User user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    user.id = userId;
    final json = user.toJson();
    await docUser.update(json);
  }

  deleteUser(userId) {
    final docUser = FirebaseFirestore.instance.collection('users').doc(userId);
    docUser.delete();
  }

  Future<void> showUpdateDialog(BuildContext context, User user) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: unameCtrl..text = user.name,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter any name";
                        },
                        decoration: const InputDecoration(
                            hintText: "Please Enter Name"
                        ),
                      ),
                      TextFormField(
                        controller: umailCtrl..text = user.email,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Enter any email";
                        },
                        decoration: const InputDecoration(
                            hintText: "Please Enter Email"),
                      ),
                      TextFormField(
                        controller: unumCtrl..text = user.number,
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : "Enter any phone number";
                        },
                        decoration: const InputDecoration(
                            hintText: "Please Enter Phone Number"),
                      ),
                      TextFormField(
                        controller: upassCtrl..text = user.password,
                        validator: (value) {
                          return value!.isNotEmpty
                              ? null
                              : "Enter any password";
                        },
                        decoration: const InputDecoration(
                            hintText: "Please Enter Password"),
                      ),
                    ],
                  )),
              title: const Text('Update details'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final details = User(
                          name: unameCtrl.text,
                          email: umailCtrl.text,
                          number: unumCtrl.text,
                          password: upassCtrl.text);
                      updateUser(user.id, details);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                )
              ],
            );
          });
        });
  }

  Future showInformationDialog(BuildContext context, User user) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ID: ${user.id!}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Name: ${user.name}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Email: ${user.email}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Number: ${user.number}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Password: ${user.password}'),
                  ),
                ],
              ),
              title: const Text('All Information'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                )
              ],
            );
          });
        });
  }

  Stream<List<User>> readData() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}
