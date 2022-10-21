import 'package:flutter/material.dart';
import 'package:homefinder/services/auth/auth_service.dart';
import 'package:homefinder/views/login_view.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});
  static const routeName = '/verifyEmail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('Verify your email to continue'),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send email verifcation'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginView.routeName, (route) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
