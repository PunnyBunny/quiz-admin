import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/core/utils.dart';

class SlpEditPage extends StatefulWidget {
  final Slp? initialSlp;
  final void Function(Slp) onSave;
  final String title;

  const SlpEditPage({
    Key? key,
    this.initialSlp,
    required this.onSave,
    required this.title,
  }) : super(key: key);

  @override
  State<SlpEditPage> createState() => _SlpEditPageState();
}

class _SlpEditPageState extends State<SlpEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _genderController;
  late Gender _gender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSlp?.name);
    _emailController = TextEditingController(text: widget.initialSlp?.email);
    _passwordController =
        TextEditingController(text: widget.initialSlp?.password);
    _gender = widget.initialSlp?.gender ?? Gender.values[0];
    _genderController = TextEditingController(text: _gender.chineseName);
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
                        const Icon(Icons.person),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: '言語治療師名稱',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.wc),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownMenu<Gender>(
                            controller: _genderController,
                            dropdownMenuEntries: Gender.values.map(
                                (e) => DropdownMenuEntry(value: e, label: e.chineseName)
                            ).toList(),
                            onSelected: (gender) => _gender = gender!,
                            label: const Text('言語治療師'),
                            textStyle: Theme.of(context).textTheme.titleMedium,
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
                                labelText: '電郵',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: '登入密碼',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onSave.call(Slp(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                          _gender,
                          '',
                        ));
                        Navigator.of(context).pop();
                      },
                      child: const Text("確認"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editField(String field) {
    final controller = TextEditingController(text: field);
    return TextField(
      controller: controller,
      onChanged: (value) => field = value,
    );
  }
}
