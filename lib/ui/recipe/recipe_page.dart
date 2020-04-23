import 'package:flutter/material.dart';
import 'package:minhasreceitas/ext/Constants.dart';
import 'package:minhasreceitas/model/Recipe.dart';
import 'package:minhasreceitas/ui/recipe/recipe_presenter.dart';
import 'package:minhasreceitas/utils/ApplicationSingleton.dart';
import 'package:minhasreceitas/utils/Destination.dart';
import 'package:minhasreceitas/utils/alerts.dart';
import 'package:minhasreceitas/utils/widgets.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> implements RecipeContract{
  var _currentIndex = 0;
  List<Recipe> recipes = List<Recipe>();
  bool _refreshing = true;
  RecipePresenter _presenter;

  _RecipePageState(){
    _presenter = RecipePresenter(this);
  }

  @override
  void initState() {
    _presenter.getRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receitas"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  ApplicationSingleton.baseAuth.signOut();
                  Navigator.of(context).pushReplacementNamed(Constants.LOGIN_PAGE);
                },
                child: Icon(
                    Icons.exit_to_app
                ),
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          Navigator.of(context).pushNamed(Constants.RECIPE_REGISTER).whenComplete((){
            _presenter.getRecipes();
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon, color: destination.color,),
              title: Text(destination.title, style: TextStyle(color: destination.color),)
          );
        }).toList(),
      ),
      body: _body()
    );
  }

  _body(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          textFieldSearch(_search),
          spaceVert(10),
          Expanded(
              child: Stack(
                children: <Widget>[
                  _list(),
                  _refreshing ? circleProgress() : spaceVert(0)
                ],
              )
          )
        ],
      ),
    );
  }

  _search(String text){

  }

  _list(){
    return recipes.isNotEmpty ?
    ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index){
        return GestureDetector(
          child: cardSingleText(recipes[index].name),
          onTap: (){
            _openRecipeDetail(recipes[index]);
          },
        );
      },
    ) : emptyState();
  }

  _openRecipeDetail(Recipe recipe){
    ApplicationSingleton.recipe = recipe;
    Navigator.of(context).pushNamed(Constants.RECIPE_DETAIL);
  }

  @override
  listIsEmpty() {
    setState(() {
      _refreshing = false;
      recipes = new List<Recipe>();
    });

  }

  @override
  onError() {
    alertOk(context, "Erro", "Algo de errado aconteceu. Tente novamente.");
  }

  @override
  returnList(List<Recipe> list) {
   setState(() {
     _refreshing = false;
     recipes = list;
   });
  }
}
