import 'dart:io';
import 'dart:math';

import 'package:admin_app_flutter/controller/custom_http_request.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {},
                child: Text("Add Category"),
              )
            ],
          ),
        ),
      ),
    );
  }

  uploadCategory()async{
    String url = "${baseUrl}category/store";

    var request = http.MultipartRequest("POST",Uri.parse(url)); //provide api url for post request
    request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());//pass header
    request.fields["name"] = categoryController.text.toString();//provide text data in field

    if(icon != null){ //provide image data in field
      var icn = await http.MultipartFile.fromPath("icon",icon!.path);
      request.files.add(icn);
    }

    if(image != null){ //provide image data in field
      var img = await http.MultipartFile.fromPath("icon",image!.path);
      request.files.add(img);
    }

    var response = await request.send(); //finally send everything to api

    //normally we can print response directly but in multipart request response comes as a byte
    //for that the response we have to take byte then it has to be convert in string

    var responseData = await response.stream.toBytes();
  }

}
