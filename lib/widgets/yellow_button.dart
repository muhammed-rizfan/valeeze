import 'package:flutter/material.dart';
import 'package:valeeze/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YellowButton extends StatelessWidget {
  final String? title;
  final VoidCallback onPress;
  const YellowButton({Key? key, this.title, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),

      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(15), color: Colors.transparent),
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(5),
          backgroundColor: AppTheme.appYellow,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadowColor: AppTheme.appYellow,
        ),
        onPressed: this.onPress,
        child: Text(
          title!,
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
