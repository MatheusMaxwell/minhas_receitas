
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhasreceitas/data/api/RecipeApi.dart';
import 'package:minhasreceitas/model/Recipe.dart';

abstract class RecipeRegisterContract{
  insertSuccess();
  insertFailed();
}

class RecipeRegisterPresenter{

  RecipeRegisterContract _view;
  RecipeApi api = new RecipeApi();

  RecipeRegisterPresenter(this._view);

  insertRecipe(Recipe recipe)async{
    try{
      DocumentReference insert = await api.addRecipe(recipe);
      if(insert.documentID.isNotEmpty)
        _view.insertSuccess();
      else
        _view.insertFailed();
    }
    catch(e){
      var i = e.toString();
      _view.insertFailed();
    }
  }
}