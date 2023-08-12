// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wxwork/flutter_wxwork.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/main.dart';
import 'package:xigyu_manager/utils/request_util.dart';
import 'package:xigyu_manager/utils/utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
  late String host;
  final _flutterWxworkPlugin = FlutterWxwork();
  @override
  void initState() {
    super.initState();
    userNameCon.text = account['UserId'] ?? '';
    pwdCon.text = account['DeCode'] ?? '';
    username = account['UserId'] ?? '';
    password = account['DeCode'] ?? '';
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
            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
            //   child: TextField(
            //     controller: userNameCon,
            //     // keyboardType: TextInputType.phone,
            //     decoration: InputDecoration(
            //       labelText: '请输入账号',
            //     ),
            //     onChanged: (value) {
            //       this.setState(() {
            //         username = value;
            //       });
            //     },
            //   ),
            // ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            //   child: TextField(
            //     controller: pwdCon,
            //     decoration: InputDecoration(
            //       labelText: '请输入密码',
            //       suffixIcon: GestureDetector(
            //         child: Icon(Icons.remove_red_eye, color: Colors.black26),
            //         onTap: () {
            //           setState(() {
            //             showPassword = !showPassword;
            //           });
            //         },
            //       ),
            //     ),
            //     obscureText: !showPassword,
            //     onChanged: (value) {
            //       this.setState(() {
            //         password = value;
            //       });
            //     },
            //   ),
            // ),
            Image.asset(
              'assets/avator.png',
              width: 80,
              height: 80,
            ),
            SizedBox(
              height: 45,
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
                  '企业微信登录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                onPressed: () {
                  wxworkLogin();
                },
                // onPressed:
                //     (!isNullOrEmpty(username) && !isNullOrEmpty(password))
                //         ? _handleLogin
                //         : null,
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
                                host = value as String;
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
                    // getIp();
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
      FocusManager.instance.primaryFocus!.unfocus();
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
      // getIp();
    }
  }

  ///获取IP
  void getIp(openId) {
    RequestUtil.get(
            'https://qifu-api.baidubce.com/ip/local/geo/v1/district', {},
            baseUrl: false)
        .then((value) {
      if (value['code'] == 'Success') {
        var result = value['data'];
        var params = {
          // 'UserId': username,
          // 'Password': password,
          'OpenId': openId,
          'Ip': value['ip'],
          'ProvinceName': result['prov'],
          'CityName': result['city'],
          'AreaName': result['district'],
          'Isp': result['isp'],
          'Lat': result['lat'],
          'Lng': result['lng'],
        };
        login(params);
      } else {
        showToast(value['msg']);
      }
    });
  }

  void login(params) {
    RequestUtil.showLoadingDialog(context);
    RequestUtil.post(Api.wxLogin, params).then((value) {
      RequestUtil.hiddenLoadingDialog(context);
      if (value['Success']) {
        showToast("登陆成功");
        token.value = value['rows']['Token'];
        serviceId.value = value['rows']['Model']['Id'];
        account.value = value['rows']['Model'];
        loginId.value = value['rows']['Model']['UserId'];
        box.write('token', token.value);
        box.write('serviceId', serviceId.value);
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
            serviceId.value = -1;
            box.write('serviceId', -1);
          } else {
            isAdmin.value = false;
            box.write('serviceId', serviceId.value);
          }
        }
        box.write('isAdmin', isAdmin.value);
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (BuildContext context) {
          return IndexPage();
        }));
      } else {
        showToast(value['msg']);
      }
    });
  }

  ///企业微信登录
  Future<void> wxworkLogin() async {
    /// 初始化（发起授权之前需先进行初始化）
    bool isInit = await _flutterWxworkPlugin.register(
        scheme: 'wwauth7ed1603fe2424990000008',
        corpId: 'ww7ed1603fe2424990',
        agentId: '1000008');
    if (!isInit) {
      showToast('企业微信初始化失败');
      return;
    }

    /// 判断是否安装企业微信
    bool isInstall = await _flutterWxworkPlugin.isAppInstalled();
    if (!isInstall) {
      showToast('未安装企业微信');
      return;
    }

    ///https://developer.work.weixin.qq.com/document/path/91194
    /// 调起授权
    /// errCode
    ///ERR_OK = 0(用户同意)
    ///ERR_FAIL = 1（授权失败）
    ///ERR_CANCEL = -1（用户取消）
    ///code
    ///用户换取access_token的code，仅在ErrCode为0时有效
    ///state
    ///第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendMessage时传入，由企业微信终端回传，state字符串长度不能超过1K
    AuthModel result = await _flutterWxworkPlugin.auth();
    // showToast(result.toString());
    if (result.errCode == '0') {
      // showToast('登录成功');
      //复制
      // Clipboard.setData(ClipboardData(text: result.code));
      RequestUtil.post(Api.workWxLogin, {'Code': result.code}).then((value) {
        if (value['Success']) {
          getIp(value['rows']['OpenId']);
        } else {
          showToast(result.toString() + ' ' + value['msg']);
        }
      });
    } else if (result.errCode == '1' || result.errCode == '-1') {
      showToast('登录失败');
    }
  }
}
