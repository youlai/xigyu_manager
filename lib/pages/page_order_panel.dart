// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sdk_version_ui_as_code

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-04-24 13:24:31
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 工单面板
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/page_connection_quantity.dart';
import 'package:xigyu_manager/pages/page_end_rate.dart';
import 'package:xigyu_manager/pages/page_fee_rate.dart';
import 'package:xigyu_manager/pages/page_operating_quantity.dart';
import 'package:xigyu_manager/pages/page_total_rate.dart';
import 'package:xigyu_manager/utils/request_util.dart';

class OrderPanel extends StatefulWidget {
  const OrderPanel({Key? key}) : super(key: key);

  @override
  State<OrderPanel> createState() => _OrderPanelState();
}

class _OrderPanelState extends State<OrderPanel>
    with SingleTickerProviderStateMixin {
  RxList orderNum = [
    {'key': 'TackNum', 'name': '接单量', 'count': 0}.obs,
    {'key': 'Income', 'name': '我的收入', 'count': 0}.obs,
    {'key': 'LossNum', 'name': '已修好工单', 'count': 0}.obs,
    {'key': 'EndedNum', 'name': '完结工单', 'count': 0}.obs,
    {'key': 'AbolishNum', 'name': '废除工单', 'count': 0}.obs,
    {'key': 'ReplaceNum', 'name': '代师傅接单', 'count': 0}.obs,
    {'key': 'CustomAssignNum', 'name': '客服指派', 'count': 0}.obs,
    {'key': 'SysAssignNum', 'name': '系统指派', 'count': 0}.obs,
  ].obs;

  ///0 今日 1昨日 2本月
  RxInt selectTime = 0.obs;

  ///开始时间
  RxString addStartTime = ''.obs;

  ///结束时间
  RxString addEndTime = ''.obs;

  ///时间范围
  RxString dateTimeRange = ''.obs;

  ///操作组
  RxList groupList = [].obs;

  ///客服
  RxList customerList = [].obs;

  ///工厂
  RxList factoryList = [].obs;

  late TabController tabCtr;
  RefreshController refreshCtr = RefreshController();
  @override
  void initState() {
    super.initState();
    tabCtr = TabController(length: 8, vsync: this);
    getGroup();
    // getFactoryList();
    getToday();
  }

  ///获取今日
  getToday() {
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOrderPanelNum();
  }

  ///获取昨天
  getYesterday() {
    addStartTime.value = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    addEndTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOrderPanelNum();
  }

  ///获取本月
  getThisMonth() {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime(year, month));
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOrderPanelNum();
  }

  ///获取统计数量
  getOrderPanelNum() {
    RequestUtil.post(Api.getOrderPanelNum, {
      'LoginId': loginId.value,
      'GroupId': groupId.value,
      'ServiceId': serviceId.value,
      'FactoryId': factoryId.value,
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

  ///获取所属操作组
  getGroup() {
    RequestUtil.post(Api.getGroup, {'LoginId': loginId.value}).then((value) {
      if (value['Success']) {
        if (value['rows'] != null) {
          groupId.value = value['rows']['GroupId'];
          serviceId.value = value['rows']['Id'];
        }
        getServiceAccount();
        getGroupList();
      }
    });
  }

  ///获取操作组列表
  getGroupList() {
    RequestUtil.post(Api.getGroupList, {
      'LoginId': loginId.value,
      'Single': '1',
    }).then((value) {
      if (value['Success']) {
        groupList.value = value['rows'];
        groupList.insert(0, {'Id': -1, 'Name': '操作组'});
      }
    });
  }

  ///获取客服列表
  getServiceAccount() {
    RequestUtil.post(Api.getServiceAccount, {
      'LoginId': loginId.value,
      'GroupId': groupId.value,
    }).then((value) {
      if (value['Success']) {
        customerList.value = value['rows'];
        customerList.insert(0, {'AccountId': -1, 'UserName': '所属客服'});
      }
    });
  }

  ///获取工厂列表
  getFactoryList() {
    RequestUtil.post(Api.getFactoryList, {'LoginId': loginId.value})
        .then((value) {
      if (value['Success']) {
        factoryList.value = value['rows'];
        factoryList.insert(0, {'Id': -1, 'FactoryName': '所属工厂'});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            if (isAdmin.value)
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                                hint: Text('操作组'),
                                value: groupId.value,
                                isExpanded: true,
                                isDense: true,
                                items: groupList
                                    .map((element) => DropdownMenuItem(
                                        child: Text(element['Name'] ?? '--'),
                                        value: element['Id']))
                                    .toList(),
                                onChanged: (value) {
                                  groupId.value = value as int;
                                  getServiceAccount();
                                  getOrderPanelNum();
                                }),
                          )),
                    ),
                    Expanded(
                      child: Obx(() => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                                hint: Text('所属客服'),
                                value: serviceId.value,
                                isExpanded: true,
                                isDense: true,
                                items: customerList
                                    .map((element) => DropdownMenuItem(
                                        child: Text(
                                            '${element['UserName'] ?? '--'}' +
                                                (element['TrueName'] != null
                                                    ? '(${element['TrueName']})'
                                                    : '')),
                                        value: element['AccountId']))
                                    .toList(),
                                onChanged: (value) {
                                  serviceId.value = value as int;
                                  getOrderPanelNum();
                                }),
                          )),
                    ),
                    // Expanded(
                    //   child: Obx(() => Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: DropdownButton(
                    //             hint: Text('所属工厂'),
                    //             value: factoryId.value,
                    //             isExpanded: true,
                    //             isDense: true,
                    //             items: factoryList
                    //                 .map((element) => DropdownMenuItem(
                    //                     child: Text(
                    //                         element['FactoryName'] ?? '--'),
                    //                     value: element['Id']))
                    //                 .toList(),
                    //             onChanged: (value) {
                    //               factoryId.value = value as int;
                    //               getOrderPanelNum();
                    //             }),
                    //       )),
                    // ),
                  ],
                ),
              ),
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
                          text: '快捷操作',
                        ),
                        Tab(
                          text: '费用申请率',
                        ),
                        Tab(
                          text: '留存率',
                        ),
                        Tab(
                          text: '完结时效率',
                        ),
                        Tab(
                          text: '工单操作量',
                        ),
                        Tab(
                          text: '用户联系量',
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
              QuickOperation(),
              FeeRate(),
              TotalRate(),
              EndRate(),
              OperatingQuantity(),
              ConnectionQuantity(),
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
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey[400]!, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              selectTime.value = 0;
                              getToday();
                            },
                            child: Obx(() => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: selectTime.value == 0
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5))),
                                child: Text(
                                  '今日',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectTime.value == 0
                                          ? Colors.white
                                          : Colors.black),
                                ))),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              selectTime.value = 1;
                              getYesterday();
                            },
                            child: Obx(() => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: selectTime.value == 1
                                        ? Colors.blue
                                        : Colors.white,
                                    border: Border.symmetric(
                                        vertical: BorderSide(
                                            color: Colors.grey[400]!,
                                            width: 0.5))),
                                child: Text(
                                  '昨日',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectTime.value == 1
                                          ? Colors.white
                                          : Colors.black),
                                ))),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              selectTime.value = 2;
                              getThisMonth();
                            },
                            child: Obx(() => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: selectTime.value == 2
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Text(
                                  '本月',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectTime.value == 2
                                          ? Colors.white
                                          : Colors.black),
                                ))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      DateTimeRange? timeRange = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2017, 9, 7, 17, 30),
                          lastDate: DateTime.now());
                      if (timeRange == null) return;
                      selectTime.value = -1;
                      debugPrint(timeRange.toString());
                      addStartTime.value =
                          DateFormat('yyyy-MM-dd').format(timeRange.start);
                      addEndTime.value =
                          DateFormat('yyyy-MM-dd').format(timeRange.end);
                      dateTimeRange.value =
                          '${addStartTime.value}~${addEndTime.value}';
                      getOrderPanelNum();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      // width: 210,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey[400]!, width: 0.5),
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
                          Expanded(
                            child: Obx(() => Text(dateTimeRange.value,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12))),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Icon(
                          //     Icons.keyboard_arrow_down,
                          //     size: 15,
                          //     color: Colors.grey,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                              Border.all(color: Colors.grey[400]!, width: 0.5),
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
  const UrgentTreatment({Key? key}) : super(key: key);

  @override
  State<UrgentTreatment> createState() => _UrgentTreatmentState();
}

