import '../../../models/AuthModels/forgetPassword_model.dart';

abstract class ForgetPasswordStates {}

class ForgetPasswordInitialState extends ForgetPasswordStates {}

class ForgetPasswordLoadingState extends ForgetPasswordStates {}

class ForgetPasswordSuccessState extends ForgetPasswordStates {
  final forgetPasswordModel forgetpasswordModel;

  ForgetPasswordSuccessState(this.forgetpasswordModel);
}

class ForgetPasswordErrorState extends ForgetPasswordStates {
  final String error;

  ForgetPasswordErrorState(this.error);
}
