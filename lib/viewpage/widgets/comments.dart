import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




class CommentList extends ConsumerStatefulWidget {

  @override
  ConsumerState<CommentList> createState() => _CommentListState();
}

class _CommentListState extends ConsumerState<CommentList> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 600.h,
        width: 400.w,
        color: Colors.purple,
      ),
    );
  }
}
