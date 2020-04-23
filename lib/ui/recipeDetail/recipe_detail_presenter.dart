
import 'package:minhasreceitas/data/api/RecipeApi.dart';
import 'package:minhasreceitas/model/Recipe.dart';

abstract class RecipeDetailContract {
  returnRecipe(Recipe recipe);
  onError();
}

class RecipeDetailPresenter {
  RecipeDetailContract _view;
  RecipeApi api = new RecipeApi();

  RecipeDetailPresenter(this._view);

  getRecipeById(String id)async{
    try{
      Recipe recipe = await api.getRecipeById(id);
      if(recipe != null){
        _view.returnRecipe(recipe);
      }
    }
    catch(e){
      _view.onError();
    }
  }
}