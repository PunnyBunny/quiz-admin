import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/src/core/utils.dart';
import 'package:quiz_admin/src/login/login_page.dart';
import 'package:quiz_admin/src/school/school_page.dart';
import 'package:quiz_admin/src/slp/slp_page.dart';

import 'core/bloc/authentication_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: const Text('控制面板'),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    if (await showLogoutDialog(context)) {
                      if (context.mounted) {
                        context
                            .read<AuthenticationBloc>()
                            .add(LogoutRequested());
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                        await FirebaseAuth.instance.signOut();
                      }
                    }
                  },
                ),
              )),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SchoolPage(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(10),
                    ),
                    child: Text(
                      "學校",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: context.read<AuthenticationBloc>().state ==
                            AuthenticationState.authenticatedAdmin
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SlpPage(),
                              ),
                            );
                          }
                        : null,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(10),
                    ),
                    child: Text(
                      "言語治療師",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
