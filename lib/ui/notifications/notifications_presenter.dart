import 'package:minhasreceitas/data/api/NotificationApi.dart';
import 'package:minhasreceitas/data/api/RecipeApi.dart';
import 'package:minhasreceitas/model/Notification.dart';
import 'package:minhasreceitas/model/Recipe.dart';

abstract class NotificationsContract{
  returnNotifications(List<MyNotification> list);
  notificationsIsEmpty();
  onError();
  deleteNotificationSuccess(bool isRefuse);
  returnRecipe(Recipe recipe, MyNotification notification);
  acceptFailed();
  updateRecipeSuccess(MyNotification notification);
}

class NotificationsPresenter {

  NotificationApi api = new NotificationApi();
  RecipeApi apiRecipe = new RecipeApi();

  NotificationsContract _view;

  NotificationsPresenter(this._view);

  getNotifications()async{
    try{
      List<MyNotification> nots = await api.getNotifications();
      if(nots.isNotEmpty){
        _view.returnNotifications(nots);
      }
      else{
        _view.notificationsIsEmpty();
      }
    }
    catch(e){
      _view.onError();
    }
  }

  deleteNotification(MyNotification notification, bool isRefuse)async{
    try{
      await api.removeNotification(notification).whenComplete((){
        _view.deleteNotificationSuccess(isRefuse);
      });
    }
    catch(e){
      _view.onError();
    }
  }

  getRecipeById(String id, MyNotification notification)async{
    try{
      Recipe recipe = await apiRecipe.getRecipeById(id);
      if(recipe != null){
        _view.returnRecipe(recipe, notification);
      }
      else{
        _view.acceptFailed();
      }
    }
    catch(e){
      _view.acceptFailed();
    }
  }

  updateRecipe(Recipe recipe, MyNotification notification)async{
    try{
      await apiRecipe.updateRecipe(recipe, recipe.id).whenComplete((){
        _view.updateRecipeSuccess(notification);
      });
    }
    catch(e){
      _view.acceptFailed();
    }
  }

}