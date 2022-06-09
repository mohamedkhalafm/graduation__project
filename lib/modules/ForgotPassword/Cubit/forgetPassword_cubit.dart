import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/modules/ForgotPassword/Cubit/forgetPasswsord_states.dart';
import 'package:graduation_project/network/Remote%20network/end_points.dart';

import '../../../models/AuthModels/forgetPassword_model.dart';
import '../../../network/Remote network/dio_helper.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit() : super(ForgetPasswordInitialState());

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);

  late forgetPasswordModel forgetpasswordModel;

  void userForgetpassword({
    // ignore: non_constant_identifier_names
    required String email,
  }) {
    emit(ForgetPasswordLoadingState());

    DioHelper.postData(
      path: FORGOTPASSWORD,
      data: {
        'email': email,
      },
    ).then((value) {
      // ignore: avoid_print
      print(value.data);

      forgetpasswordModel = forgetPasswordModel.fromJson(value.data);

      emit(ForgetPasswordSuccessState(forgetpasswordModel));
    }).catchError((error) {
      // ignore: avoid_print
      print(error.toString());
      emit(ForgetPasswordErrorState(error));
    });
  }
}
