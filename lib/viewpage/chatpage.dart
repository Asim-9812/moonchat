import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context,ref) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/background/chat2.jpg",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Text('Chat feed',style: TextStyle(color: Colors.white))),]
      ),
    );
  }
}
