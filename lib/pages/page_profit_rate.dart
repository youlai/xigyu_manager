// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, sdk_version_ui_as_code

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-05-20 16:53:12
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 客服利润率
 */
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/utils/request_util.dart';

class ProfitRate extends StatefulWidget {
  ///0有取消按钮 1无取消按钮
  int type;
  ProfitRate({Key? key, this.type = 0}) : super(key: key);

  @override
  State<ProfitRate> createState() => _ProfitRateState();
}

class _ProfitRateState extends State<ProfitRate> {
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
    getProfitAdminRate();
  }

  ///获取昨天
  getYesterday() {
    addStartTime.value = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    addEndTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getProfitAdminRate();
  }

  ///获取本月
  getThisMonth() {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime(year, month));
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getProfitAdminRate();
  }

  ///获取工厂账号
  getProfitAdminRate() {
    RequestUtil.post(Api.profitAdminRate, {
      'LoginId': loginId.value,
      'CustomerId': serviceId.value,
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
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: false,
      onRefresh: () {
        getProfitAdminRate();
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
                      getProfitAdminRate();
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
            child: Obx(() => accountList.isEmpty
                ? Center(child: Text('暂无数据'))
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: ((context, index) => Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${accountList[index]['CustomerName']}'),
                              Text('总流水：¥${accountList[index]['Amount']}'),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          '总单数：${accountList[index]['Num']}单')),
                                  Text(
                                      '公司总利润：¥${accountList[index]['TotalProfitAmount']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          '客服利润单数：${accountList[index]['ProfitNum']}单')),
                                  Text(
                                      '客服总利润：¥${accountList[index]['ProfitAmount']}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          '客服亏损单数：${accountList[index]['LossNum']}单')),
                                  Text(
                                      '客服总亏损：¥${accountList[index]['LossAmount']}'),
                                ],
                              ),
                            ],
                          ),
                        ))),
                    itemCount: accountList.length)),
          ),
        ],
      ),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 28,
        maxY: 4,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }
    print('$value');
    return Text('text', style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        // getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        // interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.normal,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }
    print('bottomTitleWidgets:$value');
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      angle: 0,
      child:
          Text('${accountList[value.toInt()]['CustomerName']}', style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 64,
        // interval: 2,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 2),
          left: BorderSide(color: Color(0xff4e4965), width: 2),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff4af699),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0xffaa4cfc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: const Color(0x00aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff27b6fc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color(0x444af699),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0x99aa4cfc),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x33aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color(0x4427b6fc),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}
