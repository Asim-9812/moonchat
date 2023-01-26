import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/snackshow.dart';
import '../providers/auth_provider.dart';
import '../providers/toggleprovider.dart';

class AuthPage extends ConsumerWidget {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context,ref) {

    final isLogin = ref.watch(loginProvider);
    final auth =ref.watch(authProvider);



    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/background/moon2.gif",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 270.h,
            left: 50.w,
            child: Form(
              key: _form,
              child: Container(
                // color: Colors.white,
                width: 300.w,
                height: 270.h,
                child: Column(
                  children: [
                    if(!isLogin) TextFormField(
                        controller: usernameController,
                        validator:(val){
                          if(val!.isEmpty){
                            return 'username is  required';
                          }
                          else if(val.length>20){
                            return 'maximum character exceeded';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white,fontSize: 30.sp),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical:0),
                            // enabledBorder: OutlineInputBorder(),


                            // fillColor: Colors.black,
                            // filled: true,
                            hintText: 'USERNAME', hintStyle: TextStyle(color: Colors.grey,fontSize: 30.sp)
                        )
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                        controller: emailController,
                        validator:(val){
                          if(val!.isEmpty){
                            return 'e-mail is  required';
                          }
                          else if(!val.contains('@')){
                            return 'please enter valid email';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white,fontSize: 30.sp),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical:0),
                            // enabledBorder: OutlineInputBorder(),


                            // fillColor: Colors.black,
                            // filled: true,
                            hintText: 'E-MAIL', hintStyle: TextStyle(color: Colors.grey,fontSize: 30.sp)
                        )
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        validator:(val){
                          if(val!.isEmpty){
                            return 'password is  required';
                          }
                          else if(val.length>20){
                            return 'maximum character exceeded';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white,fontSize: 30.sp),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical:0),
                            // enabledBorder: OutlineInputBorder(),


                            // fillColor: Colors.black,
                            // filled: true,
                            hintText: 'PASSWORD', hintStyle: TextStyle(color: Colors.grey,fontSize: 30.sp)
                        )
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: (){
                        _form.currentState!.save();
                        FocusScope.of(context).unfocus();
                        if(_form.currentState!.validate()){

                          if(isLogin){
                            ref.read(authProvider.notifier).userLogin(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());
                          }else{
                              ref.read(authProvider.notifier).userSignUp(
                                  username: usernameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),);
                            }
                          }


                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          auth.isLoad? Center(child: CircularProgressIndicator(),):
                          Text(isLogin? 'ENTER':'SIGN UP',style: TextStyle(color: Colors.grey,fontSize: 15.sp),),
                          Icon(Icons.keyboard_arrow_right,color: Colors.grey,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 40.h,
            right: 20.w,
            child: InkWell(
              onTap: (){
                _form.currentState!.reset();
                ref.read(loginProvider.notifier).change();
              },
              child: Text(isLogin? 'SIGN UP':'LOGIN',style: TextStyle(color: Colors.grey,fontSize: 15.sp),),
            ),
          )

        ],
      )
    );
  }
}