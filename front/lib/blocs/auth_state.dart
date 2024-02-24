//lib/blocs/auth_state.dart
import 'package:equatable/equatable.dart';

class AuthState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}


class LoginInitState extends AuthState{}


class LoginLoadingState extends AuthState{}


class UserLoginSuccessState extends AuthState{}
class AdminLoginSuccessState extends AuthState{}

class LoginErrorState extends AuthState{
  final String message;
  LoginErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

// New states for signup
class SignUpLoadingState extends AuthState {}

class UserSignUpSuccessState extends AuthState {}
class AdminSignUpSuccessState extends AuthState {}

class SignUpErrorState extends AuthState {
  final String message;
  SignUpErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}