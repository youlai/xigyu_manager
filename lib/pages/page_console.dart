// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-04-11 17:40:58
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 控制台
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/utils/request_util.dart';

class ConsolePage extends StatefulWidget {
  const ConsolePage({Key key}) : super(key: key);

  @override
  State<ConsolePage> createState() => _ConsolePageState();
}

class _ConsolePageState extends State<ConsolePage>
    with SingleTickerProviderStateMixin {
  RxList orderNum = [
    {'key': 'OrderNum', 'name': '工单量', 'count': 0}.obs,
    {'key': 'Capital', 'name': '资金流水', 'count': 0}.obs,
    {'key': 'Profit', 'name': '利润', 'count': 0}.obs,
    {'key': 'MasterNum', 'name': '入驻师傅', 'count': 0}.obs,
    {'key': 'FactoryNum', 'name': '入驻厂商', 'count': 0}.obs,
    {'key': 'EndNum', 'name': '完结工单', 'count': 0}.obs,
    {'key': 'CancelNum', 'name': '废除工单', 'count': 0}.obs,
  ].obs;

  ///0 今日 1昨日 2本月
  RxInt selectTime = 0.obs;

  RxString addStartTime = ''.obs;
  RxString addEndTime = ''.obs;
  RxString dateTimeRange = ''.obs;

  TabController tabCtr;

  RefreshController refreshCtr = RefreshController();
  @override
  void initState() {
    super.initState();
    tabCtr = TabController(length: 4, vsync: this);
    getToday();
  }

  ///获取今日
  getToday() {
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOrderNum();
  }

  ///获取昨天
  getYesterday() {
    addStartTime.value = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    addEndTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOrderNum();
  }

  ///获取本月
  getThisMonth() {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime(year, month));
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOrderNum();
  }

  ///获取统计数量
  getOrderNum() {
    RequestUtil.post(Api.getOrderNum, {
      'LoginId': loginId.value,
      'AddStartTime': addStartTime.value,
      'AddEndTime': addEndTime.value
    }).then((value) {
      if (value['Success']) {
        refreshCtr.refreshCompleted();
        Map data = value['rows'];
        for (var element in orderNum) {
          data.forEach((key, value) {
            if (element['key'] == key) {
              element['count'] = value;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: tabCtr,
                      isScrollable: true,
                      onTap: (index) {
                        debugPrint('$index');
                        tabCtr.index = index;
                        tabCtr.animateTo(index);
                      },
                      tabs: [
                        Tab(
                          text: '分析概论',
                        ),
                        Tab(
                          text: '急需处理',
                        ),
                        Tab(
                          text: '工单区域',
                        ),
                        Tab(
                          text: '师傅区域',
                        ),
                      ],
                      labelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: TabBarView(controller: tabCtr, children: [
              introductionToAnalysis(),
              UrgentTreatment(),
              Text('研发中'),
              Text('研发中'),
            ])),
          ],
        ));
  }

  Widget introductionToAnalysis() {
    return SmartRefresher(
      controller: refreshCtr,
      onRefresh: () {
        switch (selectTime.value) {
          case 0:
            getToday();
            break;
          case 1:
            getYesterday();
            break;
          case 2:
            getThisMonth();
            break;
          default:
            getToday();
        }
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[400], width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    selectTime.value = 0;
                    getToday();
                  },
                  child: Obx(() => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: selectTime.value == 0
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                      child: Text(
                        '今日',
                        style: TextStyle(
                            color: selectTime.value == 0
                                ? Colors.white
                                : Colors.black),
                      ))),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    selectTime.value = 1;
                    getYesterday();
                  },
                  child: Obx(() => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: selectTime.value == 1
                              ? Colors.blue
                              : Colors.white,
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  color: Colors.grey[400], width: 0.5))),
                      child: Text(
                        '昨日',
                        style: TextStyle(
                            color: selectTime.value == 1
                                ? Colors.white
                                : Colors.black),
                      ))),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    selectTime.value = 2;
                    getThisMonth();
                  },
                  child: Obx(() => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: selectTime.value == 2
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5))),
                      child: Text(
                        '本月',
                        style: TextStyle(
                            color: selectTime.value == 2
                                ? Colors.white
                                : Colors.black),
                      ))),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              DateTimeRange timeRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2017, 9, 7, 17, 30),
                  lastDate: DateTime.now());
              if (timeRange == null) return;
              selectTime.value=-1;
              debugPrint(timeRange.toString());
              addStartTime.value =
                  DateFormat('yyyy-MM-dd').format(timeRange.start);
              addEndTime.value = DateFormat('yyyy-MM-dd').format(timeRange.end);
              dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
              getOrderNum();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              // width: 210,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[400], width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit_calendar,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Obx(() => Text(dateTimeRange.value ?? '--',
                      style: TextStyle(fontSize: 12))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 15,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //设置列数
                    crossAxisCount: 2,
                    //设置横向间距
                    crossAxisSpacing: 10,
                    //设置主轴间距
                    mainAxisSpacing: 10,
                    childAspectRatio: 2),
                scrollDirection: Axis.vertical,
                itemCount: orderNum.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey[400], width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderNum[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Obx(() => Text(
                                            '${orderNum[index]['count']}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Image.asset(
                                      'assets/upward.png',
                                      width: 10,
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/histogram.png',
                            width: 35,
                            height: 35,
                          ),
                        ],
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///急需处理
class UrgentTreatment extends StatefulWidget {
  const UrgentTreatment({Key key}) : super(key: key);

  @override
  State<UrgentTreatment> createState() => _UrgentTreatmentState();
}

class _UrgentTreatmentState extends State<UrgentTreatment> {
  RxList orderNum = [
    {'key': 'PushNum', 'name': '被催工单', 'count': 0}.obs,
    {'key': 'AnomalyNum', 'name': '异常工单', 'count': 0}.obs,
    {'key': 'SuperNum', 'name': '超7工单', 'count': 0}.obs,
    {'key': 'RefuseNum', 'name': '拒接工单', 'count': 0}.obs,
    {'key': 'AarrantyNum', 'name': '质保工单', 'count': 0}.obs,
    {'key': 'RejectNum', 'name': '审核驳回', 'count': 0}.obs,
    {'key': 'DoorNum', 'name': '今日需上门', 'count': 0}.obs,
    {'key': 'SignNum', 'name': '已到货', 'count': 0}.obs,
    {'key': 'BackNum', 'name': '待返件', 'count': 0}.obs,
    {'key': 'VisitNum', 'name': '待核实', 'count': 0}.obs,
    {'key': 'MasterNum', 'name': '师傅实名', 'count': 0}.obs,
    {'key': 'FactoryNum', 'name': '厂商实名', 'count': 0}.obs,
    {'key': 'SheetNum', 'name': '费用单', 'count': 0}.obs,
    {'key': 'PartsNum', 'name': '配件单', 'count': 0}.obs,
    {'key': 'Complaint', 'name': '被投诉', 'count': 0}.obs,
  ].obs;
  RefreshController refreshCtr = RefreshController();
  @override
  void initState() {
    super.initState();
    getHomePanel();
  }

  ///获取统计数量
  getHomePanel() {
    RequestUtil.post(Api.getHomePanel, {'LoginId': loginId.value}).then((value) {
      if (value['Success']) {
        refreshCtr.refreshCompleted();
        Map data = value['rows'];
        for (var element in orderNum) {
          data.forEach((key, value) {
            if (element['key'] == key) {
              element['count'] = value;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SmartRefresher(
        controller: refreshCtr,
        onRefresh: () {
          getHomePanel();
        },
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //设置列数
              crossAxisCount: 2,
              //设置横向间距
              crossAxisSpacing: 10,
              //设置主轴间距
              mainAxisSpacing: 10,
              childAspectRatio: 2),
          scrollDirection: Axis.vertical,
          itemCount: orderNum.length,
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[400], width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderNum[index]['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Obx(() => Text(
                                      '${orderNum[index]['count']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'assets/upward.png',
                                width: 10,
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/histogram.png',
                      width: 35,
                      height: 35,
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