class _UrgentTreatmentState extends State<UrgentTreatment> {
  RxList orderNum = [
    {
      'key': 'DayReminderNum',
      'name': '今日催单',
      'count': 0,
      'ycount': 0,
    }.obs,
    {'key': 'MuchReminderNum', 'name': '多次被催', 'count': 0, 'ycount': 0}.obs,
    // {'key': 'ExceptionNum', 'name': '异常工单', 'count': 0,'ycount': 0}.obs,
    {'key': 'OverTimeNum', 'name': '超七工单', 'count': 0, 'ycount': 0}.obs,
    {'key': 'CheckRejectNum', 'name': '审核驳回', 'count': 0, 'ycount': 0}.obs,
    {'key': 'MuchBackNum', 'name': '多日未回访', 'count': 0, 'ycount': 0}.obs,
    {'key': 'DoorDayNum', 'name': '今日需上门', 'count': 0, 'ycount': 0}.obs,
    {'key': 'DoorTomorrowNum', 'name': '明日需上门', 'count': 0, 'ycount': 0}.obs,
    {'key': 'OutTimeNum', 'name': '超时未上门', 'count': 0, 'ycount': 0}.obs,
    {'key': 'PartsHandleNum', 'name': '配件需处理', 'count': 0, 'ycount': 0}.obs,
    {'key': 'CostHandleNum', 'name': '费用需处理', 'count': 0, 'ycount': 0}.obs,
    {'key': 'RefuseNum', 'name': '工单被拒接', 'count': 0, 'ycount': 0}.obs,
    {'key': 'RepairNum', 'name': '工单需返修', 'count': 0, 'ycount': 0}.obs,
    {'key': 'ProductNum', 'name': '已到货', 'count': 0, 'ycount': 0}.obs,
    {'key': 'AnomalyNum', 'name': '异常工单', 'count': 0, 'ycount': 0}.obs,
    {'key': 'StayNum', 'name': '滞留工单', 'count': 0, 'ycount': 0}.obs,
    {'key': 'MoreThreeNum', 'name': '超3天工单', 'count': 0, 'ycount': 0}.obs,
    {'key': 'MoreFiveNum', 'name': '超5天工单', 'count': 0, 'ycount': 0}.obs,
    {'key': 'MoreSevenNum', 'name': '超7天工单', 'count': 0, 'ycount': 0}.obs,
    {'key': 'MoreFifteenNum', 'name': '超15天工单', 'count': 0, 'ycount': 0}.obs,
    {'key': 'MoreThirtyNum', 'name': '超30天工单', 'count': 0, 'ycount': 0}.obs,
  ].obs;
  RefreshController refreshCtr = RefreshController();
  @override
  void initState() {
    super.initState();
    groupId.listen((p0) {
      debugPrint('$p0');
      getDealwithPanelNum();
    });
    serviceId.listen((p0) {
      debugPrint('$p0');
      getDealwithPanelNum();
    });
    factoryId.listen((p0) {
      debugPrint('$p0');
      getDealwithPanelNum();
    });
    getDealwithPanelNum();
  }

