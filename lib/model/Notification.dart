
class MyNotification{
  String _id;
  String _userSender;
  String _recipeId;
  String _recipeName;
  String _recipeImageUrl;
  String _userDestinationEmail;

  MyNotification();
  //MyNotification(this._id, this._recipeId, this._recipeName, this._userSender, this._userDestinationEmail);

  MyNotification.fromMap(dynamic obj, String id){
    this._id = id;
    this._recipeId = obj["recipeId"];
    this._recipeName = obj["recipeName"];
    this._userSender = obj["userSender"];
    this._recipeImageUrl = obj["recipeImageUrl"];
    this._userDestinationEmail = obj["userDestinationEmail"];
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["recipeId"] = _recipeId;
    map["recipeName"] = _recipeName;
    map["userSender"] = _userSender;
    map["recipeImageUrl"] = _recipeImageUrl;
    map["userDestinationEmail"] = _userDestinationEmail;
    return map;
  }

  toJson() {
    return {
      "recipeId": _recipeId,
      "recipeName": _recipeName,
     "userSender": _userSender,
      "recipeImageUrl": _recipeImageUrl,
      "userDestinationEmail": _userDestinationEmail
    };
  }


  String get recipeImageUrl => _recipeImageUrl;

  set recipeImageUrl(String value) {
    _recipeImageUrl = value;
  }

  String get userDestinationEmail => _userDestinationEmail;

  set userDestinationEmail(String value) {
    _userDestinationEmail = value;
  }

  String get userSender => _userSender;

  set userSender(String value) {
    _userSender = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get recipeName => _recipeName;

  set recipeName(String value) {
    _recipeName = value;
  }

  String get recipeId => _recipeId;

  set recipeId(String value) {
    _recipeId = value;
  }


}