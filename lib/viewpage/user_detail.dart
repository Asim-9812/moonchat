import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moon_chat/common/snackshow.dart';
import 'package:moon_chat/services/crud_service.dart';
import 'package:moon_chat/viewpage/test.dart';
import 'package:moon_chat/viewpage/widgets/create_post.dart';
import 'package:moon_chat/viewpage/widgets/update_wallpaper.dart';
import '../common/firebase_instances.dart';
import '../model/post_state.dart';
import '../providers/room_provider.dart';
import '../providers/toggleprovider.dart';
import '../providers/wall_provider.dart';
import '../services/wall_service.dart';
import 'chat_page.dart';



class UserDetail extends ConsumerWidget {

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;


  final types.User user;
  UserDetail(this.user);



  @override
  Widget build(BuildContext context, ref) {
    final wallData = ref.watch(wallStream);
    final image=ref.watch(imageProvider);
    final postData = ref.watch(postStream);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: Text(user.firstName!,style: TextStyle(color: Colors.white,fontSize: 30.sp,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
        actions: [
          auth != user.id? Padding(
            padding: const EdgeInsets.only(bottom: 8.0,right: 15),
            child: InkWell(
                onTap: () async {
                  final response = await ref.read(roomProvider).roomCreate(user);
                  if(response !=null){
                    Get.to(() => ChatPage(response, user.metadata!['token'], user.firstName!), transition: Transition.rightToLeft);
                  }
                },
                child: RotationTransition(
                    turns: AlwaysStoppedAnimation(315/360),
                    child: Icon(LineIcons.paperPlane,size: 30.sp,))),
          ):
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8.0),
               child: InkWell(
                   onTap: (){
                     showDialog(
                         context: context, 
                         builder: (context){
                           return AlertDialog(
                             backgroundColor: Colors.black,
                             content: Column(
                               mainAxisSize: MainAxisSize.min,
                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                      SnackShow.showFailure(context, 'Coming soon...');
                                    },
                                     child: Text('Change Profile Picture',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),)),
                                 Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                   child: Divider(
                                     thickness: 1,
                                     color: Colors.white,
                                   ),
                                 ),
                                 InkWell(
                                     onTap: (){
                                       Navigator.pop(context);
                                       showDialog(context: context, builder: (context){
                                         return WallChange();
                                     });},
                                     child: Text('Change wallpaper',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold)))
                               ],
                             ),
                           );
                         }
                     );
                     
                   },
                   child: Icon(Icons.more_vert_rounded)),
             )
        ],
      ),
      body:wallData.when(
          data: (data){
            final userWall = data.where((element) => element.userId == user.id).toList();
            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context,index){
                  return Stack(
                    children:[

                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 760.h,
                          width: 390.w,
                          decoration: BoxDecoration(
                          image: DecorationImage(
                          image: NetworkImage(userWall[index].imageUrl),
                    fit: BoxFit.cover,
                    ),
                    ),
                    ),
                      ),

                  Column(

                  children: [
                  SizedBox(
                  height: 15.h,
                  ),
                  Container(
                      width: double.infinity,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(user.imageUrl!),
                                  ),
                              SizedBox(height: 10.h,),
                      ],
                      ),
                  ),


                  Container(
                    // color: Colors.red,
                    height: 600.h,
                    width: double.infinity,
                    child: postData.when(
                    data: (data){
                    final userPost = data.where((element) => element.userId == user.id).toList();
                    return GridView.builder(
                    shrinkWrap: true,
                    itemCount: userPost.length,
                    padding: EdgeInsets.only(top: 15.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (context, index){
                    return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                    child: CachedNetworkImage(
                    imageUrl: userPost[index].imageUrl,
                    fit: BoxFit.cover,
                    ),

                    )),
                    );
                    }
                    );
                    },
                    error: (err, stack) => Text('$err'),
                    loading: () => CircularProgressIndicator()
                    ),
                  )
                  ],
                  ),



                  ]);
                }
                );

          },
          error: (err, stack) => Text('$err'),
          loading: () => CircularProgressIndicator()),




    );
  }
}


