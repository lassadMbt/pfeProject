// lib/blocs/signup/signup_bloc.dart

import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';
import '../../repository/auth_repo.dart';
import 'package:bloc/bloc.dart';

class SignupBloc extends Bloc<SignupEvents, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository})
      :  super(LogoutState()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<EmailPassValidation>(_onEmailPassValidation); // Add handler for EmailPassValidation

  }
void _onEmailPassValidation(
    EmailPassValidation event,
    Emitter<SignupState> emit,
  ) async {
    // Handle email and password validation logic here if needed
    // For example:
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(SignupErrorState('Email and password are required.'));
    } else {
      // You can add more validation logic as needed
      // For now, emit a success state for email and password validation
      emit(SignupSuccessState());
    }
  }
void _onRegisterButtonPressed(
  RegisterButtonPressed event,
  Emitter<SignupState> emit,
) async {
  emit(SignupLoadingState()); // Emit loading state before API call

  try {
    // Validate user input here (e.g., email format, password strength)

    var data = await authRepository.signUp(
      event.name,
      event.agencyName,
      event.email,
      event.password,
      event.type,
      event.language,
      event.country,
      event.location,
      event.description,
    );

     // Use a switch statement for type-safe handling:
      switch (event.type) {
        case 'agency': // Updated to match the type string
          emit(UserSignupSuccessState());
          break; // Handle successful user signup
        case 'user': // Updated to match the type string
          emit(AgencySignupSuccessState());
          break; // Handle successful agency signup
        default:
          emit(SignupErrorState('Invalid user type: ${event.type}'));
          break; // Handle invalid type case
      }
  } catch (error) {
    emit(SignupErrorState(error.toString())); // Emit error state with message
  }
}
}