import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:minhasreceitas/ext/Constants.dart';
import 'package:minhasreceitas/ext/MyColor.dart';
import 'package:minhasreceitas/model/Notification.dart';
import 'package:minhasreceitas/model/Recipe.dart';
import 'package:minhasreceitas/ui/recipe/recipe_presenter.dart';
import 'package:minhasreceitas/utils/ApplicationSingleton.dart';
import 'package:minhasreceitas/utils/Destination.dart';
import 'package:minhasreceitas/utils/HexColor.dart';
import 'package:minhasreceitas/utils/alerts.dart';
import 'package:minhasreceitas/utils/widgets.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> with TickerProviderStateMixin implements RecipeContract {
  var _currentIndex = 0;
  List<Recipe> recipes = List<Recipe>();
  bool _refreshing = true;
  RecipePresenter _presenter;
  bool existsNotifications = false;
  AnimationController _animationController;

  _RecipePageState(){
    _presenter = RecipePresenter(this);
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _presenter.getRecipes();
    _presenter.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receitas"),
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(Constants.NOTIFICATIONS_PAGE).whenComplete((){
              _getRecipes();
            });
          },
          child: existsNotifications ? _iconExistsNotification() : Icon(Icons.notifications_none,),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10.0),
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
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          Navigator.of(context).pushNamed(Constants.RECIPE_REGISTER).whenComplete((){
            _presenter.getRecipes();
          });
        },
      ):null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(Constants.primaryColor),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _getRecipes();
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

  _iconExistsNotification(){
    return RotationTransition(
        turns: Tween(begin: 0.0, end: -.1)
            .chain(CurveTween(curve: Curves.elasticIn))
            .animate(_animationController),
        child: Icon(Icons.notifications_active)
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
          child: cardSingleText(recipes[index].name, recipes[index].imageUrl),
          onTap: (){
            _openRecipeDetail(recipes[index]);
          },
        );
      },
    ) : emptyState();
  }

  void _runAnimationIconNotification() async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  _openRecipeDetail(Recipe recipe){
    ApplicationSingleton.recipeId = recipe.id;
    Navigator.of(context).pushNamed(Constants.RECIPE_DETAIL).whenComplete((){
      _getRecipes();
    });
  }

  _getRecipes(){
    setState(() {
      _refreshing = true;
    });
    if(_currentIndex == 0){
      _presenter.getRecipes();
    }
    else{
      _presenter.getRecipesShared();
    }
    _presenter.getNotifications();
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
    setState(() {
      _refreshing = false;
    });
    alertOk(context, "Erro", "Algo de errado aconteceu. Tente novamente.");
  }

  @override
  returnList(List<Recipe> list) {
   setState(() {
     _refreshing = false;
     recipes = list;
   });
  }

  @override
  returnNotifications(List<MyNotification> list) {
    setState(() {
      if(list.isNotEmpty) {
        existsNotifications = true;
        _runAnimationIconNotification();
      }
      else{
        existsNotifications = false;
      }
    });
  }

}
