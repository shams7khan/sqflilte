import 'package:flutter/material.dart';
import 'package:sqflite_demo_app/dbhelper.dart';

class AddUpdateStudent extends StatefulWidget {
  Map<String, dynamic>? data;
  AddUpdateStudent({Key? key, this.data}) : super(key: key);

  @override
  _AddUpdateStudentState createState() => _AddUpdateStudentState();
}

class _AddUpdateStudentState extends State<AddUpdateStudent> {
  TextEditingController ageTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      setState(() {
        ageTEC.text = "${widget.data!["age"]}";
        nameTEC.text = "${widget.data!["name"]}";
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: ageTEC,
            decoration: InputDecoration(hintText: "Age"),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextField(
              controller: nameTEC,
              decoration: InputDecoration(hintText: "Name")),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                if (widget.data != null) {
                  //here for update
                  int updatedId = await DbHelper.instance.updateRow(
                      "student",
                      {"name": nameTEC.text, "age": int.parse(ageTEC.text)},
                      "id = ?",
                      [widget.data!["id"]]);
                  print("Update count $updatedId");
                  Navigator.pop(context, "update");
                } else {
                  int insertedId = await DbHelper.instance.insertRow("student",
                      {"name": nameTEC.text, "age": int.parse(ageTEC.text)});
                  print("insertion done $insertedId");
                  Navigator.pop(context, "add");
                }
              },
              child:  Text(widget.data == null ? "Add" : "Update"))
        ],
      ),
    );
  }
}
