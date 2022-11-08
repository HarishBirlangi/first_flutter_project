import 'package:flutter/cupertino.dart';
import 'package:homefinder/utilities/dialoges/generic_dialoge.dart';

Future<bool> showLogoutDialouge(BuildContext context) {
  return showGenericDialoge(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to logout?',
    optionBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
