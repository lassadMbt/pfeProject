// lib/ui/LoginUi.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/login/login_event.dart';
import 'package:tataguid/blocs/login/login_state.dart';
import 'package:tataguid/components/my_button.dart';
import 'package:tataguid/components/my_textfield.dart';
import 'package:tataguid/components/square_tile.dart';
import 'package:tataguid/ui/SignUpUi.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late LoginBloc authBloc;
  String errorMessage = '';

  @override
  void initState() {
    authBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _loginButtonPressed() {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  if (email.isEmpty || password.isEmpty) {
    setState(() {
      errorMessage = 'Please enter email and password.';
    });
  } else {
    authBloc.add(LoginButtonPressed(email: email, password: password));
  }
}

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is UserLoginSuccessState) {
      if (state.type == 'user') {
        Navigator.pushNamed(context, '/user_dashboard');
      }
    } else if (state is AgencyLoginSuccessState) {
      Navigator.pushNamed(context, '/agency_panel');
    } else if (state is LoginErrorState) {
      // Handle error state
    } else if (state is NavigateToUserDashboard) {
      Navigator.pushNamed(context, '/user_dashboard');
    } else if (state is NavigateToAgencyPanel) {
      Navigator.pushNamed(context, '/agency_panel');
    }
  },
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              const Center(
                child: Icon(Icons.supervised_user_circle,
                    size: 150, color: Colors.blue),
              ),
              const SizedBox(height: 20.0),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 48.0),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: Icons.email,
                obscureText: false,
                onChanged: _clearErrorMessage,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
                onChanged: _clearErrorMessage,
              ),
              const SizedBox(height: 48.0),
              MyButton(
                onPressed: _loginButtonPressed,
                text: 'Log In',
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    imagePath: 'assets/images/google.png',
                  ),
                  const SizedBox(width: 25),
                  SquareTile(
                    imagePath: 'assets/images/apple.png',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Register now',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
