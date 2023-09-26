import 'package:flutter/material.dart';
import 'package:sqflite__/folders/update.dart';
import 'folders/database.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _namecontroller = TextEditingController();
  final _agecontroller = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  void _savedata() async {
    final name = _namecontroller.text;
    final age = int.tryParse(_agecontroller.text) ?? 0;
    int insertedId = await DatabaseHelper.insertUser(name, age);
    print(insertedId);

    List<Map<String, dynamic>> updateddata = await DatabaseHelper.getData();
    setState(() {
      dataList = updateddata;
    });
    _namecontroller.text = '';
    _agecontroller.text = '';
  }

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
    setState(() {
      dataList = userList;
    });
  }

  void delete(int docId) async {
    // ignore: unused_local_variable
    int id = await DatabaseHelper.deleteData(docId);
    List<Map<String, dynamic>> updateData = await DatabaseHelper.getData();
    setState(() {
      dataList = updateData;
    });
  }

  void fetchdata() async {
    List<Map<String, dynamic>> fetchData = await DatabaseHelper.getData();
    setState(() {
      dataList = fetchData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: _namecontroller,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _agecontroller,
                    decoration: const InputDecoration(hintText: 'Age'),
                  ),
                  ElevatedButton(
                    onPressed: _savedata,
                    child: const Text("Save User"),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(dataList[index]['name']),
                        subtitle: Text('Age ${dataList[index]['age']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateWidget(
                                        userId: dataList[index]['id'],
                                      ),
                                    ),
                                  ).then((result) {
                                    if (result == true) {
                                      fetchdata();
                                    }
                                  });
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  delete(dataList[index]['id']);
                                },
                              icon: const Icon(Icons.delete)),
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
