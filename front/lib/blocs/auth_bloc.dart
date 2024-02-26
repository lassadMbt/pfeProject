//lib/blocs/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/blocs/auth_events.dart';
import 'package:front/blocs/auth_state.dart';
import 'package:front/repository/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthRepository repo;

  AuthBloc(AuthState initialState, this.repo) : super(initialState);

@override
  Stream<AuthState> mapEventToState(AuthEvents event) async* {
    var pref = await SharedPreferences.getInstance();
    try {
      if (event is StartEvent) {
        yield LoginInitState();
      } else if (event is LoginButtonPressed) {
        yield LoginLoadingState();
        var data = await repo.login(event.email, event.password);
        if (data.containsKey('type')) {
          pref.setString("token", data['token'] ?? '');
          pref.setInt("type", data['type'] ?? 0);
          pref.setString("email", data['email'] ?? '');
          if (data['type'] == 0) {
            yield UserLoginSuccessState();
          } else if (data['type'] == 1) {
            yield AdminLoginSuccessState();
          } else {
            yield LoginErrorState(message: 'Authentication error');
          }
        } else {
          yield LoginErrorState(message: 'Authentication error');
        }
      } else if (event is SignUpButtonPressed) {
        yield SignUpLoadingState();
        var data = await repo.signUp(
          event.name,
          event.email,
          event.password,
          event.type,
        );
        if (data.containsKey('type')) {
          pref.setString("token", data['token'] ?? '');
          pref.setInt("type", data['type'] ?? 0);
          pref.setString("email", data['email'] ?? '');
          if (data['type'] == 0) {
            yield UserSignUpSuccessState();
          } else if (data['type'] == 1) {
            yield AdminSignUpSuccessState();
          } else {
            yield SignUpErrorState(message: 'Authentication error');
          }
        } else {
          yield SignUpErrorState(message: 'Authentication error');
        }
      }
    } catch (error) {
      yield LoginErrorState(message: 'An error occurred: $error');
    }
  }
}