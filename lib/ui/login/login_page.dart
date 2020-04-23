import 'package:flutter/material.dart';
import 'package:minhasreceitas/ext/Constants.dart';
import 'package:minhasreceitas/ext/MyColor.dart';
import 'package:minhasreceitas/ui/login/login_presenter.dart';
import 'package:minhasreceitas/utils/alerts.dart';
import 'package:minhasreceitas/utils/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements LoginContract {

  final TextEditingController _loginController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _refreshing = false;
  LoginPresenter _presenter;



  _LoginState(){
    _presenter = LoginPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          _body(),
          _refreshing ? circleProgress(): spaceVert(0)
        ],
      ),
    );
  }

  _body(){
    return Container(
      color: MyColor.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            spaceVert(20),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Image.asset("assets/images/logo.png"),
            ),
            spaceVert(40),
            textField("Usuário", _loginController, Icons.perm_identity),
            spaceVert(10),
            textField("Senha", _passController, Icons.lock),
            spaceVert(10),
            buttonWhiteTextPrimary('Entrar', _login)
          ],
        ),
      ),
    );
  }

  _login(){
    if(_loginController.text.isEmpty || _passController.text.isEmpty){
      alertOk(context, "Erro", "Usuário e/ou Senha em branco");
    }else{
      _presenter.login(_loginController.text, _passController.text);
      setState(() {
        _refreshing = true;
      });
    }
  }

  @override
  incorrectLogin() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Alerta", "Email inválido.");
  }

  @override
  incorrectPassword() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Alerta", "Senha inválida.");
  }

  @override
  loginFailed() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Acesso negado", "Por favor verifique o usuário e a senha.");
  }

  @override
  loginSuccess() {
    setState(() {
      _refreshing = false;
    });
    Navigator.of(context).pushReplacementNamed(Constants.RECIPE_PAGE);
  }

  @override
  serverError() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Alerta", "Erro ao tentar comunicação com o servidor.");
  }
}
