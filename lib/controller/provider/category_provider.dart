

import 'package:admin_app_flutter/controller/custom_http_request.dart';
import 'package:flutter/foundation.dart';

import '../../model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categoryList = [];

  // List<CategoryModel> get getCategoryList => categoryList;

  getCategory() async {
    categoryList = await CustomHttpRequest.fetchCategoryData();
    notifyListeners();
  }

}