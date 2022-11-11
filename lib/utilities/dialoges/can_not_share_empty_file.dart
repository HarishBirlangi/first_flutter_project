import 'package:flutter/cupertino.dart';
import 'package:homefinder/utilities/dialoges/generic_dialoge.dart';

Future<void> canNotShareEmptyFileDialouge(BuildContext context) async {
  return showGenericDialoge<void>(
    context: context,
    title: 'Sharing',
    content: 'You can not share a empty notes',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
