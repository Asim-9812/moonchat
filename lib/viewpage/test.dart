

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moon_chat/providers/auth_provider.dart';

import '../common/firebase_instances.dart';
import '../common/snackshow.dart';
import '../providers/toggleprovider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class TestPage extends ConsumerWidget {

  final types.User user;
  TestPage(this.user);

  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context,ref) {


    final image = ref.watch(imageProvider);

    return Scaffold(

      body: Container(
        width: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage(user.imageUrl!),
        //     fit: BoxFit.cover,
        //   ),
        // ),

        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: InkWell(
                onTap: (){
                  ref.read(imageProvider.notifier).pickAnImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(

                    height: 150.h,
                    width: 150.w,
                    color: Colors.black.withOpacity(0.2),
                    child: image == null ? Center(child: Text('select an image', style: TextStyle(color: Colors.white),)) : Image.file(File(image.path),fit: BoxFit.cover,),
                  ),
                ),
              ),
            ),

            Container(
              child: InkWell(
                  onTap: (){

                  },
                  child: Text('Set Wallpaper')),
            ),

            Container(
              color: Colors.red,
              height: 300.h,
              width: 300.w,
            )

          ],
        ),


      ),

    );
  }
}
