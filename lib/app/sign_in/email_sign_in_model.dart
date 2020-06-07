
import 'package:first/app/sign_in/string_validator.dart';

enum EmailSignInFormType { signIn, register }
class EmailSignInModel with EmailAndPasswordValidator{
  EmailSignInModel({
    this.isLoading = false,
    this.email = '',
    this.formType = EmailSignInFormType.signIn,
    this.password = '',
    this.submitted = false,
  });
  final String  email;
  final String password;
  final EmailSignInFormType formType;
  final bool submitted;
  final bool isLoading;

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
  EmailSignInModel copyWith({
    String  email,
    String password,
    EmailSignInFormType formType,
    bool submitted,
    bool isLoading,
}){
    return EmailSignInModel(
      email: email ?? this.email,
      formType:  formType ?? this.formType,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}