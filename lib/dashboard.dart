import 'package:flutter/material.dart';
import 'package:sqflite_demo_app/add_update_student.dart';
import 'package:sqflite_demo_app/dbhelper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> dataArr = [];

  @override
  void initState() {
    super.initState();
    // setupDB();
    readData();
  }

  readData() async {
    var db = DbHelper.instance;
    dataArr = await db.getAllRows('student');
    print("students are $dataArr");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
      ),
      body: ListView.separated(
          itemBuilder: (ctx, indexNo) {
            Map<String, dynamic> data = dataArr[indexNo];
            return Card(
              child: ListTile(
                title: Text(data["name"]),
                subtitle: Text("${data["age"]}"),
                trailing: Wrap(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () async {
                        await DbHelper.instance
                            .deleteRow("student", "id = ?", [data["id"]]);
                        readData();
                      },
                    ),
                    GestureDetector(
                      child: Icon(Icons.edit),
                      onTap: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => AddUpdateStudent(
                                      data: data,
                                    )));
                        if (result != null) {
                          readData();
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (ctx, indexNo) {
            return SizedBox(height: 5);
          },
          itemCount: dataArr.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => AddUpdateStudent()));
          if (result != null) {
            readData();
          }
        },
        child: const Icon(Icons.plus_one),
      ),
    );
  }
}
