import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/school_teacher.dart';

class TeachersState extends Cubit<List<SchoolTeacher>?> {
  TeachersState(super.initialState);

  void setTeachers(List<SchoolTeacher>? teachers) {
    emit(teachers);
  }
}
