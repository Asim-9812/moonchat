import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moon_chat/common/firebase_instances.dart';
import 'package:moon_chat/providers/auth_provider.dart';
import 'package:moon_chat/viewpage/widgets/comments.dart';
import 'package:moon_chat/viewpage/widgets/create_post.dart';
import 'package:moon_chat/viewpage/widgets/update_post.dart';
import '../common/snackshow.dart';
import '../providers/crud_provider.dart';
import '../providers/toggleprovider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../services/crud_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:ionicons/ionicons.dart';



class FeedPage extends ConsumerStatefulWidget {

  @override
  ConsumerState<FeedPage> createState() => _FeedPage();
}

class _FeedPage extends ConsumerState<FeedPage> {




  late String userName;
  late types.User loginUser;






  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;

  final captionController = TextEditingController();

  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userStream(auth!));

    final postData = ref.watch(postStream);

    ref.listen(crudProvider, (previous, next) {
      if(next.errorMessage.isNotEmpty){
        SnackShow.showFailure(context, next.errorMessage);
      }
    });
    user.when(
        data: (data){
          userName = data.firstName!;
          loginUser = data;
        },
        error: (err, stack) => Text('$err'),
        loading: () => Center(child: CircularProgressIndicator())
    );

    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.black38,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
        IconButton(
            onPressed: (){
              print ('tapped');
              showDialog(
                  context: context,
                  builder: (_){
                    return Feed();
                  }
              );
            },
            icon: Icon(Icons.add_box,size: 25.sp,color: Colors.white,)
        ),
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
            image: AssetImage('assets/background/default.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150.h,
                    width: 380.w,

                    decoration: new BoxDecoration(
                        color: Colors.black.withOpacity(0.5)),

                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: postData.when(
                      data: (data){

                        return ListView.builder(
                          //scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context,index){
                              final post = data[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.black.withOpacity(0.8)),
                                          height: 420.h,
                                          width: 380.w,


                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0,top:15,bottom: 15),
                                                      child: Text(post.caption,style: TextStyle(color: Colors.white,fontSize: 20.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                                                    ),

                                                    // MENU...
                                                     Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child:

                                                      auth == post.userId? IconButton(
                                                          onPressed: (){
                                                            Get.defaultDialog(
                                                                backgroundColor: Colors.black,
                                                                title: 'Menu',
                                                                content: Column(
                                                                  children: [
                                                                    Divider(
                                                                      height: 0,
                                                                      color: Colors.white38,
                                                                    ),
                                                                    InkWell(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                        showDialog(
                                                                            context: context,
                                                                            builder: (_){
                                                                              return UpdateCaption(post);
                                                                            }
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 15.0),
                                                                            child: Text('Edit'),
                                                                          ),
                                                                          IconButton(
                                                                              onPressed: (){
                                                                                Navigator.pop(context);
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (_){
                                                                                      return UpdateCaption(post);
                                                                                    }
                                                                                );
                                                                              }, icon: Icon(Icons.edit,color: Colors.purple,)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      height: 0,
                                                                      color: Colors.white38,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:(){

                                                                        Navigator.pop(context);
                                                                        Get.defaultDialog(
                                                                          title: '',
                                                                          backgroundColor: Colors.black,
                                                                          content: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Text('Are You Sure?'),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    TextButton(
                                                                                        style: TextButton.styleFrom(
                                                                                            backgroundColor: Colors.purple
                                                                                        ),
                                                                                        onPressed: (){
                                                                                          ref.read(crudProvider.notifier).delPost(
                                                                                              postId: post.id,
                                                                                              imageId: post.imageId
                                                                                          ).then((value) => Navigator.pop(context));

                                                                                        }, child: Text('Yes',style: TextStyle(color: Colors.white),)),
                                                                                    TextButton(
                                                                                        style: TextButton.styleFrom(
                                                                                            backgroundColor: Colors.purple
                                                                                        ),
                                                                                        onPressed: (){
                                                                                          Navigator.pop(context);
                                                                                        }, child: Text('No',style: TextStyle(color: Colors.white)))
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),

                                                                        );

                                                                      },
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 15.0),
                                                                            child: Text('Delete'),
                                                                          ),
                                                                          IconButton(
                                                                              onPressed: (){
                                                                                Navigator.pop(context);
                                                                                Get.defaultDialog(
                                                                                  title: '',
                                                                                  backgroundColor: Colors.black,
                                                                                  content: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text('Are You Sure?'),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            TextButton(
                                                                                                style: TextButton.styleFrom(
                                                                                                    backgroundColor: Colors.purple
                                                                                                ),
                                                                                                onPressed: (){
                                                                                                  ref.read(crudProvider.notifier).delPost(
                                                                                                      postId: post.id,
                                                                                                      imageId: post.imageId
                                                                                                  ).then((value) => Navigator.pop(context));

                                                                                                }, child: Text('Yes',style: TextStyle(color: Colors.white),)),
                                                                                            TextButton(
                                                                                                style: TextButton.styleFrom(
                                                                                                    backgroundColor: Colors.purple
                                                                                                ),
                                                                                                onPressed: (){
                                                                                                  Navigator.pop(context);
                                                                                                }, child: Text('No',style: TextStyle(color: Colors.white)))
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),

                                                                                );


                                                                              }, icon: Icon(Icons.delete,color: Colors.purple,)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                            );
                                                          },
                                                          icon: Icon(Icons.more_horiz_rounded,color: Colors.white,)):null,
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  height: 0,
                                                  color: Colors.white38,
                                                ),
                                                    Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: FullScreenWidget(
                                                        child: CachedNetworkImage(
                                                          imageUrl: post.imageUrl,
                                                          fit: BoxFit.cover,
                                                          width: 300.w,
                                                          height: 300.h,),
                                                      ),
                                                    )
                                                ),
                                                Divider(
                                                  height: 0,
                                                  color: Colors.white38,
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                        onPressed: (){
                                                          if(post.like.usernames.contains(userName)){
                                                            SnackShow.showFailure(context, 'You have already like this post');
                                                          }else{
                                                            ref.read(loginProvider.notifier).change();
                                                            post.like.usernames.add(userName);
                                                            ref.read(crudProvider.notifier).addLike(
                                                                username: post.like.usernames,
                                                                like: post.like.likes,
                                                                postId: post.id
                                                            );
                                                          }

                                                        }, icon: post.like.likes==2? Icon(Ionicons.heart,color: Colors.purple,):
                                                    post.like.likes==1? Icon(Ionicons.heart_half_outline,color: Colors.purple):
                                                    Icon(Ionicons.heart_outline,color: Colors.purple)),

                                                    IconButton(onPressed: (){

                                                      // Get.to(()=> DetailPage(post, loginUser));

                                                      showDialog(
                                                          context: context,
                                                          builder: (_){
                                                            return DetailPage(post, loginUser);
                                                          }
                                                      );
                                                    }, icon: Icon(LineIcons.comments,color: Colors.purple,))



                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      error: (err,stack)=>Center(child: Text('$err')),
                      loading: ()=>Center(child: CircularProgressIndicator()
                      )
                  ),
                ),
              ),





              SizedBox(
                  height: 55.h
              )

    ]
        ),
      ),
    );

  }

}

