
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
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
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

Widget cardSingleText(String text){
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
    ),
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text, style: TextStyle(fontSize: 20),),
          Icon(Icons.arrow_forward_ios, size: 15,)
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