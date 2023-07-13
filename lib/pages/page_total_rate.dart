// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, sdk_version_ui_as_code

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-05-20 16:53:12
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 留存率
 */
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/utils/request_util.dart';

class TotalRate extends StatefulWidget {
  ///0有取消按钮 1无取消按钮
  int type;
  TotalRate({Key? key, this.type = 0}) : super(key: key);

  @override
  State<TotalRate> createState() => _TotalRateState();
}

class _TotalRateState extends State<TotalRate> {
  RxList accountList = [].obs;
  RefreshController refreshController = RefreshController();

  ///开始时间
  RxString addStartTime = ''.obs;

  ///结束时间
  RxString addEndTime = ''.obs;

  ///0 今日 1昨日 2本月
  RxInt selectTime = 0.obs;

  // RxString addStartTime = ''.obs;
  // RxString addEndTime = ''.obs;
  RxString dateTimeRange = ''.obs;

  Rx<LineChartData> data = LineChartData().obs;
  @override
  void initState() {
    super.initState();
    getToday();
  }

  ///获取今日
  getToday() {
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getTotalRate();
  }

  ///获取昨天
  getYesterday() {
    addStartTime.value = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    addEndTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getTotalRate();
  }

  ///获取本月
  getThisMonth() {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime(year, month));
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getTotalRate();
  }

  ///获取工厂账号
  getTotalRate() {
    RequestUtil.post(Api.totalRate, {
      'LoginId': loginId.value,
      'AddStartTime': addStartTime.value,
      'AddEndTime': addEndTime.value
    }).then((value) {
      if (value['Success']) {
        // accountList.value = [];
        refreshController.refreshCompleted();
        List list = value['rows'];
        accountList.value = list;
        // List<LineChartBarData> lineBarsData = List.generate(3, (index) {
        //   LineChartBarData lineChartBarData;
        //   switch (index) {
        //     case 0:
        //       lineChartBarData = LineChartBarData(
        //         isCurved: false,
        //         color: const Color(0xff4af699),
        //         barWidth: 2,
        //         isStrokeCapRound: true,
        //         dotData: FlDotData(show: true),
        //         belowBarData: BarAreaData(show: false),
        //         spots: List.generate(
        //             list.length,
        //             (index) => FlSpot(
        //                 index.toDouble(), list[index]['Num'].toDouble())),
        //       );
        //       break;
        //     case 1:
        //       lineChartBarData = LineChartBarData(
        //         isCurved: false,
        //         color: Colors.blue,
        //         barWidth: 2,
        //         isStrokeCapRound: true,
        //         dotData: FlDotData(show: true),
        //         belowBarData: BarAreaData(show: false),
        //         spots: List.generate(
        //             list.length,
        //             (index) => FlSpot(index.toDouble(),
        //                 list[index]['ProfitAmount'].toDouble())),
        //       );
        //       break;
        //     case 2:
        //       lineChartBarData = LineChartBarData(
        //         isCurved: false,
        //         color: Color.fromARGB(255, 63, 83, 72),
        //         barWidth: 2,
        //         isStrokeCapRound: true,
        //         dotData: FlDotData(show: true),
        //         belowBarData: BarAreaData(show: false),
        //         spots: List.generate(
        //             list.length,
        //             (index) => FlSpot(index.toDouble(),
        //                 list[index]['TotalProfitAmount'].toDouble())),
        //       );
        //       break;
        //     default:
        //       lineChartBarData = LineChartBarData(
        //         isCurved: true,
        //         color: const Color(0xff4af699),
        //         barWidth: 2,
        //         isStrokeCapRound: true,
        //         dotData: FlDotData(show: false),
        //         belowBarData: BarAreaData(show: false),
        //         spots: List.generate(list.length,
        //             (index) => FlSpot(index.toDouble(), list[index]['Num'])),
        //       );
        //       break;
        //   }
        //   return lineChartBarData;
        // });
        // data.value = sampleData2;
        // data.value = LineChartData(
        //   lineTouchData: lineTouchData1,
        //   gridData: gridData,
        //   titlesData: titlesData1,
        //   borderData: borderData,
        //   lineBarsData: lineBarsData,
        //   // minX: 0,
        //   // maxX: list.length.toDouble(),
        //   // maxY: 4,
        //   // minY: 0,
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => accountList.isEmpty
        ? Center(child: Text('暂无数据'))
        : SmartRefresher(
            controller: refreshController,
            enablePullUp: false,
            onRefresh: () {
              getTotalRate();
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
                              border: Border.all(
                                  color: Colors.grey[400]!, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
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
                            DateTimeRange? timeRange =
                                await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2017, 9, 7, 17, 30),
                                    lastDate: DateTime.now());
                            if (timeRange == null) return;
                            selectTime.value = -1;
                            debugPrint(timeRange.toString());
                            addStartTime.value = DateFormat('yyyy-MM-dd')
                                .format(timeRange.start);
                            addEndTime.value =
                                DateFormat('yyyy-MM-dd').format(timeRange.end);
                            dateTimeRange.value =
                                '${addStartTime.value}~${addEndTime.value}';
                            getTotalRate();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            // width: 210,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey[400]!, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
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
                  child: Obx(() => ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: ((context, index) {
                        var item = accountList[index];
                        return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${item['CustomerName']}'),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('总单量：${item['Num']}')),
                                      Expanded(
                                          child: Text(
                                              '待废除：${item['WaitFailNum']}')),
                                      Expanded(
                                          child:
                                              Text('已废除：${item['FailNum']}')),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child:
                                              Text('有效量：${item['ValidNum']}')),
                                      Expanded(
                                          child: Text('日均：${item['DayNum']}')),
                                      Expanded(
                                          child:
                                              Text('废除率：${item['FailRate']}')),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '未指派：${item['UnAssignNum']}')),
                                      Expanded(
                                          child:
                                              Text('待接单：${item['TackNum']}')),
                                      Expanded(
                                          child: Text(
                                              '未预约：${item['UnApointNum']}')),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child:
                                              Text('待上门：${item['DoorNum']}')),
                                      Expanded(
                                          child: Text(
                                              '服务中：${item['ServiceNum']}')),
                                      Expanded(
                                          child:
                                              Text('总量：${item['UnEndNum']}')),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '待返件：${item['WaitBackNum']}')),
                                      Expanded(
                                          child:
                                              Text('留存率：${item['KeepRate']}')),
                                      Expanded(
                                          child:
                                              Text('完结率：${item['EndRate']}')),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      }),
                      itemCount: accountList.length)),
                ),
              ],
            ),
          ));
  }
}
