import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/slp/slp_edit_page.dart';
import 'package:quiz_admin/src/slp/slp_tile.dart';
import 'package:tuple/tuple.dart';

import '../core/types.dart';


class SlpPage extends StatefulWidget {
  const SlpPage({Key? key}) : super(key: key);

  @override
  State<SlpPage> createState() => _SlpPageState();
}

class _SlpPageState extends State<SlpPage> {
  final List<Tuple2<String, Slp>> _slps = [];
  final DatabaseReference _slpsRef =
  FirebaseDatabase.instance.ref('/slp');
  bool _initialised = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialised) {
      return FutureBuilder(
        future: _slpsRef.get(),
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
        _slps.add(Tuple2(id, Slp.fromJson(json)));
      });
    }
    _initialised = true;
  }

  Widget _page(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("言語治療師"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _slps.clear();
                _initialised = false;
              });
            },
          ),
        ],
      ),
      body: _slps.isEmpty
          ? const Center(child: Text('沒有言語治療師'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
              // to prevent the actions being blocked by the FAB
              itemCount: _slps.length,
              itemBuilder: (context, i) => SlpTile(
                slp: _slps[i].item2,
                onSave: (slp) async {
                  final id = _slps[i].item1;
                  setState(() {
                    _slps[i] = Tuple2(id, slp);
                  });
                  await _slpsRef.child(id).set(slp.toJson());
                },
                onDelete: () async {
                  final id = _slps[i].item1;
                  setState(() {
                    _slps.removeAt(i);
                  });
                  await _slpsRef.child(id).remove();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("新增言語治療師"),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SlpEditPage(
              title: "新增言語治療師",
              onSave: (slp) async {
                final ref = _slpsRef.push(); // gets a new school location
                final id = basename(ref.path);
                await ref.set(slp.toJson());
                setState(() {
                  _slps.add(Tuple2(id, slp));
                });
              },
            ),
          ));
        },
      ),
    );
  }
}
