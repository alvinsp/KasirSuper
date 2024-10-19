part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {}

class GetImageProfileEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}

class SubmitProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const SubmitProfileEvent({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props =>
      [name, email, phoneNumber, password, confirmPassword];
}

class LoginEvent extends ProfileEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
