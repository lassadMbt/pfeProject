//lib/blocs/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/blocs/auth_events.dart';
import 'package:front/blocs/auth_state.dart';
import 'package:front/repository/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthBloc extends Bloc<AuthEvents, AuthState>{
  
  AuthRepository repo;
  AuthBloc(AuthState initialState, this.repo) : super(initialState);

  
  Stream<AuthState> mapEventToState(AuthEvents event) async*{
    var pref = await SharedPreferences.getInstance();
    if (event is StartEvent) {
      yield LoginInitState();
    }else if (event is LoginButtonPressed) {
      yield LoginLoadingState();
      var data = await repo.login(event.email, event.password);
      if (data['type'] == 0) {
        pref.setString("token", data['token']);
        pref.setInt("type", data['type']);
        pref.setString("email", data['email']);
        yield UserLoginSuccessState();
        
      }else if (data['type'] == 1) {
        pref.setString("token", data['token']);
        pref.setInt("type", data['type']);
        pref.setString("email", data['email']);
        yield AdminLoginSuccessState();
        
      }else {
        yield LoginErrorState(message: 'auth error');
      }
    }
    else if (event is SignUpButtonPressed) {
      yield SignUpLoadingState();
      var data = await repo.signUp(
          event.name, event.email, event.password, event.type);
      if (data['type'] == 0) {
        pref.setString("token", data['token']);
        pref.setInt("type", data['type']);
        pref.setString("email", data['email']);
        yield UserLoginSuccessState();
      } else if (data['type'] == 1) {
        pref.setString("token", data['token']);
        pref.setInt("type", data['type']);
        pref.setString("email", data['email']);
        yield AdminLoginSuccessState();
      } else {
        yield LoginErrorState(message: 'auth error');
      }
    }
  }
}

