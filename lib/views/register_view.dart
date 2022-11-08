import 'package:flutter/material.dart';
import 'package:homefinder/services/auth/auth_exceptions.dart';
import 'package:homefinder/services/auth/auth_service.dart';
import 'package:homefinder/utilities/dialoges/error_dialog.dart';
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
      body: Column(
        children: [
          TextField(
            controller: _emailid,
            decoration: const InputDecoration(hintText: 'Enter your email id'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your password'),
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _emailid.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
              } on WeakPassword {
                await showErrorDialog(context: context, title: 'Weak Password');
              } on EmailAlredyExists {
                await showErrorDialog(
                    context: context, title: 'Email alredy in use');
              } on InvalidEmail {
                await showErrorDialog(context: context, title: 'Invalid email');
              } on GenericAuthException {
                await showErrorDialog(
                    context: context, title: 'Fialed to register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginView.routeName);
            },
            child: const Text('Login Page'),
          ),
        ],
      ),
    );
  }
}
