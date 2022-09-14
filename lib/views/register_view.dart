import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homefinder/firebase_options.dart';
import 'package:homefinder/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);
  static const routeName = '/register';
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailid;
  late final TextEditingController _password;

  @override
  void initState() {
    _emailid = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailid.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _emailid,
                      decoration: const InputDecoration(
                          hintText: 'Enter your email id'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                    TextField(
                      controller: _password,
                      decoration: const InputDecoration(
                          hintText: 'Enter your password'),
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _emailid.text;
                        final password = _password.text;
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            const AlertDialog(
                              title: Text('weak-password'),
                            );
                            print("weak-password");
                          } else if (e.code == 'email-already-in-use') {
                            const AlertDialog(
                              title: Text('email-already-in-use'),
                            );
                            print("email-already-in-use");
                          } else {
                            print("Something wrong");
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LoginView.routeName);
                      },
                      child: const Text('Login Page'),
                    ),
                  ],
                );
              default:
                return const Text('Loading ...');
            }
          }),
    );
  }
}
