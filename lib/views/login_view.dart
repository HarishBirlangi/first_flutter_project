import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:homefinder/utilities/show_alert_dialog.dart';
import 'package:homefinder/views/main_view.dart';
import 'package:homefinder/views/register_view.dart';
import 'package:homefinder/views/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static const routeName = '/loginview';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 230,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              TextField(
                controller: _emailid,
                decoration:
                    const InputDecoration(hintText: 'Enter your email id'),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
              ),
              TextField(
                controller: _password,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
              TextButton(
                onPressed: () async {
                  final email = _emailid.text;
                  final password = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);
                    final user = FirebaseAuth.instance.currentUser;
                    if (user?.emailVerified ?? false) {
                      SchedulerBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        Navigator.of(context).pushNamed(MainView.routeName);
                      });
                    } else {
                      SchedulerBinding.instance
                          .addPostFrameCallback((timeStamp) {
                        Navigator.of(context).pushNamed(VerifyEmail.routeName);
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showAlertDialog(context, 'user-not-found');
                    } else if (e.code == 'wrong-password') {
                      showAlertDialog(context, 'wrong-password');
                    } else {
                      showAlertDialog(context, 'Error: ${e.code}');
                    }
                  } catch (e) {
                    showAlertDialog(context, e.toString());
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, RegisterView.routeName);
                },
                child: const Text('Create new account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
