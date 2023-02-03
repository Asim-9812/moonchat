


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moon_chat/providers/room_provider.dart';
import 'package:moon_chat/viewpage/chat_page.dart';

import '../common/firebase_instances.dart';
import '../providers/auth_provider.dart';
import '../services/crud_service.dart';

class UsersPage extends ConsumerWidget {

  final types.User user;
  UsersPage(this.user);

  late String userName;

  late types.User loginUser;

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;

  @override
  Widget build(BuildContext context,ref) {
    final users = ref.watch(usersStream);
    final postData = ref.watch(postStream);

    return Scaffold(
      extendBodyBehindAppBar: true,


      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      body:  Container(
        // color: Colors.white,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/userdetail.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
        child: Container(
          height: 220.h,
          width: 350.w,

          child: users.when(
              data: (data){
                return ListView.builder(
                  itemCount: data.length,
                    itemBuilder: (context, index){
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.4)),
                          // height: 250.h,
                          width: 350.w,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: InkWell(
                              onTap: (){
                                print('tapped');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data[index].firstName!,style: TextStyle(color: Colors.white,fontSize: 25.sp,fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(onPressed: (){},
                                            icon: Icon(LineIcons.phoneVolume,color: Colors.white,size: 30.sp,)),
                                        SizedBox(width: 15.w,),
                                        IconButton(onPressed: () async{
                                          final response = await ref.read(roomProvider).roomCreate(user);
                                          if(response != null){
                                            Get.to(()=> ChatPage(response,user.metadata!['token'],user.firstName!),transition: Transition.rightToLeftWithFade);}
                                        },icon: Icon(Ionicons.chatbubble_ellipses_outline,color: Colors.white,size: 30.sp,)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    }
                );
              },
              error: (err, stack) => Center(child: Text('$err')),
              loading: () => Container()
          ),
        ),
          ),

      ),
    );
  }
}
