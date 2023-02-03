import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moon_chat/common/firebase_instances.dart';
import 'package:moon_chat/providers/room_provider.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';


class ChatPage extends ConsumerWidget{
final types.Room room;
final String token;
final String username;
ChatPage(this.room, this.token,this.username);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageData= ref.watch(messageStream(room));
    return Scaffold(
      body: messageData.when(
          data: (data) => Chat(
            theme: DarkChatTheme(
              inputBackgroundColor: Colors.white,
              inputTextColor: Colors.black,
              inputTextStyle: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),
              backgroundColor: Colors.blueGrey,
                  sentMessageBodyTextStyle: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,),
              primaryColor: Colors.black,
                secondaryColor: Colors.white,
              receivedMessageBodyTextStyle: TextStyle(color:Colors.black,fontSize: 20.sp,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
            ),
            messages: data,
            // showUserAvatars: true,
            onSendPressed: (PartialText val){

              FirebaseInstances.firebaseChatCore.sendMessage(val, room.id);

            },
            user: types.User(
              id: FirebaseInstances.firebaseChatCore.firebaseUser!.uid,


            ),
          ),
          error: (err, stack) => Text('$err'),
          loading: () => CircularProgressIndicator()),
    );
  }
}