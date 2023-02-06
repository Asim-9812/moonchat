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
import 'package:moon_chat/viewpage/test.dart';
import '../common/firebase_instances.dart';
import '../common/snackshow.dart';
import '../providers/room_provider.dart';
import '../providers/toggleprovider.dart';
import '../services/wall_service.dart';
import 'chat_page.dart';



class TestPage extends ConsumerWidget {

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;

  final types.User user;
  TestPage(this.user);

  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context, ref) {
    final wallData = ref.watch(wallStream);
    final image=ref.watch(imageProvider);
    return Scaffold(
      extendBodyBehindAppBar: false,

      body: AlertDialog(
        content: wallData.when(
            data: (data){
              final userWall = data.where((element) => element.userId == user.id).toList();
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context,index){
                    return Container(
                        height: 825.h,
                        width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userWall[index].imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),

                        child: Column(

                          children: [
                            SizedBox(
                              height: 100.h,
                            ),

                            InkWell(
                                onTap: (){
                                  ref.read(imageProvider.notifier).pickAnImage();
                                },
                                child:Icon(Icons.add_photo_alternate_outlined)
                            ),


                            TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.1)
                                ),
                                onPressed: (){


                                  if(image == null){
                                    SnackShow.showFailure(context, 'Please select an image');}

                                  else{
                                    ref.read(wallProvider.notifier).addWall(
                                        userId: uid,
                                        image: image).then((value) => ref.invalidate(imageProvider));

                                  }


                                }, child:
                            Text('Change',style: TextStyle(fontSize: 18.sp,color: Colors.white),)),


                            image != null? Image.file(File(image.path),width: 40.w,height: 40.h,fit: BoxFit.cover,):Container(),




                          ],
                        ),
                      );
                  }
              );
            },
            error: (err, stack) => Text('$err'),
            loading: () => CircularProgressIndicator()
        ),
      )



    );
  }
}
