
import 'package:admin_app_flutter/controller/custom_http_request.dart';
import 'package:admin_app_flutter/controller/provider/category_provider.dart';
import 'package:admin_app_flutter/screen/add_category_page.dart';
import 'package:admin_app_flutter/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
class CategoryPage extends StatefulWidget {
  CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = false;

  fetchCategoryData(){
    isLoading = true;
    Provider.of<CategoryProvider>(context,listen: false).getCategory();
    isLoading = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<CategoryProvider>(context,listen: false).getCategory();
    fetchCategoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var category = Provider.of<CategoryProvider>(context); //everything in category provider stored in category variable
    return Scaffold(
      floatingActionButton:FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryPage(),)).then((value) => category.getCategory());
      },
      child: Icon(Icons.add),
      ),
      body: Consumer<CategoryProvider>(builder: (context, value, child) {
        return SafeArea(
            child: value.categoryList.isNotEmpty? ListView.builder(
              itemCount: value.categoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey,
                    // color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                    image: NetworkImage("${imgUrl}${value.categoryList[index].image}",),
                                    fit: BoxFit.cover
                                )
                            ),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage("${imgUrl}${value.categoryList[index].icon}"),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("${value.categoryList[index].name}",style: mystyle(20.0),)
                        ],
                      ),
                    ),
                  ),
                );
                return Image.network("${imgUrl}${value.categoryList[index].image}");
              },):ModalProgressHUD(inAsyncCall: isLoading, child: spinkit)
        );
      },)
    );
  }
}
