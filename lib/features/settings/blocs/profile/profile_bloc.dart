import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/settings/settings.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.initial()) {
    on<GetProfileEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: Status.loading));

        final service = await ProfileService.get();

        emit(state.copyWith(
          status: Status.apply,
          user: service,
          image: service?.image,
        ));
      } catch (e) {
        emit(state.copyWith(status: Status.failure, error: e.toString()));
      }
    });

    on<SubmitProfileEvent>((event, emit) async {
      try {

        // validasi field ada yang kosong
        if (event.name.isEmpty ||
            event.email.isEmpty ||
            event.phoneNumber.isEmpty ||
            event.password.isEmpty) {
          emit(state.copyWith(
              status: Status.failure, error: "Field tidak boleh kosong"));
          return;
        }

        // Validasi format email
        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$").hasMatch(event.email)) {
          emit(state.copyWith(
              status: Status.failure, error: "Format email harus @gmail.com"));
          return;
        }

        // Validasi password
        if (!isPasswordValid(event.password)) {
          emit(state.copyWith(
              status: Status.failure,
              error:
                  "Password harus minimal 8 karakter dan mengandung kombinasi huruf besar, huruf kecil, angka, dan simbol"));
          return;
        }

        // validasi password = konfirmasi password
        if (event.password != event.confirmPassword) {
          emit(state.copyWith(
              status: Status.failure,
              error: "Password dan konfirmasi password harus sama"));
          return;
        }

        // validasi email terdaftar
        final users = await ProfileService.getAllUsers();
        if (users.any((user) => user.email == event.email)) {
          emit(state.copyWith(
              status: Status.failure, error: "Email sudah terdaftar"));
          return;
        }

        emit(state.copyWith(status: Status.loading));

        final newUser = UserModel(
            name: event.name,
            email: event.email,
            phoneNumber: event.phoneNumber,
            image: state.image ?? '',
            password: event.password,
            confirmPassword: event.confirmPassword);

        await ProfileService.insert(newUser);
        emit(state.copyWith(status: Status.success, user: newUser));
      } catch (e) {
        emit(state.copyWith(status: Status.failure, error: e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      try {
        if (event.email.isEmpty || event.password.isEmpty) {
          emit(state.copyWith(
              status: Status.failure, error: "Field tidak boleh kosong"));
          return;
        }

        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$").hasMatch(event.email)) {
          emit(state.copyWith(
              status: Status.failure, error: "Format email harus @gmail.com"));
          return;
        }

        emit(state.copyWith(status: Status.loading));

        final user = await ProfileService.login(event.email, event.password);
        if (user == null) {
          emit(state.copyWith(
              status: Status.failure,
              error: "Email atau password tidak valid"));
          return;
        }

        emit(state.copyWith(status: Status.success, user: user));
      } catch (e) {
        emit(state.copyWith(status: Status.failure, error: e.toString()));
      }
    });

    on<GetImageProfileEvent>((event, emit) async {
      try {
        final picker = await ImageHelper.getImage();

        emit(state.copyWith(image: picker));
      } catch (e) {
        emit(state.copyWith(status: Status.failure, error: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await ProfileService.logout(); // Panggil method logout
        emit(ProfileState.initial()); // Reset state ke awal
      } catch (e) {
        emit(state.copyWith(status: Status.failure, error: e.toString()));
      }
    });

  }
}

bool isPasswordValid(String password) {
  final regex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+=-]).{8,}$');
  return regex.hasMatch(password);
}
