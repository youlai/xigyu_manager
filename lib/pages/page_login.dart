// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/main.dart';
import 'package:xigyu_manager/utils/request_util.dart';
import 'package:xigyu_manager/utils/utils.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  var username = '';
  var password = '';
  var code = '';
  var adminToken = '';
  bool pwdOrCode = true; //密码登录true 验证码登录false
  bool showPassword = false;
  TextEditingController userNameCon = TextEditingController();
  TextEditingController pwdCon = TextEditingController();
  TextEditingController codeCon = TextEditingController();
  TextEditingController hostCtr = TextEditingController();
  List<String> hosts = [
    'https://api.xigyu.com/api/',
    'http://192.168.0.203:8810/api/',
    'http://192.168.101.82:8810/api/',
    'http://192.168.0.95:8810/api/',
    'http://192.168.0.215:8810/api/',
    'http://192.168.0.22:8810/api/',
    'http://192.168.0.39:8810/api/',
    '自定义地址',
  ];
  String host;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              height: 120,
              child: Text(
                'Hi，欢迎使用西瓜鱼服务后台管理系统',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: TextField(
                controller: userNameCon,
                // keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: '请输入账号',
                ),
                onChanged: (value) {
                  this.setState(() {
                    username = value;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextField(
                controller: pwdCon,
                decoration: InputDecoration(
                  labelText: '请输入密码',
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.remove_red_eye, color: Colors.black26),
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !showPassword,
                onChanged: (value) {
                  this.setState(() {
                    password = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     InkWell(
            //         onTap: () {
            //           pushTo(context, ChangePwdPage());
            //         },
            //         child: Text(
            //           "忘记密码",
            //           style: TextStyle(fontSize: 14),
            //         )),
            //     InkWell(
            //       child: Text(
            //         '我要入驻',
            //         style: TextStyle(fontSize: 14),
            //       ),
            //       onTap: () {
            //         pushTo(context, RegisterPage());
            //       },
            //     ),
            //   ],
            // ),
            Container(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
              child: RaisedButton(
                color: Colors.blue,
                disabledColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '登录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                onPressed:
                    (!isNullOrEmpty(username) && !isNullOrEmpty(password))
                        ? _handleLogin
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///更改服务器地址
  void changeHost() {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          return AlertDialog(
            title: Center(
              child: Text('更改服务器地址'),
            ),
            content: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: DropdownButton(
                              // 隐藏下划线
                              underline: Container(height: 0),
                              hint: Text(
                                '请选择服务器地址',
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: host,
                              items: hosts
                                  .map((e) => DropdownMenuItem(
                                      child: Text(e), value: e))
                                  .toList(),
                              onChanged: (value) {
                                print(value);
                                host = value;
                                hostCtr.text = (value == '自定义地址' ? '' : value);
                                state(() {});
                              }))
                    ],
                  ),
                  Expanded(
                      child: TextField(
                    controller: hostCtr,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: '请输入服务器地址',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ))
                ],
              ),
              height: 200,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('确定'),
                onPressed: () {
                  var host = hostCtr.text;
                  if (host.isEmpty) {
                    showToast('请输入服务器地址');
                  } else {
                    username = username.substring(0, username.lastIndexOf('@'));
                    Dio dio = RequestUtil.getInstance();
                    dio.options.baseUrl = host;
                    Navigator.of(context).pop();
                    login();
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  _handleLogin() async {
    hideKeyboard(context);
    Dio dio = RequestUtil.getInstance();
    if (username.contains('@')) {
      changeHost();
    } else {
      dio.options.baseUrl = Api.baseUrl;
//      dio.options.baseUrl = 'http://192.168.0.203:8810/api/';
//      dio.options.baseUrl = 'http://192.168.0.39:8810/api/'; //小艺
      login();
    }
  }

  void login() {
    RequestUtil.showLoadingDialog(context);
    RequestUtil.post(Api.login, {'UserId': username, 'Password': password})
        .then((value) {
      RequestUtil.hiddenLoadingDialog(context);
      if (value['Success']) {
        showToast("登陆成功");
        account.value = value['rows'];
        loginId.value = value['rows']['UserId'];
        box.write('loginId', loginId.value);
        box.write('account', account.value);
        getUserRoler();
      } else {
        showToast(value['msg']);
      }
    });
  }

  ///获取账号角色
  void getUserRoler() {
    RequestUtil.post(Api.getUserRoler, {'LoginId': loginId.value})
        .then((value) {
      if (value['Success']) {
        List roles = value['rows'];
        for (var element in roles) {
          if (element['Name'] == '超级管理员' || element['Name'] == '公司财务') {
            isAdmin.value = true;
            box.write('isAdmin', isAdmin.value);
          }
        }
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (BuildContext context) {
          return IndexPage();
        }));
      } else {
        showToast(value['msg']);
      }
    });
  }
}
