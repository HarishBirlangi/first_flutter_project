import 'package:flutter/material.dart';
import 'package:homefinder/enum/menu_action.dart';
import 'package:homefinder/services/auth/auth_service.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  static const routeName = '/mainView';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main View'), actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialouge(context);
                if (shouldLogout) {
                  AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/loginview", (_) => false);
                }
                break;
              default:
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: MenuAction.logout,
                child: Text('Logout'),
              ),
            ];
          },
        )
      ]),
      body: const Text('Content'),
    );
  }

  Future<bool> showLogoutDialouge(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Logout from account'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out')),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
