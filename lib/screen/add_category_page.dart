import 'dart:convert';
import 'dart:io';

import 'package:admin_app_flutter/controller/custom_http_request.dart';
import 'package:admin_app_flutter/controller/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../widget/custom_widget.dart';
import 'package:http/http.dart' as http;

class AddCategoryPage extends StatefulWidget {
  AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController categoryController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? icon, image;

  getIcon() async {
    final pickImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickImage != null) {
      icon = File(pickImage.path);
      setState(() {});
    }
  }

  getImage() async {
    final pickImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickImage != null) {
      image = File(pickImage.path);
      setState(() {});
    }
  }

  var isLoading = false;

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: .5,
      progressIndicator: spinkit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Add Category",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: categoryController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please categroy name";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Category Name",
                    hintText: "Enter Category name",
                    hintStyle: mystyle(15),
                    labelStyle: mystyle(15),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.orange, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.orange, width: 2)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.orange, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 11,
                ),
                const Text(
                  "Add Icon",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 11,
                ),
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey,
                  child: icon == null
                      ? InkWell(
                          onTap: () {
                            getIcon();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.photo,
                                color: Colors.white,
                                size: 80,
                              ),
                              Text(
                                "Upload Icon",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : Image.file(
                          File(icon!.path),
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Add Image",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 11,
                ),
                Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey,
                  child: image == null
                      ? InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.photo,
                                color: Colors.white,
                                size: 80,
                              ),
                              Text(
                                "Upload Image",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : Image.file(File(image!.path),fit: BoxFit.cover,),
                ),
                SizedBox(
                  height: 16,
                ),
                MaterialButton(
                  color: Colors.orange.withOpacity(.9),
                  height: 50,
                  minWidth: 320,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    // var uploadCategory = Provider.of<CategoryProvider>(context).uploadCategory(categoryController.text.toString(), icon!.path, image!.path);
                    // if(uploadCategory == true){
                    //   Navigator.of(context).pop();
                    // }
                    uploadCategory();
                  },
                  child: Text("Add Category"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //todo: multipart request
  uploadCategory()async{

    try{

      setState(() {
        isLoading = true;
      });

      String url = "${baseUrl}category/store";
      var request = http.MultipartRequest("POST",Uri.parse(url)); //provide api url for post request
      request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());//pass header
      request.fields["name"] = categoryController.text.toString();//provide text data in field

      if(icon != null){ //provide image data in field
        var icn = await http.MultipartFile.fromPath("icon",icon!.path);
        request.files.add(icn);
      }

      if(image != null){ //provide image data in field
        var img = await http.MultipartFile.fromPath("image",image!.path);
        request.files.add(img);
      }

      var response = await request.send(); //finally send everything to api

      setState(() {
        isLoading = false;
      });

      if(response.statusCode == 201){
        showToastMessage("Category added successful");
        // Provider.of<CategoryProvider>(context,listen: false).getCategory(); //todo: its can be called from back page where i pushed just add .then and call get category
        Navigator.of(context).pop();
      }else{
        showToastMessage("Category not added, something went wrong");
      }

      //normally we can print response directly but in multipart request response comes as a byte
      //for that the response we have to take byte then it has to be convert in string

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = jsonDecode(responseString);

      print("Response: $data");
    }catch(e){
      setState(() {
        isLoading = false;
      });
      print(e);
    }

  }
}
