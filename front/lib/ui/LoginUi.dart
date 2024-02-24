// lib/ui/LoginUi.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/blocs/auth_bloc.dart';
import 'package:front/blocs/auth_events.dart';
import 'package:front/blocs/auth_state.dart';
import 'package:front/ui/SignUpUi.dart';

class LoginUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _UserLoginState(),
    );
  }
}

class _UserLoginState extends StatefulWidget {
  @override
  __UserLoginState createState() => __UserLoginState();
}

class __UserLoginState extends State<_UserLoginState> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const logo = Center(
      child: Icon(Icons.supervised_user_circle, size: 150, color: Colors.blue),
    );

    final msg = BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoginErrorState) {
          return Text(state.message);
        } else if (state is LoginLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
    final username = TextField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'Email',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final pass = TextField(
      controller: password,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'Password',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          primary: Colors.lightBlueAccent,
        ),
        onPressed: () {
          authBloc.add(LoginButtonPressed(email: email.text, password: password.text));
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );
     // Add this part for the sign-up link
    final signUpLink = Padding(
      padding: const EdgeInsets.fromLTRB(65, 20, 0, 0),
      child: Row(
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()), // Navigate to SignUpPage
              );
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserLoginSuccessState) {
            Navigator.pushNamed(context, '/contacts');
          } else if (state is AdminLoginSuccessState) {
            Navigator.pushNamed(context, '/AddContacts');
          }
        },
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              const SizedBox(height: 20.0),
              msg,
              const SizedBox(height: 48.0),
              username,
              const SizedBox(height: 20.0),
              pass,
              const SizedBox(height: 48.0),
              loginButton,
              signUpLink, // Add the sign-up link here
            ],
          ),
        ),
      ),
    );
  }
}

