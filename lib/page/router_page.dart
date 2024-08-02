import 'package:flutter/material.dart';
import '/widget/add_transaction.dart';
import 'dashboard.dart';
import 'home.dart';
import 'tags.dart';
import 'menu.dart';
import '/widget/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateHomeData() {
    Home.fetchTransactions(context);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _navigateToAddItemPage(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddTransaction(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    _updateHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          Home(),
          Dashboard(),
          Tags(),
          Menu(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onPageChanged,
      ),
      floatingActionButton: SizedBox(
        width: 70.0, // Adjust the width to make it larger
        height: 70.0, // Adjust the height to make it larger
        child: FloatingActionButton(
          onPressed: () => _navigateToAddItemPage(context),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.black,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0), // Ensure the radius makes it circular
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
