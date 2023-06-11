import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/school/school_edit_page.dart';

class SchoolTile extends StatelessWidget {
  final School school;
  final void Function(School) onSave;
  final void Function() onDelete;
  final String schoolId;

  const SchoolTile({
    Key? key,
    required this.school,
    required this.onSave,
    required this.onDelete,
    required this.schoolId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(school.name),
              subtitle: Text(school.type.chineseName),
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
                        builder: (_) => SchoolEditPage(
                          initialSchool: school,
                          title: "修改學校",
                          onSave: (school) => onSave.call(school),
                          schoolId: schoolId,
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
