import 'package:minhasreceitas/utils/ApplicationSingleton.dart';

abstract class LoginContract{
  loginSuccess();
  loginFailed();
  incorrectLogin();
  incorrectPassword();
  serverError();
}

class LoginPresenter{
  LoginContract view;
  var baseAuth = ApplicationSingleton.baseAuth;
  LoginPresenter(this.view);

  login(String email, String password) async{
    try{
      var userId = await baseAuth.signIn(email, password);
      if(userId.length > 0 && userId != null){
        ApplicationSingleton.currentUser = await baseAuth.getCurrentUser();
        view.loginSuccess();
      }
      else{
        view.loginFailed();
      }
    }
    catch(e){
      if(e.toString().toUpperCase().contains("PASSWORD"))
        view.incorrectPassword();
      else if(e.toString().toUpperCase().contains("EMAIL"))
        view.incorrectLogin();
      else
        view.serverError();
    }
  }

  loginGoogle()async{
    try{
      var userId = await baseAuth.signInWithGoogle();
      if(userId.length > 0 && userId != null){
        ApplicationSingleton.currentUser = await baseAuth.getCurrentUser();
        view.loginSuccess();
      }
      else{
        view.loginFailed();
      }
    }
    catch(e){
        view.serverError();
    }
  }
}