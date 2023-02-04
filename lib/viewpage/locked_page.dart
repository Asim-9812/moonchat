import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moon_chat/viewpage/user_detail.dart';
import 'package:moon_chat/viewpage/widgets/tranisition.dart';

import '../common/firebase_instances.dart';
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import 'chat_page.dart';


class LockedPage extends ConsumerWidget {

  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;
  @override
  Widget build(BuildContext context, ref) {
    final rooms = ref.watch(roomStream);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          actions: [

            Padding(
              padding: const EdgeInsets.only(right: 12.0),
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
              ),
            )

          ],
        ),
        body: Container(
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
              child: rooms.when(
                  data: (data){
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          final otherUser = data[index].users.firstWhere((element) => element.id != uid);
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                              width: 350.w,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: InkWell(
                                  onTap: (){
                                    Get.to(()=>UserDetail(otherUser),transition: Transition.fade);
                                   // Get.to(() => ChatPage(data[index], otherUser.metadata!['token'], otherUser.firstName!));
                                  },

                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(otherUser.firstName!,style: TextStyle(color: Colors.white,fontSize: 25.sp,fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(onPressed: (){},
                                                  icon: Icon(LineIcons.phoneVolume,color: Colors.white,size: 30.sp,)),
                                              SizedBox(width: 15.w,),
                                              IconButton(onPressed: () {

                                                  Navigator.push(context,
                                                      CupertinoRoute(exitPage: LockedPage(), enterPage: ChatPage(data[index], otherUser.metadata!['token'], otherUser.firstName!)));

                                                //Get.to(()=> ChatPage(response,user.metadata!['token'],user.firstName!),transition: Transition.rightToLeftWithFade);}
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
                  error: (err, stack) => Text('$err'),
                  loading: () => Center(child: CircularProgressIndicator())
              ),
            ),
          ),
        )
    );
  }
}