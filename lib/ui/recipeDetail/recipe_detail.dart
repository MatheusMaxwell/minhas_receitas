import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minhasreceitas/model/Notification.dart';
import 'package:minhasreceitas/model/Recipe.dart';
import 'package:minhasreceitas/ui/recipeDetail/recipe_detail_presenter.dart';
import 'package:minhasreceitas/utils/ApplicationSingleton.dart';
import 'package:minhasreceitas/utils/alerts.dart';
import 'package:minhasreceitas/utils/widgets.dart';

class RecipeDetail extends StatefulWidget {
  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> implements RecipeDetailContract{
  Recipe recipe = new Recipe();
  bool _isUpdate = false;
  final TextEditingController prepModController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  RecipeDetailPresenter _presenter;
  bool _refreshing = true;
  String sharedEmail;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String localImage = "";
  File imageFile;

  _RecipeDetailState(){
    _presenter = RecipeDetailPresenter(this);
  }

  @override
  void initState() {
    _initEmptyRecipe();
    _presenter.getRecipeById(ApplicationSingleton.recipeId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Receita"),
        centerTitle: true,
        actions: <Widget>[
          _recipeSharedToMe() ?  spaceVert(0) : _isUpdate ? _iconSave() : _iconEdit(),
          _recipeSharedToMe() ?  spaceVert(0) : _isUpdate ? _iconCancel() : _iconDelete()
        ],
      ),
      floatingActionButton: _recipeSharedToMe() ? null : FloatingActionButton(
        child: Icon(Icons.share, color: Colors.white,),
        onPressed: _shareRecipe,
      ),

      body: _body(),
    );
  }

  _initEmptyRecipe(){
    recipe.name = "";
    recipe.ingredients = List<String>();
    recipe.preparationMode = "";
    recipe.sharedEmails = List<String>();
    recipe.userId = "";
  }

