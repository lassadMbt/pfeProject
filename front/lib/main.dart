// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/blocs/auth_bloc.dart';
import 'package:front/blocs/auth_state.dart';
import 'package:front/repository/auth_repo.dart';
import 'package:front/ui/LoginUi.dart';
import 'package:front/ui/get_contacts.dart';
import 'package:front/ui/post_contacts.dart';

void main() => runApp(Auth());

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(LoginInitState(), AuthRepository()),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes : {
          '/' : (context) => LoginUi(),
          '/contacts' : (context) => Contact(),
          '/AddContacts' : (context) => AddContacts(),
        },
      ),
    );
  }
}
