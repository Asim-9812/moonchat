import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moon_chat/viewpage/user_detail.dart';
import 'package:moon_chat/viewpage/widgets/tranisition.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../common/firebase_instances.dart';
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import 'chat_page.dart';


class LockedPage extends ConsumerWidget {

  late String userName;
  late types.User loginUser;

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;


  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;
  @override
  Widget build(BuildContext context, ref) {
    final users = ref.watch(usersStream);
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 80.h,
                width: 350.w,
                child: users.when(
                    data: (data){
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return InkWell(
                              onTap: (){
                                Get.to(() => UserDetail(data[index]), transition: Transition.leftToRight);
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                    color: Colors.black.withOpacity(0.5)),
                                height: 100.h,
                                width: 350.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundImage: CachedNetworkImageProvider(data[index].imageUrl!),
                                        ),
                                        SizedBox(width: 15.w,),
                                        Text(data[index].firstName!,style: TextStyle(color: Colors.white,fontSize: 25.sp,fontWeight: FontWeight.bold),),
                                        SizedBox(width: 100.w,),
                                        // IconButton(onPressed: (){},
                                        //     icon: Icon(LineIcons.phoneVolume,color: Colors.white,size: 20.sp,)),
                                        // SizedBox(width: 10.w,),
                                        IconButton(onPressed: () async {

                                          final response = await ref.read(roomProvider).roomCreate(data[index]);
                                          if(response != null){
                                            Navigator.push(context,
                                                CupertinoRoute(exitPage: LockedPage(), enterPage: ChatPage(response, data[index].metadata!['token'], data[index].firstName!))
                                            );
                                          }



                                        },icon: Icon(Ionicons.chatbubble_ellipses_outline,color: Colors.white,size: 30.sp,))

                                      ],
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
        )
    ));
  }
}