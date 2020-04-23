import 'package:flutter/material.dart';
import 'package:minhasreceitas/model/Recipe.dart';
import 'package:minhasreceitas/utils/ApplicationSingleton.dart';
import 'package:minhasreceitas/utils/widgets.dart';

class RecipeDetail extends StatefulWidget {
  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  Recipe recipe;
  bool _isUpdate = false;
  final TextEditingController prepModController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  List<String> ingredients = List<String>();

  @override
  void initState() {
    recipe = ApplicationSingleton.recipe;
    ingredients = recipe.ingredients;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receita"),
        centerTitle: true,
        actions: <Widget>[
          _isUpdate ? _iconSave() : _iconEdit(),
          _isUpdate ? _iconCancel() : spaceHorizon(0)
        ],
      ),

      body: _body(),
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
          onTap: (){},
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

  _cancel(){
    setState(() {
      _isUpdate = false;
    });
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
      child: ListView(
        children: <Widget>[
          _isUpdate ? myTextField("Nome", nameController) : _recipeName(),
          spaceVert(40),
          _title(" INGREDIENTES"),
          spaceVert(5),
          _listIngredients(),
          spaceVert(40),
          _title(" MODO DE PREPARO"),
          spaceVert(5),
          _preparationMode()
        ],
      ),
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
                              onPressed: (){},
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
    String ingredient;
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
              child: Text('Adicionar'),
              onPressed: () {
                if(ingredients == null){
                  ingredients = new List<String>();
                }
                setState(() {
                  ingredients.add(ingredient);
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
}