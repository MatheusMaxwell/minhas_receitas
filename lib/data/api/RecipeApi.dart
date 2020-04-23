import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhasreceitas/data/firebase/ApiFirebase.dart';
import 'package:minhasreceitas/ext/Constants.dart';
import 'package:minhasreceitas/model/Recipe.dart';

class RecipeApi extends ChangeNotifier {
  ApiFirebase _api = new ApiFirebase(Constants.RECIPES);
  List<Recipe> recipes;

  Future<List<Recipe>> getRecipes() async {
    var result = await _api.getDataCollection();
    recipes = result.documents
        .map((doc) => Recipe.fromMap(doc.data))
        .toList();
    return recipes;
  }

  Stream<QuerySnapshot> getRecipesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Recipe> getRecipeById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Recipe.fromMap(doc.data) ;
  }


  Future removeRecipe(Recipe data) async{
    await _api.removeDocument(data.id);

    return ;
  }
  Future updateRecipe(Recipe data,String id) async{
    await _api.updateDocument(data.toJson(), id);
    return ;
  }

  Future addRecipe(Recipe data) async{
    var result  = await _api.addDocument(data.toJson());
    return result;

  }

}