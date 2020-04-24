import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhasreceitas/data/firebase/ApiFirebase.dart';
import 'package:minhasreceitas/ext/Constants.dart';
import 'package:minhasreceitas/model/Notification.dart';
import 'package:minhasreceitas/model/Recipe.dart';

class NotificationApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase(Constants.NOTIFICATIONS);
  List<MyNotification> notifications;

  Future<List<MyNotification>> getNotifications() async {
    var result = await _api.getDataCollectionEmail();
    notifications = result.documents
        .map((doc) => MyNotification.fromMap(doc.data, doc.documentID))
        .toList();
    return notifications;
  }

  Stream<QuerySnapshot> getNotificationsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Recipe> getNotificationById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Recipe.fromMap(doc.data, doc.documentID) ;
  }


  Future removeNotification(MyNotification data) async{
    await _api.removeDocument(data.id);

    return ;
  }

  Future addNotification(MyNotification data) async{
    var result  = await _api.addDocument(data.toJson());
    return result;

  }

}