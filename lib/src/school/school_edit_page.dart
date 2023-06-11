import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/student/student_page.dart';

class SchoolEditPage extends StatefulWidget {
  final School? initialSchool;
  final List<Student>? initialStudents;
  final void Function(School) onSave;
  final String title;
  final String? schoolId;

  const SchoolEditPage({
    Key? key,
    this.initialSchool,
    this.initialStudents,
    required this.onSave,
    required this.title,
    this.schoolId,
  }) : super(key: key);

  @override
  State<SchoolEditPage> createState() => _SchoolEditPageState();
}

class _SchoolEditPageState extends State<SchoolEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  late TextEditingController _schoolTypeController;
  late SchoolType _schoolType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSchool?.name);
    _phoneNumberController =
        TextEditingController(text: widget.initialSchool?.phoneNum);
    _emailController = TextEditingController(text: widget.initialSchool?.email);
    _addressController =
        TextEditingController(text: widget.initialSchool?.address);
    _websiteController =
        TextEditingController(text: widget.initialSchool?.website);
    _schoolType = widget.initialSchool?.type ??
        SchoolType.values[0]; // disallow empty field
    _schoolTypeController =
        TextEditingController(text: _schoolType.chineseName);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showLeaveDialog(context);
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Column(
                children: [
                  if (widget.schoolId != null)
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StudentPage(
                            schoolId: widget.schoolId!,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("修改學生"),
                          Icon(Icons.person_outline),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      const Icon(Icons.school),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: '學校名稱',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: _phoneNumberController,
                            decoration: const InputDecoration(
                              labelText: '學校電話',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      const Icon(Icons.attach_money),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownMenu<SchoolType>(
                          controller: _schoolTypeController,
                          label: const Text("學校類型"),
                          dropdownMenuEntries: SchoolType.values
                              .map((e) => DropdownMenuEntry(
                                  value: e, label: e.chineseName))
                              .toList(),
                          textStyle: Theme.of(context).textTheme.titleMedium,
                          // the textStyle of other text fields
                          onSelected: (type) {
                            _schoolType = type!;
                            // non-nullable because all options are non-null
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: '學校電子郵件',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.home),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: '學校地址',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.language),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _websiteController,
                            decoration: const InputDecoration(
                              labelText: '學校網站',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.onSave.call(School(
                        _nameController.text,
                        _schoolType,
                        _phoneNumberController.text,
                        _emailController.text,
                        _addressController.text,
                        _websiteController.text,
                        // _students,
                      ));
                      Navigator.of(context).pop();
                    },
                    child: const Text("確認"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _schoolTypeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
}
