import 'package:flutter/material.dart';
import 'package:homefinder/utilities/dialoges/generic_dialoge.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialoge(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want delete the note',
    optionBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
