
import 'package:minhasreceitas/data/api/NotificationApi.dart';
import 'package:minhasreceitas/data/api/RecipeApi.dart';
import 'package:minhasreceitas/model/Notification.dart';
import 'package:minhasreceitas/model/Recipe.dart';

abstract class RecipeDetailContract {
  returnRecipe(Recipe recipe);
  onError();
  updateSuccess();
  updateFailed();
  deleteSuccess();
  deleteFailed();
  sharedRecipeSuccess();
  sharedRecipeFailed();
}

class RecipeDetailPresenter {
  RecipeDetailContract _view;
  RecipeApi api = new RecipeApi();
  NotificationApi notificationApi = new NotificationApi();

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

  updateRecipe(Recipe recipe)async{
    try{
      await api.updateRecipe(recipe, recipe.id).whenComplete((){
        _view.updateSuccess();
      });
    }
    catch(e){
      _view.updateFailed();
    }
  }

  deleteRecipe(Recipe recipe)async{
    try{
      await api.removeRecipe(recipe).whenComplete((){
        _view.deleteSuccess();
      });
    }
    catch(e){
      _view.deleteFailed();
    }
  }

  shareRecipe(MyNotification notification) async{
      try{
        await notificationApi.addNotification(notification).whenComplete((){
          _view.sharedRecipeSuccess();
        });
      }
      catch(e){
        _view.sharedRecipeFailed();
      }
  }
}