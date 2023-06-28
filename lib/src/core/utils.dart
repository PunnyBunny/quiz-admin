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
      title: Text(title),
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

Future<bool> showLogoutDialog(BuildContext context) async {
  return await _showDialog(
    context,
    Icons.logout,
    '確認登出？',
    '你將要重新登入。',
    '登出',
    '取消',
  );
}

class CloseKeyboardOnTap extends StatelessWidget {
  final Widget child;

  const CloseKeyboardOnTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}

/// Returns a search view, with a TextField search bar,
/// and a ListView of results. It is case-insensitive:
/// [filter] will provide a lowercase string.
class Search<T> extends StatefulWidget {
  const Search(
      {Key? key,
      required this.initialList,
      required this.builder,
      required this.filter})
      : super(key: key);

  final List<T> initialList;
  final Widget Function(T) builder;
  final bool Function(T, String) filter;

  @override
  State<Search<T>> createState() => _SearchState<T>();
}

class _SearchState<T> extends State<Search<T>> {
  late List<T> _list;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _list = widget.initialList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: '搜尋',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _list = widget.initialList;
                  });
                  _searchController.clear();
                },
              ),
            ),
            onChanged: (str) {
              setState(() {
                _list = widget.initialList
                    .where((e) => widget.filter.call(e, str.toLowerCase()))
                    .toList();
              });
            },
          ),
        ),
        _list.isEmpty
            ? const Center(child: Text('沒有結果'))
            : Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                  // leave space for FAB
                  itemCount: _list.length,
                  itemBuilder: (context, i) => widget.builder.call(_list[i]),
                  separatorBuilder: (_, __) => const Divider(),
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