  ///获取统计数量
  getDealwithPanelNum() {
    RequestUtil.post(Api.getDealwithPanelNum, {
      'LoginId': loginId.value,
      'GroupId': groupId.value,
      'ServiceId': serviceId.value,
      'FactoryId': factoryId.value,
    }).then((value) {
      if (value['Success']) {
        Map data = value['rows'];
        RequestUtil.post(Api.dealwithPanelGetNum, {
          'LoginId': loginId.value,
          'GroupId': groupId.value,
          'ServiceId': serviceId.value,
          'FactoryId': factoryId.value,
        }).then((value) {
          if (value['Success']) {
            refreshCtr.refreshCompleted();
            Map ydata = value['rows'];
            for (var element in orderNum) {
              data.forEach((key, value) {
                if (element['key'] == key) {
                  element['count'] = value;
                }
              });
              ydata.forEach((key, value) {
                if (element['key'] == key) {
                  element['ycount'] = value;
                }
              });
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SmartRefresher(
        controller: refreshCtr,
        onRefresh: () {
          getDealwithPanelNum();
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
                    border: Border.all(color: Colors.grey[400]!, width: 0.5),
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
                                child: Obx(() => Row(
                                      children: [
                                        Text(
                                          '${orderNum[index]['count']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          '/${orderNum[index]['ycount']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.red),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Obx(() => Image.asset(
                                    orderNum[index]['count'] >
                                            orderNum[index]['ycount']
                                        ? 'assets/upward.png'
                                        : 'assets/down.png',
                                    width: 10,
                                    height: 10,
                                  )),
                              Obx(() => Text(
                                    '${orderNum[index]['count'] - orderNum[index]['ycount']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: orderNum[index]['count'] >
                                                orderNum[index]['ycount']
                                            ? Colors.green
                                            : Colors.red),
                                  )),
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

///快捷操作
class QuickOperation extends StatefulWidget {
  const QuickOperation({Key? key}) : super(key: key);

  @override
  State<QuickOperation> createState() => _QuickOperationState();
}

class _QuickOperationState extends State<QuickOperation> {
  RefreshController refreshCtr = RefreshController();
  @override
  void initState() {
    super.initState();
    groupId.listen((p0) {
      debugPrint('$p0');
      getOperatePanelNum();
    });
    serviceId.listen((p0) {
      debugPrint('$p0');
      getOperatePanelNum();
    });
    factoryId.listen((p0) {
      debugPrint('$p0');
      getOperatePanelNum();
    });
    getOperatePanelNum();
  }

  ///获取统计数量
  getOperatePanelNum() {
    RequestUtil.post(Api.getOperatePanelNum, {
      'LoginId': loginId.value,
      'GroupId': groupId.value,
      'ServiceId': serviceId.value,
      'FactoryId': factoryId.value,
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
    return Obx(
      () => SmartRefresher(
        controller: refreshCtr,
        onRefresh: () {
          getOperatePanelNum();
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
          itemCount: orderNum.length - 1,
          itemBuilder: (context, index) {
            return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[400]!, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderNum[index + 1]['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Obx(() => Text(
                                      '${orderNum[index + 1]['count']}',
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
