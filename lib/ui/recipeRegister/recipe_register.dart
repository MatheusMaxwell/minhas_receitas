import 'package:flutter/material.dart';
import 'package:minhasreceitas/model/Recipe.dart';
import 'package:minhasreceitas/ui/recipeRegister/recipe_register_presenter.dart';
import 'package:minhasreceitas/utils/alerts.dart';
import 'package:minhasreceitas/utils/widgets.dart';

class RecipeRegister extends StatefulWidget {
  @override
  _RecipeRegisterState createState() => _RecipeRegisterState();
}

class _RecipeRegisterState extends State<RecipeRegister> implements RecipeRegisterContract {
  Recipe recipe = new Recipe();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController prepModController = new TextEditingController();
  RecipeRegisterPresenter _presenter;
  bool _refreshing = false;

  _RecipeRegisterState(){
    _presenter = RecipeRegisterPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Receita"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _save,
                child: Icon(
                    Icons.save, color: Colors.white,
                ),
              )
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              myTextField("Nome", nameController),
              spaceVert(40),
              _title(" INGREDIENTES"),
              spaceVert(3),
              _listIngredients(),
              spaceVert(40),
              _title(" MODO DE PREPARO"),
              spaceVert(3),
              _preparationMode(),
            ],
          ),
          _refreshing ? circleProgress() : spaceVert(0)
        ],
      ),
    );
  }

  _save()async{
    if(nameController.text.isEmpty){
      alertOk(context, "Alerta", "Insira um nome");
    }
    else{
      setState(() {
        _refreshing = true;
      });
      recipe.name = nameController.text;
      recipe.preparationMode = prepModController.text;
      await _presenter.insertRecipe(recipe);
    }

  }
  
  _title(String text){
    return Text(text, style: TextStyle(fontSize: 20, color: Colors.grey),);
  }

  _listIngredients(){
    return Card(
      color: Colors.white,
      child: Container(
        height: recipe.ingredients == null ? 50.0 : 100.0 + recipe.ingredients.length*20,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.green,),
                    onPressed: (){
                      _dialogNewIngredient();
                    },
                  ),
                  Text("Adicionar Ingrediente", style: TextStyle(fontSize: 16, color: Colors.grey),)
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: recipe.ingredients == null? 0 : recipe.ingredients.length,
                    itemBuilder: (BuildContext context, int index){
                      return Text("- "+recipe.ingredients[index], style: TextStyle(fontSize: 16),);
                    },
                  ),
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
    String ingredient;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Novo Ingrediente"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  ingredient = value;
                },
                controller: controllerIngredient,
                autofocus: true,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Inserir'),
              onPressed: () {
                if(recipe.ingredients == null){
                  recipe.ingredients = new List<String>();
                }
                setState(() {
                  recipe.ingredients.add(ingredient);
                });
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

  _preparationMode(){
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: prepModController,
          keyboardType: TextInputType.multiline,
          minLines: 1,//Normal textInputField will be displayed
          maxLines: 50,// when user presses enter it will adapt to it
        ),
      ),
    );
  }

  @override
  insertFailed() {
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Erro", "Ocorreu um erro ao tentar inserir, tente novamente.");
  }

  @override
  insertSuccess() {
    setState(() {
      _refreshing = false;
    });
    Navigator.of(context).pop();
  }
}
