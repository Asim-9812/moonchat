import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moon_chat/common/firebase_instances.dart';
import 'package:moon_chat/providers/auth_provider.dart';
import '../common/snackshow.dart';
import '../providers/crud_provider.dart';
import '../providers/toggleprovider.dart';
import 'dart:io';

import '../services/crud_service.dart';




class CreatePage extends ConsumerWidget {

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;

  final captionController = TextEditingController();



  final _form = GlobalKey<FormState>();
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context,ref) {

    final users= ref.watch(usersStream);
    final postData = ref.watch(postStream);

    ref.listen(crudProvider, (previous, next) {
      if(next.errorMessage.isNotEmpty){
        SnackShow.showFailure(context, next.errorMessage);
      }
    });

    final image=ref.watch(imageProvider);
    final crud =ref.watch(crudProvider);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/background/create2.jpg",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 25.h,
              // left: 5.w,
              child: IconButton(
                  onPressed: (){
                    print ('tapped');
                    showDialog(
                        context: context,
                        builder: (_){
                          return Feed();
                        }
                    );
                  },
                  icon: Icon(Icons.add_box,size: 25.sp,color: Colors.white54,)
              )
          ),

          Center(
            child: Container(
              height: 300.h,
              width: double.infinity,
              child: postData.when(
                  data: (data){
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context,index){
                          final post = data[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.red,
                                    height: 300.h,

                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(imageUrl: post.imageUrl,width: 200.w,height: 200.w,),
                                        SizedBox(height: 10.h,),
                                        Text(post.caption),
                                        SizedBox(height: 10.h,),
                                      ],
                                    ))
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
          )
        ]
      ),
    );
  }
}

class Feed extends ConsumerStatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {

  final captionController = TextEditingController();

  final _form = GlobalKey<FormState>();
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;





  @override
  Widget build(BuildContext context) {
    final image=ref.watch(imageProvider);
    final crud =ref.watch(crudProvider);
    return AlertDialog(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
       content: Container(
         // height: double.infinity,
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Align(
                 alignment: Alignment.topLeft,
                 child: Text('New Post',style: TextStyle(fontSize: 25.sp),)),
             Divider(
               color: Colors.white30,  //color of divider
               thickness: 1, //thickness of divider line
               // indent: 10, //Spacing at the top of divider.
               // endIndent: 10, //Spacing at the bottom of divider.
             ),
             Stack(
                 children: [
                   Form(
                     key: _form,
                     child: TextFormField(
                         controller: captionController,
                         validator:(val){
                           if(val!.isEmpty){
                             return '';
                           }
                           else if(val.length>20){
                             return 'maximum character exceeded';
                           }
                           return null;
                         },
                         style: TextStyle(color: Colors.white,fontSize: 20.sp),

                         decoration: InputDecoration(
                           contentPadding: EdgeInsets.only(top:0,left: 10,bottom: 0,right: 40),
                           enabledBorder: OutlineInputBorder(),



                           fillColor: Color.fromRGBO(255, 255, 255, 0.2),
                           filled: true,
                           hintText: 'Caption', hintStyle: TextStyle(color: Colors.grey,fontSize: 20.sp)
                         )
                     ),
                   ),
                   Positioned(
                     right: 10.w,
                     bottom: 15,
                     child:  InkWell(
                         onTap: (){
                           ref.read(imageProvider.notifier).pickAnImage();
                         },
                         child: Icon(Icons.add_photo_alternate_outlined)
                     ),
                   ),

                 ]
             ),
             SizedBox(
               height: 10.h,
             ),
             Container(
               child: image == null  ? Container(): Image.file(File(image.path),width: 100.w,height: 100.w,),
             ),

           ],
         ),
       ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(onPressed: (){
          _form.currentState!.save();
          FocusScope.of(context).unfocus();
          if(_form.currentState!.validate()) {
            if (image == null && captionController.text.trim().isEmpty){
              SnackShow.showFailure(context, 'Please provide either caption or picture');
            }
            else{
              ref.read(crudProvider.notifier).addPost(
                  userId: uid,
                  caption: captionController.text.trim(),
                  image: image
              );
              crud.isLoad? Center(child: CircularProgressIndicator(),) : Navigator.pop(context);
            }

          }
          }, child: crud.isLoad? Center(child: CircularProgressIndicator(),) :
              Text('Post',style: TextStyle(fontSize: 25.sp,color: Colors.white),)),


        TextButton(onPressed: (){
          Navigator.pop(context);
          ref.invalidate(imageProvider);
          }, child: Text('Cancel',style: TextStyle(fontSize: 25.sp,color: Colors.white))),
      ],
    );
  }
}


