import 'package:flutter/material.dart';
import 'package:grocery_app_user/views/dashboard/account/account_view.dart';
import 'package:grocery_app_user/views/dashboard/cart/cart_view.dart';
import 'package:grocery_app_user/views/dashboard/favourite/favourite_view.dart';
import 'package:grocery_app_user/views/dashboard/home/home_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  var _widgetOptions = [HomeView(), FavouriteView(), CartView(), AccountView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        indicatorColor: Colors.green.shade300,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            label: 'Favourite',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          )
        ],
      ),
    );
  }
}
