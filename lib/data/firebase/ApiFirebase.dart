
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhasreceitas/utils/ApplicationSingleton.dart';

class ApiFirebase{
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;
  String userId = ApplicationSingleton.currentUser.uid;
  String userEmail = ApplicationSingleton.currentUser.email;
  final  DURATIONREQ = 5;
  final DURATION = 10;

  ApiFirebase( this.path ) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection(){
    return ref.where("userId", isEqualTo: userId).getDocuments().timeout(Duration(seconds: DURATIONREQ));
  }

  Future<QuerySnapshot> getDataCollectionEmail(){
    return ref.where("userDestinationEmail", isEqualTo: userEmail).getDocuments().timeout(Duration(seconds: DURATIONREQ));
  }

  Future<QuerySnapshot> getDataCollectionShared(){
    return ref.where("sharedEmails", arrayContains: userEmail).getDocuments().timeout(Duration(seconds: DURATIONREQ));
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.where("userId", isEqualTo: userId).snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get().timeout(Duration(seconds: DURATION));
  }
  Future<void> removeDocument(String id){
    return ref.document(id).delete().timeout(Duration(seconds: DURATION));
  }
  Future<DocumentReference> addDocument(Map data) {
    data["userId"] = userId;
    return ref.add(data).timeout(Duration(seconds: DURATION));
  }

  Future<void> addFieldDocument(String kitId, Map data){
    return ref.document(kitId).updateData(data).timeout(Duration(seconds: DURATION));
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.document(id).updateData(data).timeout(Duration(seconds: DURATION));
  }

}