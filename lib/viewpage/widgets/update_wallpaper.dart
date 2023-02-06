import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/firebase_instances.dart';
import '../../common/snackshow.dart';
import '../../model/post_state.dart';
import '../../providers/crud_provider.dart';
import '../../providers/toggleprovider.dart';
import '../../providers/wall_provider.dart';

class WallChange extends ConsumerStatefulWidget {



  @override
  ConsumerState<WallChange> createState() => _WallChangeState();
}

class _WallChangeState extends ConsumerState<WallChange> {

  final _form = GlobalKey<FormState>();



  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;



  @override
  Widget build(BuildContext context) {
    final image=ref.watch(imageProvider);
    final crud =ref.watch(crudProvider);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
        content: Container(
          // height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('Select An Image',style: TextStyle(fontSize: 20.sp),)),
              Divider(
                color: Colors.white30,  //color of divider
                thickness: 1, //thickness of divider line
                // indent: 10, //Spacing at the top of divider.
                // endIndent: 10, //Spacing at the bottom of divider.
              ),
              SizedBox(
                height: 5.h,),

              InkWell(
                  onTap: (){
                    ref.read(imageProvider.notifier).pickAnImage();
                  },
                  child: image == null  ? Icon(Icons.add_photo_alternate_outlined,size: 40.sp,): Image.file(File(image.path),width: 100.w,height: 100.h,),

              ),


            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions:[
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
                      image: image).then((value) => Navigator.pop(context)).then((value) => ref.invalidate(imageProvider));
                }



              }, child:
          Text('Change',style: TextStyle(fontSize: 18.sp,color: Colors.white),)),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1)
              ),
              onPressed: (){
            ref.invalidate(imageProvider);
            Navigator.pop(context);
          }, child: Text('Cancel',style: TextStyle(fontSize: 18.sp,color: Colors.white)))

        ],
      ),
    );
  }
}
