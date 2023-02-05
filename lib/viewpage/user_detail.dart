import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moon_chat/services/crud_service.dart';
import 'package:moon_chat/viewpage/test.dart';
import '../common/firebase_instances.dart';
import '../providers/room_provider.dart';
import 'chat_page.dart';



class UserDetail extends ConsumerWidget {

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;

  final types.User user;
  UserDetail(this.user);

  @override
  Widget build(BuildContext context, ref) {
    final postData = ref.watch(postStream);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
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
          ): Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                print('tapped');

                Get.to(()=> TestPage(this.user));


              },
              child: Icon(Icons.more_vert_rounded),
            ),
          )
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/background/userdetail.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(

          children: [
            SizedBox(
              height: 100.h,
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
                  Text(user.firstName!,style: TextStyle(color: Colors.white,fontSize: 35.sp,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h,),
                  Text('Bio',style: TextStyle(color: Colors.white,fontSize: 18.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                ],
              ),
            ),


            postData.when(
                data: (data){
                  final userPost = data.where((element) => element.userId == user.id).toList();
                  return Expanded(
                    child: GridView.builder(
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
                    ),
                  );
                },
                error: (err, stack) => Text('$err'),
                loading: () => CircularProgressIndicator()
            )
          ],
        ),
      ),
    );
  }
}
