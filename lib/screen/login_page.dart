import 'dart:convert';

import 'package:admin_app_flutter/screen/nav_bar/nav_bar_page.dart';
import 'package:admin_app_flutter/widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey =  GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      progressIndicator: spinkit,

      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome",style: mystyle(25,Colors.orange,FontWeight.w600),),
                SizedBox(height: 40,),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Please Enter Email";
                    }
                    if(!value.contains("@")){
                      return "Invalid Email";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your mail",
                    hintStyle: mystyle(15),
                    labelStyle: mystyle(15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.orange,width: 2)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.orange,width: 2)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.orange,width: 2)
                    ),
                  ),
                ),
                SizedBox(height: 11,),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Please Enter Password";
                    }
                    if(value.length<3){
                      return "Use Strong Password";
                    }
                    // if(!value.contains("#") && !value.contains("\$")){
                    //   return "Use special Character";
                    // }
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      hintStyle: mystyle(15),
                      labelStyle: mystyle(15),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.orange,width: 2)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.orange,width: 2)
                      ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.orange,width: 2)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                MaterialButton(onPressed: (){
                  if(_formkey.currentState!.validate()){
                    getLogin();
                  }
                },
                  color: Colors.orange,
                  elevation: 0,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Text("Login",style: mystyle(16),),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  getLogin() async {
    try{
      setState(() {
        isLoading = true;
      });
      String url = "${baseUrl}sign-in";
      var map = Map<String,dynamic>();
      map['email'] = emailController.text.toString();
      map['password'] = passwordController.text.toString();
      var response = await http.post(Uri.parse(url),body: map);
      var data = jsonDecode(response.body);
      setState(() {
        isLoading = false;
      });

      if(response.statusCode == 200){
        showToastMessage("Login successful");
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("token", data['access_token']); //todo: most important
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavBarPage(),));
      }
      else{
        showToastMessage("login failed, try again");
      }
      print(data);
      print(response.statusCode);
    }catch(e){
      print(e);
    }
  }

  isLogin()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    // print(token);
    if(token != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => NavBarPage(),));
    }
  }

}