  _iconDelete(){
    return Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: _delete,
          child: Icon(
            Icons.delete, color: Colors.white,
          ),
        )
    );
  }

  _iconEdit(){
    return Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: _edit,
          child: Icon(
            Icons.edit, color: Colors.white,
          ),
        )
    );
  }

  _iconSave(){
    return Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: _save,
          child: Icon(
            Icons.save, color: Colors.white,
          ),
        )
    );
  }

  _iconCancel(){
    return Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: _cancel,
          child: Icon(
            Icons.close, color: Colors.white,
          ),
        )
    );
  }

  _save()async{
    setState(() {
      _refreshing = true;
    });
    if(imageFile != null){
      if(recipe.imageUrl != null && recipe.imageUrl.isNotEmpty){
        await deleteImage(recipe.imageUrl);
      }
      recipe.imageUrl = await uploadPicFirebase();
    }
    recipe.name = nameController.text;
    recipe.preparationMode = prepModController.text;
    _presenter.updateRecipe(recipe);
  }

  _delete()async{
    bool response = await alertYesOrNo(context, "Deletar receita", "Deseja realmente deletar?");
    if(response){
      setState(() {
        _refreshing = true;
      });
      _presenter.deleteRecipe(recipe);
    }
  }

  _cancel(){
    setState(() {
      _isUpdate = false;
      _refreshing = true;
      localImage = "";
    });
    _presenter.getRecipeById(recipe.id);

  }

  _edit(){
    setState(() {
      _isUpdate = true;
    });
  }

  _body() {
    nameController.text = recipe.name;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              _isUpdate ? myTextField("Nome", nameController) : _recipeName(),
              spaceVert(20),
              GestureDetector(
                child: localImage.isNotEmpty ? imageRegister(localImage, context) : imageNetwork(recipe.imageUrl),
                onTap: ()async{
                  if(_isUpdate){
                    imageFile = await uploadLocalPic();
                    setState(() {
                      localImage = imageFile.path;
                    });
                  }
                },
              ),
              spaceVert(40),
              _title(" INGREDIENTES"),
              spaceVert(5),
              _listIngredients(),
              spaceVert(40),
              _title(" MODO DE PREPARO"),
              spaceVert(5),
              _preparationMode(),
              spaceVert(40),
            ],
          ),
          _refreshing ? circleProgress() : spaceHorizon(0)
        ],

      ),
    );
  }

  deleteImage(String url)async{
    StorageReference reference = await _storage.getReferenceFromUrl(url);
    await reference.delete();
  }

  Future<File> uploadLocalPic() async{
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    return file;
  }

  Future<String> uploadPicFirebase() async {
    if(imageFile != null){
      String date = DateTime.now().toString();
      StorageReference reference = _storage.ref().child("images/$date");
      StorageUploadTask uploadTask = reference.putFile(imageFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      return url;

    }
  }

  _recipeSharedToMe(){
    bool ret = false;
    if(recipe.sharedEmails != null){
      for(var r in recipe.sharedEmails){
        if(r.contains(ApplicationSingleton.currentUser.email)){
          ret = true;
        }
      }
    }

    return ret;
  }

  _shareRecipe()async{
    String email = await _dialogShareRecipe();
    if(email.isNotEmpty){
      MyNotification notification = new MyNotification();
      notification.recipeName = recipe.name;
      notification.recipeId = recipe.id;
      notification.userSender = ApplicationSingleton.currentUser.email;
      notification.userDestinationEmail = email;
      notification.recipeImageUrl = recipe.imageUrl;
      _presenter.shareRecipe(notification);
    }
  }

  Future<String> _dialogShareRecipe(){
    final TextEditingController controllerEmail = new TextEditingController();
    String email;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enviar receita"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: new InputDecoration(
                    hintText: 'Email'
                ),
                onChanged: (value) {
                  email = value;
                },
                controller: controllerEmail,
                autofocus: true,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ENVIAR'),
              onPressed: () {
                if(controllerEmail.text.isNotEmpty){
                  Navigator.of(context).pop(controllerEmail.text);
                }
                else{
                  alertOk(context, "Campo vazio", "Informe um email para enviar.");
                }
              },
            ),
            FlatButton(
              child: Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop("");
              },
            ),
          ],
        );
      },
    );
  }

  _recipeName(){
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(child: Text(recipe.name, style: TextStyle(fontSize: 26),)),
      ),
    );
  }

  _title(String text){
    return Text(text, style: TextStyle(fontSize: 20, color: Colors.grey),);
  }

  _preparationMode(){
    prepModController.text = recipe.preparationMode;
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          enabled: _isUpdate,
          controller: prepModController,
          keyboardType: TextInputType.multiline,
          minLines: 1,//Normal textInputField will be displayed
          maxLines: 50,// when user presses enter it will adapt to it
        ),
      ),
    );
  }

  _listIngredients(){
    return Card(
      color: Colors.white,
      child: Container(
        height: recipe.ingredients == null ? 50.0 : 100.0 + recipe.ingredients.length*40,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              _isUpdate ? Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.green,),
                    onPressed: (){
                      _dialogNewIngredient();
                    },
                  ),
                  Text("Adicionar Ingrediente", style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ) : spaceVert(0),
              Expanded(
                child: ListView.builder(
                  itemCount: recipe.ingredients == null? 0 : recipe.ingredients.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: (index != recipe.ingredients.length-1) ? BorderSide(width: 1.0, color: Colors.grey) : BorderSide(color: Colors.white),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("- "+recipe.ingredients[index], style: TextStyle(fontSize: 16),),
                            _isUpdate ? IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red,),
                              onPressed: (){
                                setState(() {
                                  recipe.ingredients.removeAt(index);
                                });
                              },
                            ) : spaceHorizon(0)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogNewIngredient(){
    final TextEditingController controllerIngredient = new TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Adicionar Ingrediente"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controllerIngredient,
                autofocus: true,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Adicionar'),
              onPressed: () {
                if(recipe.ingredients == null){
                  recipe.ingredients = new List<String>();
                }
                if(controllerIngredient.text.isNotEmpty){
                  setState(() {
                    recipe.ingredients.add(controllerIngredient.text);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  onError() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Alerta", "Algo deu errado, tente novamente.").whenComplete((){
      Navigator.of(context).pop();
    });
  }

  @override
  returnRecipe(Recipe recipe) {
    setState(() {
      _refreshing = false;
      this.recipe = recipe;
    });
  }

  @override
  deleteFailed() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Erro ao deletar", "Algo de errado aconteceu. Tente novamente.");
  }

  @override
  deleteSuccess() {
    setState(() {
      _refreshing = false;
    });
    showSnackBar("Receita deletada com sucesso!", scaffoldKey);
    Navigator.of(context).pop();
  }

  @override
  updateFailed() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Erro ao atualizar", "Algo de errado aconteceu. Tente novamente.");
  }

  @override
  updateSuccess() {
    setState(() {
      _isUpdate = false;
    });
    showSnackBar("Receita atualizada!", scaffoldKey);
    _presenter.getRecipeById(recipe.id);
  }

  @override
  sharedRecipeFailed() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Erro", "Ocorreu um erro ao tentar enviar a receita.");
  }

  @override
  sharedRecipeSuccess() {
    setState(() {
      _refreshing = false;
    });
    showSnackBar("Receita enviada!", scaffoldKey);
  }
}
