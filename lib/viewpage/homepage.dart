import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moon_chat/providers/auth_provider.dart';
import 'package:moon_chat/viewpage/chatpage.dart';
import 'package:moon_chat/viewpage/feed_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  List pages=[
    FeedPage(),
    ChatPage()
  ];

  int _selectedIndex=0;
  late PageController _pageController;

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


  // void onTap(int index){
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return Scaffold(
              extendBody: true,
              body: Stack(
                children: [
                  SizedBox.expand(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _selectedIndex = index);
                      },
                      children: [

                        FeedPage(),
                        ChatPage(),
                      ],

                    ),
                  ),

                  //log out...
                  Positioned(
                      right: 10.w,
                      top: 45.h,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context){
                                return BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AlertDialog(
                                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),

                                    title: Center(child: Text('Are you sure?')),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(onPressed: (){
                                          ref.read(authProvider.notifier).userLogOut();
                                          Navigator.pop(context);
                                          }, child: Text('Yes',style: TextStyle(color: Colors.purple)),),
                                        TextButton(onPressed: () {
                                          Navigator.pop(context);
                                          }, child: Text('No',style: TextStyle(color: Colors.purple))),

                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        child: Icon(
                          Icons.logout, color: Colors.white54, size: 25.w,),
                      )
                  ),

                  

                  // pages[currentIndex]
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                elevation: 0,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                iconSize: 25.w,
                unselectedFontSize: 0.0,
                selectedFontSize: 10.w,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                selectedItemColor: Colors.purple,

                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.feed),
                      label: ''
                  ),

                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble),
                      label: ''
                  ),

                ],


              )

          );
        }
    );
  }

  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });

  }

}










