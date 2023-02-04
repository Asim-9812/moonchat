import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moon_chat/services/crud_service.dart';

import '../providers/room_provider.dart';
import 'chat_page.dart';



class UserDetail extends ConsumerWidget {

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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100.h,
          ),
          Container(
            // color: Colors.red,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 60,
                  child: Container(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    Text(user.firstName!,style: TextStyle(color: Colors.white,fontSize: 35.sp,fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.h,),
                    Text('Bio',style: TextStyle(color: Colors.white,fontSize: 18.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold))
                    // if(user.firstName == 'test') Text('data') ,
                  ],
                ),
                SizedBox(width: 80.w,),
                InkWell(
                  onTap: () async {
                      final response = await ref.read(roomProvider).roomCreate(user);
                      if(response !=null){
                        Get.to(() => ChatPage(response, user.metadata!['token'], user.firstName!), transition: Transition.rightToLeft);
                      }
                  },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0,bottom: 15.0),
                      child: Icon(Ionicons.chatbubble_ellipses_outline,size: 40.sp,),
                    ))


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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
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
    );
  }
}
