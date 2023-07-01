import 'package:flutter/material.dart';
import 'package:sqlite_demo/locle_database.dart';
import 'package:sqlite_demo/sqlite_model.dart';

class SQLiteDemo extends StatefulWidget {
  const SQLiteDemo({super.key});

  @override
  State<SQLiteDemo> createState() => _SQLiteDemoState();
}

class _SQLiteDemoState extends State<SQLiteDemo> {
  TextEditingController txtNamecontroller = TextEditingController();
  late Future<List<User>> futureUserDeta;
  @override
  void initState() {
    futureUserDeta = LocalDatabase.selectData();
    super.initState();
  }

  int userselect = 0;
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
              controller: txtNamecontroller,
            ),
            ElevatedButton(
              onPressed: isEdit == true
                  ? () async {
                      User obj = User(
                        id: userselect,
                        userName: txtNamecontroller.text,
                      );
                      await LocalDatabase.updateData(obj);
                      futureUserDeta = LocalDatabase.selectData();
                      isEdit = false;
                      setState(() {});
                    }
                  : () {
                      User obj = User(userName: txtNamecontroller.text);
                      LocalDatabase.insertData(user: obj);
                      futureUserDeta = LocalDatabase.selectData();
                      setState(() {});
                    },
              child: Text(isEdit == false ? 'Submit' : 'Update'),
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<User> userData = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async {
                          await LocalDatabase.deleteData(userData[index].id!);
                          futureUserDeta = LocalDatabase.selectData();
                          setState(() {});
                        },
                        child: ListTile(
                          onTap: () {
                            isEdit = true;
                            txtNamecontroller.text = userData[index].userName!;
                            userselect = userData[index].id!;
                            setState(() {});
                          },
                          title: Text(userData[index].userName!),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.data == null) {
                  return const Text('Ther Is No Data');
                } else {
                  return const CircularProgressIndicator();
                }
              },
              future: futureUserDeta,
            )
          ],
        ),
      ),
    );
  }
}
