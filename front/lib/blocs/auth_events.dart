//lib/blocs/auth_events.dart
import 'package:equatable/equatable.dart';

class AuthEvents extends Equatable{
  @override
  List<Object?> get props => [];
}

class StartEvent extends AuthEvents{}

class LoginButtonPressed extends AuthEvents{
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});
   @override
  List<Object?> get props => [email, password];
}


class SignUpButtonPressed extends AuthEvents {
  final String name;
  final String email;
  final String password;
  final int type;
  
  SignUpButtonPressed(
      {required this.name,
      required this.email,
      required this.password,
      required this.type});

  @override
  List<Object?> get props => [name, email, password, type];
}

