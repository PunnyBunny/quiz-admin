import 'package:flutter/material.dart';
import 'package:quiz_admin/src/core/types.dart';
import 'package:quiz_admin/src/slp/slp_edit_page.dart';

import '../core/utils.dart';

class SlpTile extends StatelessWidget {
  final Slp slp;
  final void Function(Slp) onSave;
  final void Function() onDelete;

  const SlpTile(
      {Key? key,
      required this.slp,
      required this.onSave,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Text('${slp.name} '),
                Text(slp.gender.chineseName,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    slp.email,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ],
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
                        builder: (_) => SlpEditPage(
                          initialSlp: slp,
                          title: "修改言語治療師",
                          onSave: (school) => onSave.call(school),
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
