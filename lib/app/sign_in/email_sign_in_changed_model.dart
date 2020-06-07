
import 'package:first/app/sign_in/string_validator.dart';
import 'package:first/services/auth.dart';
import 'package:flutter/cupertino.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangedModel with EmailAndPasswordValidator, ChangeNotifier{
  EmailSignInChangedModel({
    @required this.auth,
    this.isLoading = false,
    this.email = '',
    this.formType = EmailSignInFormType.signIn,
    this.password = '',
    this.submitted = false,
  });
  final AuthBase auth;
  String  email;
  String password;
  EmailSignInFormType formType;
  bool submitted;
  bool isLoading;

  Future<void> submit() async {
    updateWith(
      submitted: true,
      isLoading: true,
    );
    try {
      if (this.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.createUserWithEmailAndPassword(this.email, this.password);
      }
    }catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText{
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }
  String get secondaryButtonText{
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }
  bool get canSubmit{
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }
  String get passwordErrorText{
    bool showPasswordErrorText =
        submitted && !passwordValidator.isValid(password);
return showPasswordErrorText? invalidPasswordErrorText: null;
  }
  String get showEmailErrorText{
    bool showErrorText =
        submitted && !emailValidator.isValid(email);
    return showErrorText? invalidEmailErrorText : null;
  }

  void toggleForm(){
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      submitted: false,
      isLoading: false,
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);


  void updateWith({
    String  email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
}){
      this.email= email ?? this.email;
      this.formType=  formType ?? this.formType;
      this.password= password ?? this.password;
      this.isLoading= isLoading ?? this.isLoading;
      this.submitted= submitted ?? this.submitted;
 notifyListeners();
 }
}