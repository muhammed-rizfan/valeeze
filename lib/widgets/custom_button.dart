import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valeeze/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final String? icon;
  final VoidCallback? onPress;
  const CustomButton({Key? key, this.text, this.icon, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 0, right: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      shadowColor: AppTheme.appYellow,
      child: GestureDetector(
        onTap: this.onPress,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.appYellow),
          height: 115,
          width: 85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                height: 65,
                width: 65,
                child: SvgPicture.asset(
                  icon!,
                ),
                // child: Image.asset(
                //   icon!,
                //   fit: BoxFit.contain,
                // ),
              ),
              Text(
                text!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
