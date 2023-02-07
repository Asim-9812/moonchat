import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moon_chat/providers/wall_provider.dart';
import 'package:moon_chat/services/crud_service.dart';
import 'package:moon_chat/viewpage/statuspage.dart';
import 'package:moon_chat/viewpage/test.dart';
import '../common/firebase_instances.dart';
import '../common/snackshow.dart';
import '../providers/room_provider.dart';
import '../providers/toggleprovider.dart';
import '../services/wall_service.dart';
import 'chat_page.dart';



class TestPage extends ConsumerWidget {

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;



  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  final _form1 = GlobalKey<FormState>();

  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context, ref) {
    final wallData = ref.watch(wallStream);
    final image=ref.watch(imageProvider);
    return Scaffold(
      extendBodyBehindAppBar: false,

      body: Container(
        decoration: new BoxDecoration(
          color: Colors.transparent,),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _form1,
              child: TextFormField(
                keyboardType: TextInputType.number,
                obscureText: true,
                controller: passwordController,
                validator: (val){

                  if(val!.isEmpty){
                    return 'Empty';
                  } else if (val != '1901'){
                    return 'Wrong Password';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 25.sp ,color: Colors.black,fontWeight: FontWeight.bold),

                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(),
                    hintText: 'Password...',
                    hintStyle: TextStyle(fontSize: 25.sp ,color: Colors.grey,fontWeight: FontWeight.bold)
                ),

              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              // color: Colors.blue,
              height: 50.h,
              width: 200.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,

                      ),
                      onPressed: (){

                        FocusScope.of(context).unfocus();
                          if(passwordController.text.trim()=='1901'){
                            passwordController.clear();


                          }

                      },
                      child: Text('Enter',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold))),


                ],
              )
            )
          ],
        ),
      ),



    );
  }
}
