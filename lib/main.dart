import 'package:flutter/material.dart';
import 'package:homefinder/views/login_view.dart';
import 'package:homefinder/views/main_view.dart';
import 'views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
      routes: {
        RegisterView.routeName: (context) => const RegisterView(),
        LoginView.routeName: (context) => const LoginView(),
        MainView.routeName: (context) => const MainView(),
      },
    );
  }
}
