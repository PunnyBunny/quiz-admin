import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/student/student_edit_page.dart';
import 'package:quiz_admin/src/student/student_tile.dart';

class StudentPage extends StatefulWidget {
  final School school;

  const StudentPage({Key? key, required this.school}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final List<Student> _students = [];
  late DatabaseReference _studentsRef;
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _studentsRef =
        FirebaseDatabase.instance.ref('/students/${widget.school.id}');
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

  Widget _page(BuildContext context) {
    return CloseKeyboardOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text("學生：${widget.school.name}"),
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
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Search(
                  initialList: _students,
                  builder: (student) => StudentTile(
                    student: student,
                    onSave: (studentNew) async {
                      final id = student.id;
                      studentNew.id = id;
                      setState(() {
                        _students
                            .firstWhere((e) => e.id == id)
                            .set(studentNew);
                        _sortStudents();
                      });
                      await _studentsRef
                          .child(id)
                          .set(studentNew.toJson());
                    },
                    onDelete: () async {
                      final id = student.id;
                      setState(() {
                        _students.removeWhere((e) => e.id == id);
                      });
                      await _studentsRef.child(id).remove();
                    },
                  ),
                  filter: (student, str) =>
                      student.name.toLowerCase().contains(str),
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("新增學生"),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StudentEditPage(
                title: "新增學生",
                onSave: (studentNew) async {
                  final ref =
                      _studentsRef.push(); // gets a new student location
                  final id = basename(ref.path);
                  studentNew.id = id;
                  setState(() {
                    _students.add(studentNew);
                    _sortStudents();
                  });
                  await ref.set(studentNew.toJson());
                },
              ),
            ));
          },
        ),
      ),
    );
  }

  void _initialise(DataSnapshot? data) {
    if (data != null && data.value != null) {
      dataSnapshotToMap(data.value!).forEach((id, json) {
        json['id'] = id;
        _students.add(Student.fromJson(json));
      });
    }
    _initialised = true;
  }

  void _sortStudents() {
    _students.sort((Student a, Student b) => a.name.compareTo(b.name));
  }
}
