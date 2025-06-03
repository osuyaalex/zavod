import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizesExt on num{
  //double get pW => ScreenUtil.defaultSize.width * this / 100;
  double get pW => ScreenUtil().screenWidth * this / 100;
  //double get pH => ScreenUtil().screenHeight * this / 100;
  double get pH => ScreenUtil().screenHeight * this / 100;
  Expanded get flex => Expanded(flex: this.toInt(), child: Container(),);
}
extension spaces on num{
  SizedBox get gap => SizedBox.square(dimension: this.h.pH);
}