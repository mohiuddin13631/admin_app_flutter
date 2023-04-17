import 'package:admin_app_flutter/screen/nav_bar/category_page.dart';
import 'package:admin_app_flutter/screen/nav_bar/home_page.dart';
import 'package:admin_app_flutter/screen/nav_bar/order_page.dart';
import 'package:admin_app_flutter/screen/nav_bar/product_page.dart';
import 'package:admin_app_flutter/screen/nav_bar/profile_page.dart';
import 'package:flutter/material.dart';
class NavBarPage extends StatefulWidget {
  const NavBarPage({Key? key}) : super(key: key);

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {

  List<Widget> pages = [
    HomePage(),
    CategoryPage(),
    ProductPage(),
    OrderPage(),
    ProfilePage()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blue,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category),label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.radar),label: "Product"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Order"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
      ),
    );
  }
}
