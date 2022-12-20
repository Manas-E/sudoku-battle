import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_battle/pages/GoogleSignInProvider.dart';

class loginRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(32),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          FlutterLogo(size: 120),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hey There,\nWelcome Back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Login to your account to continue',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              minimumSize: Size(double.infinity, 50)
            ),
            icon: FaIcon(FontAwesomeIcons.google),
            label: Text('Sign Up with Google'),
            onPressed: () {
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();

            },
          ),
          SizedBox(height: 40),
          RichText(
            text: TextSpan(
              text: 'Already have an account?',
              children: [
                TextSpan(
                  text: 'Log in',
                  style: TextStyle(decoration: TextDecoration.underline)
                ),
              ],
            ),
          ),
        ],
      )
  );
}