import 'package:flutter/material.dart';
import 'package:homefinder/utilities/dialoges/generic_dialoge.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
}) {
  return showGenericDialoge<void>(
    context: context,
    title: 'An error occured',
    content: title,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
