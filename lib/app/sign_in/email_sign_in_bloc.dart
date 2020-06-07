
import 'dart:async';

import 'package:first/app/sign_in/email_sign_in_model.dart';
import 'package:first/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class EmailSignInBloc{
  final AuthBase auth;
  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());
  EmailSignInBloc({@required this.auth});
  Observable<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get _model => _modelSubject.value;
  void dispose(){
    _modelSubject.close();
  }

  Future<void> submit() async {
    updateWith(
        submitted: true,
        isLoading: true,
    );
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    }catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleForm(){
    final formType =_model.formType == EmailSignInFormType.signIn
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
}) async{
 _modelSubject.value = _model.copyWith(
   email: email,
   password: password,
   formType: formType,
   isLoading: isLoading,
   submitted: submitted,
 );
}
}