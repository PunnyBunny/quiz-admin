import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/school/school_edit_page.dart';
import 'package:quiz_admin/src/school/school_tile.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({Key? key}) : super(key: key);

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  final List<School> _schools = [];
  final DatabaseReference _schoolsRef =
      FirebaseDatabase.instance.ref('/schools');
  bool _initialised = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialised) {
      return FutureBuilder(
        future: _schoolsRef.get(),
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
          title: const Text("學校"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _schools.clear();
                  _initialised = false;
                });
              },
            ),
          ],
        ),
        body: _schools.isEmpty
            ? const Center(child: Text('沒有學校'))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Search(
                  initialList: _schools,
                  builder: (school) => SchoolTile(
                    school: school,
                    onSave: (schoolNew) async {
                      final id = school.id;
                      schoolNew.id = id;
                      setState(() {
                        _schools.firstWhere((e) => e.id == id).set(schoolNew);
                      });
                      await _schoolsRef.child(id).set(schoolNew.toJson());
                    },
                    onDelete: () async {
                      final id = school.id;
                      setState(() {
                        _schools.removeWhere((e) => e.id == id);
                      });
                      await _schoolsRef.child(id).remove();
                    },
                  ),
                  filter: (school, str) =>
                      school.name.toLowerCase().contains(str),
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("新增學校"),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SchoolEditPage(
                title: "新增學校",
                onSave: (schoolNew) async {
                  final ref = _schoolsRef.push(); // gets a new school location
                  final id = basename(ref.path);
                  schoolNew.id = id;
                  await ref.set(schoolNew.toJson());
                  setState(() {
                    _schools.add(schoolNew);
                    _sortSchools();
                  });
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
        _schools.add(School.fromJson(json));
      });
      _sortSchools();
    }
    _initialised = true;
  }

  void _sortSchools() {
    _schools.sort((School a, School b) => a.name.compareTo(b.name));
  }
}
