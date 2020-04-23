
import 'package:minhasreceitas/data/api/RecipeApi.dart';
import 'package:minhasreceitas/model/Recipe.dart';

abstract class RecipeContract {
  listIsEmpty();
  returnList(List<Recipe> list);
  onError();
}

class RecipePresenter {
  RecipeContract _view;
  RecipePresenter(this._view);
  RecipeApi api = new RecipeApi();

  getRecipes()async{
    try{
      List<Recipe> list = await api.getRecipes();
      if(list == null || list.isEmpty){
        _view.listIsEmpty();
      }
      else{
        _view.returnList(list);
      }
    }
    catch(e){
      var i = e.toString();
      _view.onError();
    }
  }
}