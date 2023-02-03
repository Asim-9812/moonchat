import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:moon_chat/common/snackshow.dart';
import 'package:moon_chat/viewpage/users_page.dart';

import '../providers/auth_provider.dart';
import '../providers/toggleprovider.dart';

class UnlockPage extends  ConsumerStatefulWidget {


  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage> {

  final _form1 = GlobalKey<FormState>();

  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final users = ref.watch(usersStream);
    final isRight = ref.watch(loginProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                    !isRight? Icon(Icons.lock_open,size: 100.sp,color: Colors.deepPurpleAccent,) : Icon(Icons.lock_outline,size: 100.sp,color: Colors.deepPurpleAccent,) ,

                //passwordController.text.trim()!='1901'? Icon(Icons.lock_outline,size: 100.sp,color: Colors.deepPurpleAccent,) :Icon(Icons.lock_open,size: 100.sp,color: Colors.deepPurpleAccent,),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: 180.w,
                  child: Form(
                    key: _form1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      controller: passwordController,
                      validator: (val){

                        if(val!.isEmpty){
                          SnackShow.showFailure(context, 'Password is empty');
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 40.sp ,color: Colors.deepPurpleAccent,fontWeight: FontWeight.bold),

                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 40.sp ,color: Colors.deepPurpleAccent,fontWeight: FontWeight.bold)
                      ),

                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
               Container(
                 // color: Colors.red,
                 height: 100.h,
                 width: double.infinity,
                 child: users.when(
                   data: (data) {
                     return ListView.builder(
                         itemCount: data.length,
                         itemBuilder: (context, index){
                           return
                             isRight? TextButton(onPressed: (){
                             ref.read(loginProvider.notifier).change();

                             FocusScope.of(context).unfocus();
                             if(_form1.currentState!.validate()){
                               if(passwordController.text.trim()!='1901'){
                                 SnackShow.showFailure(context, 'Password is Wrong');
                               }
                               else{
                                 Timer(Duration(milliseconds: 700), () {

                                   Get.to(()=>UsersPage(data[index]),transition:Transition.fadeIn);
                                 });
                                 passwordController.clear();

                               }
                             }
                           },
                               child: Text('Unlock',style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 30.sp,fontWeight: FontWeight.bold))):

                             TextButton(onPressed: (){
                               ref.read(loginProvider.notifier).change();
                             }, child: Text('Lock',style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 30.sp,fontWeight: FontWeight.bold)));


                         }

                     );


                   }, error: (err, stack) => Center(child: Text('$err')),
                     loading: () => Container()
                 ),
               )

              ],
            )),]
      ),
    );
  }
}
