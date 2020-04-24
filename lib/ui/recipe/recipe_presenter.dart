
import 'package:minhasreceitas/data/api/NotificationApi.dart';
import 'package:minhasreceitas/data/api/RecipeApi.dart';
import 'package:minhasreceitas/model/Notification.dart';
import 'package:minhasreceitas/model/Recipe.dart';

abstract class RecipeContract {
  listIsEmpty();
  returnList(List<Recipe> list);
  onError();
  returnNotifications(List<MyNotification> list);
}

class RecipePresenter {
  RecipeContract _view;
  RecipePresenter(this._view);
  RecipeApi api = new RecipeApi();
  NotificationApi apiNotifications = new NotificationApi();

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

  getRecipesShared() async{
    try{
      List<Recipe> list = await api.getRecipesShared();
      if(list == null || list.isEmpty){
        _view.listIsEmpty();
      }
      else{
        _view.returnList(list);
      }
    }
    catch(e){
      _view.onError();
    }
  }

  getNotifications()async{
    try{
      List<MyNotification> list = await apiNotifications.getNotifications();
      if(list != null){
        _view.returnNotifications(list);
      }
    }
    catch(e){
      print(e);
    }
  }
}