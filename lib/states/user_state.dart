import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';

class UserState extends Cubit<User?> {
  UserState(super.initialState);

  void setUser(User? user) {
    emit(user);
  }
}
