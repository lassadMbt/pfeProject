// lib/ui/SignUpUi.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/signup/signup_bloc.dart';
import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';
import 'package:flutter/material.dart' show ScaffoldMessenger; // Use 'material.dart'
import 'package:provider/provider.dart';
import 'package:tataguid/components/my_textfield.dart';
import 'package:tataguid/repository/auth_repo.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:tataguid/ui/LoginUi.dart';
import 'package:tataguid/ui/signup_option.dart';
import 'package:tataguid/widgets/BuildTextfield.dart';

import 'get_contacts.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController agencyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  // final TextEditingController typeController = TextEditingController();
  // final TextEditingController languageController = TextEditingController();
  // final TextEditingController countryController = TextEditingController();
  // final TextEditingController locationController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // For SnackBar

  String errorMessage = '';

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final AuthRepository authRepository = Provider.of<AuthRepository>(context, listen: false); // Access the repository
    final SignupBloc signupBloc = BlocProvider.of<SignupBloc>(context);

    const logo = Center(
      child: Icon(Icons.supervised_user_circle, size: 150, color: Colors.blue),
    );


    // BuildTextFormField and other widgets omitted for brevity

    final email = BuildTextFormField(
      'Email',
      emailController,
          (value) {
        // Email validation logic
        return null;
      },
      TextInputType.emailAddress,
      Icons.email,
    );

    final pass = BuildTextFormField(
      'Password',
      passwordController,
          (value) {
        // Password validation logic
        return null;
      },
      TextInputType.visiblePassword,
      Icons.lock,
    );

    final confirmpass = BuildTextFormField(
      'Confirm password',
      confirmpassController,
          (value) {
        // Password validation logic
        return null;
      },
      TextInputType.visiblePassword,
      Icons.lock,

    );

    final signUpButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
        onPressed: () {
          // String name = nameController.text.trim(); //for user
          // String agencyName = agencyNameController.text.trim(); //for user
           String email = emailController.text.trim(); //for bothe user/agency
           String password = passwordController.text.trim(); //for bothe user/agency
          // String type = typeController.text.trim();
          // String language = languageController.text.trim(); //for user
          // String country = countryController.text.trim(); //for user
          // String location = locationController.text.trim(); //for agency
          // String description = descriptionController.text.trim(); //for agency

String confirmPassword = confirmpassController.text.trim();
          if (password != confirmPassword) {
            _showErrorSnackBar('Passwords do not match.');
          } else {
            // Perform signup logic
            signupBloc.add(EmailPassValidation(email: email, password: password));
          }        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    final alreadyHave = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginUi(),
              ),
            );
          },
          child: Text(
            'Log In',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
           if (state is SignupErrorState) {
            _showErrorSnackBar(state.message);
          } else if (state is UserSignupSuccessState || state is AgencySignupSuccessState) {
            _handleSuccessfulSignup(state);
          }
        },
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: size.width*0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo,
                const SizedBox(height: 20),
                email,
                const SizedBox(height: 20),
                pass,
                const SizedBox(height: 20),
                confirmpass,
                const SizedBox(height: 20),
                signUpButton,
                const SizedBox(height: 40),
                alreadyHave,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bool _validateUserInput( String email, String pass, String confirmpass) {
  //   if (email.isEmpty || pass.isEmpty == confirmpass.isEmpty) {
  //     return false;
  //   }
  //   return true;
  // }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleSuccessfulSignup(SignupState state) {
    Provider.of<AuthRepository>(context, listen: false).getToken().then((token) {
      if (token != null) {
        _storeToken(token);
        // Navigate to appropriate screen based on signup success
        if (state is UserSignupSuccessState) {
          Navigator.pushNamed(context, '/user_dashboard');
        } else if (state is AgencySignupSuccessState) {
          Navigator.pushNamed(context, '/Agency_panel');
        }
      } else {
        _showErrorSnackBar('Failed to retrieve token.');
      }
    }).catchError((error) {
      _showErrorSnackBar('Error retrieving token: $error');
    });
  }

  void _storeToken(String token) async {
    await TokenStorage.storeToken(token);
  }
}