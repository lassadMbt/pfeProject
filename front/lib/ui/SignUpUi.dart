// lib/ui/SignUpUi.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/blocs/auth_bloc.dart';
import 'package:front/blocs/auth_events.dart';
import 'package:front/blocs/auth_state.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    
    const logo = Center(
      child: Icon(Icons.supervised_user_circle, size: 150, color: Colors.blue),
    );
    final username = TextField(
      controller: nameController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle_rounded),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'Name',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final email = TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'Email',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))),
    );
    final pass = TextField(
      controller: passwordController,
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
    final signUpButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ), backgroundColor: Colors.lightBlueAccent,
        ),
        onPressed: () {
          String name = nameController.text;
          String email = emailController.text;
          String password = passwordController.text;
          int type = 0; // For user signup

          // Dispatch signup event with the collected data
          authBloc.add(SignUpButtonPressed(
            name: name,
            email: email,
            password: password,
            type: type,
          ));
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo,
            const SizedBox(height: 20),
            username,
            const SizedBox(height: 20),
            email,
            const SizedBox(height: 20),
            pass,
            const SizedBox(height: 20),
            signUpButton,
          ],
        ),
      ),
    );
  }
}

