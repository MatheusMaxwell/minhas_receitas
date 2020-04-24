
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:minhasreceitas/ext/MyColor.dart';

Widget spaceVert(double space){
  return SizedBox(
    height: space,
  );
}

Widget spaceHorizon(double space){
  return SizedBox(
    width: space,
  );
}

circleProgress(){
  return Container(
    color: Colors.white30,
    child: Center(
      child: CircularProgressIndicator(backgroundColor: Colors.white70,),
    ),
  );
}

buttonWhiteTextPrimary(String text, Function onPressed){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      RaisedButton(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(text, style: TextStyle(color: MyColor.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
        ),
      ),
    ],
  );
}

buttonPrimaryTextWhite(String text, Function onPressed){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      RaisedButton(
        color: MyColor.primaryColor,
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
        ),
      ),
    ],
  );
}

textField(String hint, TextEditingController controller, IconData prefixIcon){
  return Theme(
    data: ThemeData(
      primaryColor: Colors.white,
    ),
    child: TextField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      obscureText: hint == 'Senha' ? true: false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(15.0)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(15.0)
        ),
        prefixIcon: Icon(prefixIcon, color: Colors.white,),
      ),
    ),
  );
}

Widget cardSingleText(String text, String imageUrl){
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
    ),
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          imageNetworkCard(imageUrl),
          spaceHorizon(10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(text, style: TextStyle(fontSize: 20),),
                Icon(Icons.arrow_forward_ios, size: 15,)
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget textFieldSearch(Function search){
  return TextField(
      textInputAction: TextInputAction.done,
      onChanged: search,
      decoration: InputDecoration(
        hintText: "Busca",
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.search),
      )
  );
}

Widget myTextField(String hint, TextEditingController controller){
  return Card(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
            ),
          )
      ),
    ),
  );
}

Widget emptyState(){
  return Center(
    child: Container(
      height: 400,
      width: 400,
      child: Column(
        children: <Widget>[
          spaceVert(100),
          Icon(Icons.list, size: 200, color: Colors.grey,),
          spaceVert(10),
          Text("Nenhuma receita encontrada", style: TextStyle(fontSize: 24, color: Colors.grey),)
        ],
      ),
    ),
  );
}

Widget emptyStateNotifications(){
  return Center(
    child: Container(
      height: 400,
      width: 400,
      child: Column(
        children: <Widget>[
          spaceVert(100),
          Icon(Icons.notifications_off, size: 200, color: Colors.grey,),
          spaceVert(10),
          Text("Nenhuma nova notificação", style: TextStyle(fontSize: 24, color: Colors.grey),)
        ],
      ),
    ),
  );
}


Widget signInButtonEmail (Function onPressed){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      RaisedButton(
        color: Colors.grey,
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0)
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.email, color: Colors.white,),
              spaceHorizon(30),
              Text('Login com o email', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget signInButtonGoogle (Function onPressed){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      RaisedButton(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0)
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Image.asset('assets/images/google_logo.png', height: 30, width: 30,),
              spaceHorizon(30),
              Text('Login com o Google', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget imageNetwork (String url){
  if(url == null){
    url = "";
  }
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      height: 220,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
        ),
      ),
    ),
    placeholder: (context, url) => Container(height: 220,child: Center(child: CircularProgressIndicator())),
    errorWidget: (context, url, error) => Image.asset("assets/images/emptyimage.jpg"),
  );
}

Widget imageNetworkCard (String url){
  if(url == null){
    url = "";
  }
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
        ),
      ),
    ),
    placeholder: (context, url) => Container(height: 10, width: 10,child: Center(child: CircularProgressIndicator())),
    errorWidget: (context, url, error) => ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        "assets/images/emptyimage.jpg",
        height: 60,
        width: 60,
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget imageRegister (String image, BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image.asset(
      image,
      height: 220,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    ),
  );
}