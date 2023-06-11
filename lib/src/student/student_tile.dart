import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/student/student_edit_page.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final void Function(Student) onSave;
  final void Function() onDelete;

  const StudentTile(
      {Key? key,
      required this.student,
      required this.onSave,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(student.name),
              subtitle: Text(student.diagnosis),
            ),
          ),
          const Divider(indent: 20, endIndent: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(
                  onPressed: () async {
                    if (await showDeleteDialog(context)) onDelete.call();
                  },
                  child: const Text('刪除'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StudentEditPage(
                          initialStudent: student,
                          title: "修改學生",
                          onSave: (student) {
                            onSave.call(student);
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('修改'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
