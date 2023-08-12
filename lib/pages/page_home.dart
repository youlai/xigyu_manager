// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sdk_version_ui_as_code

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-04-21 17:38:24
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/page_console.dart';
import 'package:xigyu_manager/pages/page_order_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ///0 控制台 1工单面板
  RxInt selectType = 0.obs;

  late PageController pageCtr;
  @override
  void initState() {
    super.initState();
    pageCtr = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('首页'),
        // ),
        body: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.only(bottom: 10),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                )),
                            Text(
                              account['TrueName'] ?? '--',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Text(
                                account['UserId'] ?? '--',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Icon(
                            //     Icons.keyboard_arrow_down,
                            //     size: 15,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            Obx(() => Text(
                                  'V${packageInfo.value.version}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        if(isAdmin.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                selectType.value = 0;
                                pageCtr.animateToPage(0,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.linear);
                              },
                              child: Obx(() => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: selectType.value == 0
                                          ? Colors.blue[200]
                                          : Colors.blue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    '控制台',
                                    style: TextStyle(color: Colors.white,fontSize: 18),
                                  ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.swap_horiz,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                selectType.value = 1;
                                pageCtr.animateToPage(1,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.linear);
                              },
                              child: Obx(() => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: selectType.value == 1
                                          ? Colors.blue[200]
                                          : Colors.blue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    '工单面板',
                                    style: TextStyle(color: Colors.white,fontSize: 18),
                                  ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: pageCtr,
                    onPageChanged: (index) {
                      selectType.value = index;
                    },
                    children: [
                      if(isAdmin.value)
                      ConsolePage(),
                      OrderPanel(),
                    ],
                  ),
                )
              ],
            )));
  }
}
