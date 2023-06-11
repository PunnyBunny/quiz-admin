import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Convert the value of a [DataSnapshot] obtained from the database
/// into its non-null version. The structure should be
/// { "id1": { "name": "ada", ... }, "id2": {...}, ... },
/// i.e. nested for one level only.
Map<String, Map<String, dynamic>> dataSnapshotToMap(Object value) {
  final id2json = value as Map<Object?, Object?>;
  return id2json.map(
    (id, json) => MapEntry(
      id! as String,
      (json! as Map<Object?, Object?>).map(
        (key, value) => MapEntry(key! as String, value!),
      ),
    ),
  );
}

Future<bool> _showDialog(BuildContext context, IconData icon, String title,
    String warning, String confirm, String cancel) async {
  bool ret = false;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(icon),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(warning),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(cancel),
        ),
        TextButton(
          onPressed: () {
            ret = true;
            Navigator.of(context).pop();
          },
          child: Text(confirm),
        ),
      ],
    ),
  );
  return ret;
}

/// Shows a prompt for confirmation of deletion.
/// Returns the user decision, [true] for deleting.
Future<bool> showDeleteDialog(BuildContext context) async {
  return await _showDialog(
    context,
    Icons.delete,
    "確認刪除？",
    "刪除的資料將無法復原。",
    "刪除",
    "取消",
  );
}

/// Shows a prompt for confirmation of leaving.
/// Returns the user decision, [true] for leaving.
Future<bool> showLeaveDialog(BuildContext context) async {
  return await _showDialog(
    context,
    Icons.delete,
    "確認離開？",
    "所作修改將不會被儲存。",
    "離開",
    "取消",
  );
}
