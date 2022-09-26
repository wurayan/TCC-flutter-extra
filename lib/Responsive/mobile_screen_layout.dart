import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partiu_app/Utils/Colors.dart';
import 'package:partiu_app/Utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  void navigationTapped(int page ){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItens
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _page==0 ? primaryColor : secondaryColor,), 
            label: "",
            backgroundColor: primaryColor),
            BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _page==1 ? primaryColor : secondaryColor,), 
            label: "",
            backgroundColor: primaryColor),
            BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: _page==2 ? primaryColor : secondaryColor,), 
            label: "",
            backgroundColor: primaryColor),
            BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _page==3 ? primaryColor : secondaryColor,), 
            label: "",
            backgroundColor: primaryColor),
            BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _page==4 ? primaryColor : secondaryColor,), 
            label: "",
            backgroundColor: primaryColor)
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
