
class Recipe {
  String _id;
  String _name;
  List<String> _tags;
  List<String> _ingredients;
  String _preparationMode;
  String _sharedIds;
  String _userId;

  Recipe();
  //Recipe(this._id, this._name, this._tags, this._ingredients, this._preparationMode, this._sharedIds, this._userId);

  Recipe.fromMap(dynamic obj, String id){
    this._id = id;
    this._name = obj["name"];
    this._tags = obj["tags"];
    this._ingredients = getIngredients(obj["ingredients"]);
    this._preparationMode = obj["preparationMode"];
    this._sharedIds = obj["sharedIds"];
    this._userId = obj["userId"];
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["tags"] = _tags;
    map["ingredients"] = _ingredients;
    map["preparationMode"] = _preparationMode;
    map["sharedIds"] = _sharedIds;
    map["userId"] = _userId;
    return map;
  }

  toJson() {
    return {
      "name": _name,
      "tags": _tags,
      "ingredients": _ingredients,
      "preparationMode": _preparationMode,
      "sharedIds": _sharedIds,
      "userId": _userId
    };

  }

  static List<String> getIngredients(List<dynamic> map) {

    List<String> list = List<String>();

    for( int i=0; i < map.length; i++ ) {

      list.add(map[i].toString());

    }

    return list;

  }


  String get sharedIds => _sharedIds;

  set sharedIds(String value) {
    _sharedIds = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get preparationMode => _preparationMode;

  set preparationMode(String value) {
    _preparationMode = value;
  }

  List<String> get ingredients => _ingredients;

  set ingredients(List<String> value) {
    _ingredients = value;
  }

  List<String> get tags => _tags;

  set tags(List<String> value) {
    _tags = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

//  set id(String value) {
//    _id = value;
//  }




}