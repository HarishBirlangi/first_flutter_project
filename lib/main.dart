import 'package:flutter/material.dart';
import 'package:homefinder/services/auth/auth_service.dart';
import 'package:homefinder/views/login_view.dart';
import 'package:homefinder/views/main_view.dart';
import 'package:homefinder/views/verify_email_view.dart';
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
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        RegisterView.routeName: (context) => const RegisterView(),
        LoginView.routeName: (context) => const LoginView(),
        MainView.routeName: (context) => const MainView(),
        VerifyEmail.routeName: (context) => const VerifyEmail(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().intialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MainView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
