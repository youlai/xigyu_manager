// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, invalid_use_of_protected_member

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-04-11 17:38:42
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/page_factory.dart';
import 'package:xigyu_manager/pages/page_home.dart';
import 'package:xigyu_manager/pages/page_login.dart';
import 'package:xigyu_manager/utils/request_util.dart';
import 'package:xigyu_manager/utils/utils.dart';
import 'package:xigyu_manager/widgets/update_dialog.dart';

Future<void> main() async {
  await GetStorage.init();
  account.value = box.read('account') ?? {};
  loginId.value = box.read('loginId') ?? '';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => MaterialClassicHeader(),
      child: MaterialApp(
        title: '西瓜鱼后台',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: account.isEmpty ? Login() : IndexPage(),
      ),
    );
  }
}

class IndexPage extends StatefulWidget {
  const IndexPage({Key key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  RxInt currentIndex = 0.obs;

  PageController pageCtr = PageController(initialPage: 0);
  RxList menuList = [].obs;
  CancelToken cancelToken;
  String savePath;

  var _dialogKey;
  @override
  void initState() {
    super.initState();
    checkUpdate();
    getRolerList();
  }

  ///获取角色菜单
  getRolerList() {
    RequestUtil.post(Api.getRolerList, {'LoginId': loginId.value, 'TypeId': 0})
        .then((value) {
      if (value['Success']) {
        menuList.value = value['rows'];
      }
    });
  }

  ///检查更新
  checkUpdate() {
    if (!kDebugMode) {
      PackageInfo.fromPlatform().then((value) {
        packageInfo.value = value;
        String appName = packageInfo.value.appName;
        String packageName = packageInfo.value.packageName;
        String version = packageInfo.value.version;
        String buildNumber = packageInfo.value.buildNumber;
        print(
            'appName:$appName,packageName:$packageName,version:$version,buildNumber:$buildNumber');
        RequestUtil.post('https://www.pgyer.com/apiv2/app/check', {},
                queryParameters: {
                  'appKey': Platform.isAndroid
                      ? '9af032e2053dd8d624bf761a6534746e'
                      : 'c93a8d6015ea9fdeccb72a8c9ece098f',
                  '_api_key': '982c1db15da6f537091af87ea1a5b3d6',
                  'buildVersion': version,
                },
                baseUrl: false)
            .then((value) {
          print(value);
          if (value['code'] == 0) {
            if (value['data']['buildHaveNewVersion']) {
              _showUpdateDialog(value['data']);
            } else {
              // showToast('已经是最新版本');
            }
          } else {
            showToast(value['message']);
          }
        });
      });
    }
  }

  void _showUpdateDialog(Map _upgradeInfo) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => _buildDialog(_upgradeInfo),
    );
  }

  Widget _buildDialog(Map _upgradeInfo) {
    return WillPopScope(
        onWillPop: () async => false,
        child: UpdateDialog(
          key: _dialogKey,
          upgradeInfo: _upgradeInfo,
          onClickWhenDownload: (_msg) {
            //提示不要重复下载
            showToast(_msg);
          },
          onClickWhenNotDownload: () {
            //下载apk，完成后打开apk文件，建议使用dio+open_file插件
            if (Platform.isAndroid) {
              downloadApk(_upgradeInfo);
            } else {
              launch(_upgradeInfo['buildShortcutUrl'] ?? '--');
            }
          },
        ));
  }

  void downloadApk(Map _upgradeInfo) async {
    Directory tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir.path;
    savePath = '$tempPath/update_${_upgradeInfo['buildVersion']}.apk';
    File file = File(savePath);
    file.exists().then((value) async {
      if (value) {
        _installApk();
      } else {
        Dio dio = new Dio();
        dio.options.connectTimeout = Duration(milliseconds: 5000); //5s
        dio.options.receiveTimeout = Duration(milliseconds: 3000);
        cancelToken = CancelToken(); //可以用来取消操作
        await dio.download(_upgradeInfo['downloadURL'], savePath,
            onReceiveProgress: (_received, _total) {
          _updateProgress((_received * 100) ~/ _total);
        },
            options:
                Options(receiveTimeout: Duration(milliseconds: 5 * 60 * 1000)),
            cancelToken: cancelToken).catchError((_error) {
          print(_error);
        });
      }
    });
  }

  void _installApk() async {
    Navigator.of(context).pop();
    print(savePath);
    print(Uri.file(savePath));
    OpenFile.open(savePath).then((value) {});
  }

  //dio可以监听下载进度，调用此方法
  void _updateProgress(_progress) {
    setState(() {
      print('下载进度$_progress%');
      if (_progress == 100) {
        _installApk();
      }
      if (_dialogKey.currentState != null) {
        _dialogKey.currentState.progress = _progress;
      } else {
        cancelToken.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Obx(() => Drawer(
            menuList: menuList.value,
          )),
      body: PageView(
        controller: pageCtr,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          currentIndex.value = index;
        },
        children: [HomePage(), FactoryManage(type: 1,), HomePage()],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            onTap: (index) {
              currentIndex.value = index;
              pageCtr.animateToPage(index,
                  duration: Duration(microseconds: 500), curve: Curves.linear);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(Icons.home),
                  label: '首页'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  activeIcon: Icon(Icons.list),
                  label: '工厂管理'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  activeIcon: Icon(Icons.person),
                  label: '我的'),
            ],
            currentIndex: currentIndex.value,
          )),
    );
  }
}

class Drawer extends StatefulWidget {
  List menuList = [];
  Drawer({Key key, this.menuList}) : super(key: key);

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  List get menuList => widget.menuList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[100]),
                    borderRadius: BorderRadius.all(Radius.circular(75)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: 'sss',
                    width: 50,
                    height: 50,
                    placeholder: (c, t) => Image.asset('assets/avator.png'),
                    errorWidget: (c, t, x) => Image.asset('assets/avator.png'),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      account['UserId'] ?? '--',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      account['TrueName'] ?? '--',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Icon(
                    //     Icons.keyboard_arrow_down,
                    //     size: 15,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() => Text(
                          '西瓜鱼售后管理系统V${packageInfo.value == null ? '--' : packageInfo.value.version}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (c, i) => ExpansionTile(
                            expandedCrossAxisAlignment: CrossAxisAlignment.end,
                            expandedAlignment: Alignment.centerRight,
                            childrenPadding: EdgeInsets.all(10),
                            maintainState: true,
                            title: Text(
                              menuList[i]['Menu']['Name'],
                            ),
                            children: List.generate(
                                menuList[i]['SubMenu'].length,
                                (index) => ListTile(
                                      dense: true,
                                      title: Text(
                                        menuList[i]['SubMenu'][index]['Name'],
                                      ),
                                      onTap: () {
                                        var name = menuList[i]['SubMenu'][index]
                                            ['Name'];

                                        switch (name) {
                                          case '工厂管理':
                                            pushTo(context, FactoryManage());
                                            break;
                                          default:
                                            showToast(name);
                                        }
                                      },
                                    )).toList(),
                          ),
                      separatorBuilder: (c, i) => Divider(
                            height: 0.5,
                            thickness: 0.5,
                          ),
                      itemCount: menuList.length),
                ),
                ElevatedButton(
                    onPressed: () {
                      box.erase();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: ((context) => Login())));
                    },
                    child: Text('退出登录'))
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                  onPressed: () {
                    pop(context);
                  },
                  icon: Icon(Icons.close)),
            )
          ],
        ),
      ),
    );
  }
}
