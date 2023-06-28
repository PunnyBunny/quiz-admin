import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/student/student_edit_page.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final void Function(Student) onSave;
  final void Function() onDelete;

  /// When [onSave] is called, the student's id will NOT be populated.
  const StudentTile(
      {Key? key,
      required this.student,
      required this.onSave,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(student.name),
      subtitle:
          Text(student.diagnosis.isEmpty ? '沒有診斷' : '診斷：${student.diagnosis}'),
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton(
                  onPressed: () async {
                    if (await showDeleteDialog(context)) onDelete.call();
                  },
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        Text('刪除'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StudentEditPage(
                          initialStudent: student,
                          title: "修改學生",
                          onSave: (studentNew) {
                            onSave.call(studentNew);
                          },
                        ),
                      ),
                    );
                  },
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        Text('修改'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FilledButton(
                  onPressed: () {
                    // TODO: merge talktalk
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => StudentEditPage(
                    //       initialStudent: student,
                    //       title: "修改學生",
                    //       onSave: (student) {
                    //         onSave.call(student);
                    //       },
                    //     ),
                    //   ),
                    // );
                  },
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login),
                        Text('進入測試'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
