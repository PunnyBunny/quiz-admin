import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';

class SchoolEditPage extends StatefulWidget {
  final School? initialSchool;
  final List<Student>? initialStudents;
  final void Function(School) onSave;
  final String title;

  /// When [onSave] is called, the school's id will NOT be populated.
  const SchoolEditPage({
    Key? key,
    this.initialSchool,
    this.initialStudents,
    required this.onSave,
    required this.title,
  }) : super(key: key);

  @override
  State<SchoolEditPage> createState() => _SchoolEditPageState();
}

class _SchoolEditPageState extends State<SchoolEditPage> {
  late TextEditingController _nameController;
  bool _nameValid = true;

  late TextEditingController _phoneNumberController;
  bool _phoneNumberValid = true;

  late TextEditingController _schoolTypeController;
  late SchoolType _schoolType;

  late TextEditingController _emailController;
  bool _emailValid = true;

  late TextEditingController _addressController;
  bool _addressValid = true;

  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSchool?.name)
      ..addListener(() {
        if (_nameController.text.isNotEmpty) {
          setState(() {
            _nameValid = true;
          });
        }
      });
    _phoneNumberController =
        TextEditingController(text: widget.initialSchool?.phoneNum)
          ..addListener(() {
            if (_phoneNumberController.text.length == 8) {
              setState(() {
                _phoneNumberValid = true;
              });
            }
          });
    _emailController = TextEditingController(text: widget.initialSchool?.email)
      ..addListener(() {
        if (EmailValidator.validate(_emailController.text)) {
          setState(() {
            _emailValid = true;
          });
        }
      });
    _addressController =
        TextEditingController(text: widget.initialSchool?.address)
          ..addListener(() {
            if (_addressController.text.isNotEmpty) {
              setState(() {
                _addressValid = true;
              });
            }
          });
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
      child: CloseKeyboardOnTap(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.school),
                              errorText: _nameValid ? null : '學校名稱不能為空',
                              labelText: '學校名稱',
                              helperText: '*必須填寫',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone),
                              errorText: _phoneNumberValid ? null : '電話必須為8位數字',
                              labelText: '學校電話',
                              helperText: '*必須填寫',
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownMenu<SchoolType>(
                          leadingIcon: const Icon(Icons.attach_money),
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
                          helperText: '', // to match the padding
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
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              errorText: _emailValid ? null : '電子郵件格式不正確',
                              labelText: '學校電子郵件',
                              helperText: '*必須填寫',
                              border: const OutlineInputBorder(),
                            ),
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
                            controller: _addressController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.home),
                              errorText: _addressValid ? null : '地址不能為空',
                              labelText: '學校地址',
                              helperText: '*必須填寫',
                              border: const OutlineInputBorder(),
                            ),
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
                            controller: _websiteController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.language),
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
                      setState(() {
                        _nameValid = _nameController.text.isNotEmpty;
                        _phoneNumberValid =
                            _phoneNumberController.text.length == 8;
                        _emailValid =
                            EmailValidator.validate(_emailController.text);
                        _addressValid = _addressController.text.isNotEmpty;
                      });

                      if (_nameValid &&
                          _phoneNumberValid &&
                          _emailValid &&
                          _addressValid) {
                        widget.onSave.call(School(
                          _nameController.text,
                          _schoolType,
                          _phoneNumberController.text,
                          _emailController.text,
                          _addressController.text,
                          _websiteController.text,
                          '',
                        ));
                        Navigator.of(context).pop();
                      }
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
