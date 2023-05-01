import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/category_model.dart';
import '../widget/custom_widget.dart';
import 'package:http/http.dart' as http;



class CustomHttpRequest{
  static Future<Map<String,String>> getHeaderWithToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var header = {
      'Accept' : 'application/json',
      'Authorization' : 'Bearer ${sharedPreferences.getString('token')}'
    };
    return header;
  }

  static Future<dynamic> fetchCategoryData() async{
    List<CategoryModel> categoryList = [];
    CategoryModel? categoryModel;

    try{
      String url = "${baseUrl}category";
      var response = await http.get(Uri.parse(url),headers: await CustomHttpRequest.getHeaderWithToken());
      var data = jsonDecode(response.body);

      print(response.statusCode);
      if(response.statusCode == 200){
        for(var i in data){
          categoryModel = CategoryModel.fromJson(i);
          categoryList.add(categoryModel!);
        }
        // print(data);
      }
    }catch(e){
      print(e);
    }

    return categoryList;
  }

}
