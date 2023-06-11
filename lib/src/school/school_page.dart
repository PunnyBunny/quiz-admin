import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/school/school_edit_page.dart';
import 'package:quiz_admin/src/school/school_tile.dart';
import 'package:tuple/tuple.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({Key? key}) : super(key: key);

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  final List<Tuple2<String, School>> _schools = [];
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

  void _initialise(DataSnapshot? data) {
    if (data != null && data.value != null) {
      dataSnapshotToMap(data.value!).forEach((id, json) {
        _schools.add(Tuple2(id, School.fromJson(json)));
      });
    }
    _initialised = true;
  }

  Widget _page(BuildContext context) {
    return Scaffold(
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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                    // to prevent the actions being blocked by the FAB
                    itemCount: _schools.length,
                    itemBuilder: (context, i) => SchoolTile(
                      schoolId: _schools[i].item1,
                      school: _schools[i].item2,
                      onSave: (school) async {
                        final id = _schools[i].item1;
                        setState(() {
                          _schools[i] = Tuple2(id, school);
                        });
                        await _schoolsRef.child(id).set(school.toJson());
                      },
                      onDelete: () async {
                        final id = _schools[i].item1;
                        setState(() {
                          _schools.removeAt(i);
                        });
                        await _schoolsRef.child(id).remove();
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("新增學校"),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SchoolEditPage(
              title: "新增學校",
              onSave: (school) async {
                final ref = _schoolsRef.push(); // gets a new school location
                final id = basename(ref.path);
                await ref.set(school.toJson());
                setState(() {
                  _schools.add(Tuple2(id, school));
                });
              },
            ),
          ));
        },
      ),
    );
  }
}
