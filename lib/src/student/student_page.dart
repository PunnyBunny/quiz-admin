import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/student/student_edit_page.dart';
import 'package:quiz_admin/src/student/student_tile.dart';
import 'package:tuple/tuple.dart';

class StudentPage extends StatefulWidget {
  final String schoolId;

  const StudentPage({Key? key, required this.schoolId}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final List<Tuple2<String, Student>> _students = [];
  late DatabaseReference _studentsRef;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _studentsRef =
        FirebaseDatabase.instance.ref('/students/${widget.schoolId}');
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialised) {
      return FutureBuilder(
        future: _studentsRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          _initialise(snapshot.data);

          return _page(context);
        },
      );
    }

    return _page(context);
  }

  void _initialise(DataSnapshot? data) {
    if (data != null && data.value != null) {
      dataSnapshotToMap(data.value!).forEach((id, json) {
        _students.add(Tuple2(id, Student.fromJson(json)));
      });
    }
    _initialised = true;
  }

  Widget _page(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("修改學生"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _students.clear();
                _initialised = false;
              });
            },
          ),
        ],
      ),
      body: _students.isEmpty
          ? const Center(child: Text('沒有學生'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                    // to prevent the actions being blocked by the FAB
                    itemCount: _students.length,
                    itemBuilder: (context, i) => StudentTile(
                      student: _students[i].item2,
                      onSave: (school) async {
                        final id = _students[i].item1;
                        setState(() {
                          _students[i] = Tuple2(id, school);
                        });
                        await _studentsRef.child(id).set(school.toJson());
                      },
                      onDelete: () async {
                        final id = _students[i].item1;
                        setState(() {
                          _students.removeAt(i);
                        });
                        await _studentsRef.child(id).remove();
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("新增學生"),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudentEditPage(
              title: "新增學生",
              onSave: (student) async {
                final ref = _studentsRef.push(); // gets a new student location
                final id = basename(ref.path);
                await ref.set(student.toJson());
                setState(() {
                  _students.add(Tuple2(id, student));
                });
              },
            ),
          ));
        },
      ),
    );
  }
}
