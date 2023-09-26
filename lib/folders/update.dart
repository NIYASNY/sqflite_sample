import 'package:flutter/material.dart';
import './database.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({Key? key, required this.userId}) : super(key: key);
  final int userId;

  @override
  State<UpdateWidget> createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  final _namecontroller = TextEditingController();
  final _agecontroller = TextEditingController();

  void fetchData() async {
    Map<String, dynamic>? data =
        await DatabaseHelper.getSingleData(widget.userId);
    if (data != null) {
      _namecontroller.text = data['name'];
      _agecontroller.text = data['age'].toString();
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _UpdateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'name': _namecontroller.text,
      'age': _agecontroller.text,
    };

    // ignore: unused_local_variable
    int id = await DatabaseHelper.UpdateData(widget.userId, data);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _namecontroller,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            TextFormField(
              controller: _agecontroller,
              decoration: InputDecoration(hintText: 'age'),
            ),
            ElevatedButton(
                onPressed: () {
                  _UpdateData(context);
                },
                child: Text('Update User'))
          ],
        ),
      ),
    );
  }
}
