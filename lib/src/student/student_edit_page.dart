import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';

class StudentEditPage extends StatefulWidget {
  final Student? initialStudent;
  final void Function(Student) onSave;
  final String title;

  /// When [onSave] is called, the student's id will NOT be populated.
  const StudentEditPage({
    Key? key,
    this.initialStudent,
    required this.onSave,
    required this.title,
  }) : super(key: key);

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  late TextEditingController _nameController;
  bool _nameValid = true;

  late TextEditingController _formController;
  late StudentForm _form;

  late TextEditingController _genderController;
  late Gender _gender;

  late TextEditingController _diagnosisController;
  late DateTime _dob;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialStudent?.name)
      ..addListener(() {
        if (_nameController.text.isNotEmpty) {
          setState(() {
            _nameValid = true;
          });
        }
      });
    _diagnosisController =
        TextEditingController(text: widget.initialStudent?.diagnosis);
    _gender = widget.initialStudent?.gender ?? Gender.values[0];
    _genderController = TextEditingController(text: _gender.chineseName);
    _form = widget.initialStudent?.form ?? StudentForm.values[0];
    _formController = TextEditingController(text: _form.chineseName);
    _dob = widget.initialStudent?.dob ?? DateTime(1990, 1, 1);
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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                errorText: _nameValid ? null : '名稱不能為空',
                                labelText: '學生名稱',
                                helperText: '*必須填寫',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownMenu<Gender>(
                            leadingIcon: const Icon(Icons.wc),
                            controller: _genderController,
                            label: const Text("性別"),
                            dropdownMenuEntries: Gender.values
                                .map((e) => DropdownMenuEntry(
                                    value: e, label: e.chineseName))
                                .toList(),
                            textStyle: Theme.of(context).textTheme.titleMedium,
                            onSelected: (gender) => _gender = gender!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownMenu<StudentForm>(
                            leadingIcon: const Icon(Icons.school),
                            controller: _formController,
                            label: const Text("級別"),
                            dropdownMenuEntries: StudentForm.values
                                .map((e) => DropdownMenuEntry(
                                    value: e, label: e.chineseName))
                                .toList(),
                            textStyle: Theme.of(context).textTheme.titleMedium,
                            onSelected: (form) => _form = form!,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilledButton.tonal(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(Icons.calendar_month),
                                  ),
                                  Text(
                                      '出生日期: ${_dob.year}年${_dob.month}月${_dob.day}日'),
                                ],
                              ),
                              onPressed: () async {
                                final dob = await showDatePicker(
                                  context: context,
                                  initialDate: _dob,
                                  firstDate: DateTime(1990, 1, 1),
                                  lastDate: DateTime.now(),
                                );
                                if (dob != null) {
                                  setState(() {
                                    _dob = dob;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _diagnosisController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.description),
                                labelText: '診斷',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _nameValid = _nameController.text.isNotEmpty;
                        });
                        if (_nameValid) {
                          widget.onSave.call(Student(
                            _nameController.text,
                            _gender,
                            _dob,
                            _diagnosisController.text,
                            _form,
                            '',
                          ));
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("確認"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _genderController.dispose();
    _formController.dispose();
    _nameController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }
}
