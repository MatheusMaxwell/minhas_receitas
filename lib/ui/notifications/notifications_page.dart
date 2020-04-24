import 'package:flutter/material.dart';
import 'package:minhasreceitas/model/Notification.dart';
import 'package:minhasreceitas/model/Recipe.dart';
import 'package:minhasreceitas/ui/notifications/notifications_presenter.dart';
import 'package:minhasreceitas/utils/alerts.dart';
import 'package:minhasreceitas/utils/widgets.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> implements NotificationsContract{

  List<MyNotification> myNotifications = List<MyNotification>();
  NotificationsPresenter _presenter;
  bool _refreshing = true;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _animationController;

  _NotificationsPageState(){
    _presenter = new NotificationsPresenter(this);
  }

  @override
  void initState() {
    _presenter.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Notificações"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          myNotifications.isEmpty ? emptyStateNotifications() : _list(),
          _refreshing ? circleProgress() : spaceVert(0)
        ],
      ),
    );
  }

  _list(){
    return ListView.builder(
      itemCount: myNotifications.length,
      itemBuilder: (BuildContext context, int index){
        return _cardNotification(index);
      },
    );
  }

  _cardNotification(int index){
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _textCard(myNotifications[index].userSender),
            spaceVert(10),
            Row(
              children: <Widget>[
                imageNetworkCard(myNotifications[index].recipeImageUrl),
                spaceHorizon(20),
                Text(myNotifications[index].recipeName, style: TextStyle(color: Colors.grey, fontSize: 16),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(icon: Icon(Icons.cancel, color: Colors.red,size: 40,),
                  onPressed: (){
                  setState(() {
                    _refreshing = true;
                  });
                    _presenter.deleteNotification(myNotifications[index], true);
                  },
                ),
                IconButton(icon: Icon(Icons.check_circle, color: Colors.green,size: 40,),
                  onPressed: (){
                    setState(() {
                      _refreshing = true;
                    });
                    _presenter.getRecipeById(myNotifications[index].recipeId, myNotifications[index]);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _textCard(String senderName){
    return RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          new TextSpan(text: senderName, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          new TextSpan(text: " quer compartilhar \numa receita com você. Deseja aceitar?", style: TextStyle(color: Colors.black, fontSize: 16),),
        ],
      ),
    );
  }

  @override
  notificationsIsEmpty() {
    setState(() {
      _refreshing = false;
      myNotifications = new List<MyNotification>();
    });
  }

  @override
  onError() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Erro", "Algo deu errado ao tentar acessar as notificações. Tente novamente.");
  }

  @override
  returnNotifications(List<MyNotification> list) {
    setState(() {
      _refreshing = false;
      myNotifications = list;
    });
  }

  @override
  deleteNotificationSuccess(bool isRefuse) {
    setState(() {
      _refreshing = true;
    });
    if(isRefuse){
      showSnackBar("Pedido de compartilhamento recusado.", scaffoldKey);
    }
    _presenter.getNotifications();
  }

  @override
  acceptFailed() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Erro", "Não foi possível concluir isso agora. Tente novamente mais tarde.");
  }

  @override
  returnRecipe(Recipe recipe, MyNotification notification) {
    recipe.sharedEmails.add(notification.userDestinationEmail);
    _presenter.updateRecipe(recipe, notification);
  }

  @override
  updateRecipeSuccess(MyNotification notification) {
    alertOk(context, "Receita compartilhada", notification.recipeName+" agora está sendo compartilhado com você.");
    _presenter.deleteNotification(notification, false);
  }
}
