/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:25:49
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-04-03 13:10:23
 * @FilePath: /xigyu_manager/lib/api/utils.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xigyu_manager/widgets/back_route.dart' as br;

AppBar buildAppBar(String title, List<Widget> actions, BuildContext context,
    {result}) {
  return AppBar(
    //导航栏
    title: Text(title,
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal)),
    centerTitle: true,
    leading: IconButton(
      icon: Image.asset(
        'assets/back.png',
        width: 20,
        height: 20,
      ), //自定义图标
      onPressed: result ??
          () {
            Navigator.pop(context);
          },
    ),
    actions: actions,
    elevation: 0.5,
//      flexibleSpace: Store.connect<MyProvider>(
//          builder: (context, MyProvider provider, child) {
//            return Container(
//              decoration: BoxDecoration(
//                  color: Colors.white),
//            );
//          }),
    brightness: Brightness.light,
  );
}

bool isNullOrEmpty(String str) {
  return str == null || str.length == 0;
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white);
}

///isBack 是否支持
Future pushTo(BuildContext context, Widget page, {isBack = true}) {
//  return Navigator.of(context)
//      .push(MaterialPageRoute(builder: (context) => page));
  return Navigator.of(context).push(isBack
      ? br.CupertinoPageRoute(builder: (context) => page)
      : CupertinoPageRoute(builder: (context) => page));
}

pop<T>(BuildContext context, [T t]) {
  return Navigator.of(context).pop(t);
}
