// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, sdk_version_ui_as_code

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-05-20 16:53:12
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 工单操作量
 */
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/chart_demo.dart';
import 'package:xigyu_manager/utils/request_util.dart';

class OperatingQuantity extends StatefulWidget {
  ///0有取消按钮 1无取消按钮
  int type;
  OperatingQuantity({Key? key, this.type = 0}) : super(key: key);

  @override
  State<OperatingQuantity> createState() => _OperatingQuantityState();
}

class _OperatingQuantityState extends State<OperatingQuantity> {
  RxList<Map> accountList = <Map>[].obs;
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
    getOperatingQuantity();
  }

  ///获取昨天
  getYesterday() {
    addStartTime.value = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    addEndTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOperatingQuantity();
  }

  ///获取本月
  getThisMonth() {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime(year, month));
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getOperatingQuantity();
  }

  ///获取工厂账号
  getOperatingQuantity() {
    RequestUtil.post(Api.getNum, {
      'LoginId': loginId.value,
      'AddStartTime': addStartTime.value,
      'AddEndTime': addEndTime.value
    }).then((value) {
      if (value['Success']) {
        // accountList.value = [];
        refreshController.refreshCompleted();
        List<Map> list = value['rows'].cast<Map>();
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
              getOperatingQuantity();
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
                            getOperatingQuantity();
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
                Obx(() => Container(
                      height: 300,
                      child: _buildDefaultLineChart(),
                    )),
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
                                  Text('${item['AccountName']}'),
                                  Row(
                                    children: [
                                      Expanded(
                                          child:
                                              Text('操作量：${item['RecordNum']}')),
                                      Expanded(
                                          child:
                                              Text('浏览量：${item['BrowseNum']}')),
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

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      // title: ChartTitle(text: '工单操作量'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
          // labelFormat: '{value}%',
          axisLine: AxisLine(width: 1),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: _getDefaultLineSeries(),
      zoomPanBehavior: ZoomPanBehavior(
          enableDoubleTapZooming: true,
          enablePinching: true,
          enableMouseWheelZooming: true,
          enableSelectionZooming: true,
          enablePanning: true),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<Map, String>> _getDefaultLineSeries() {
    return <LineSeries<Map, String>>[
      LineSeries<Map, String>(
          animationDuration: 2500,
          dataSource: accountList.value,
          xValueMapper: (Map item, _) => item['AccountName'],
          yValueMapper: (Map item, _) => item['BrowseNum'],
          width: 2,
          name: '浏览量',
          markerSettings: MarkerSettings(isVisible: false)),
      LineSeries<Map, String>(
          animationDuration: 2500,
          dataSource: accountList.value,
          width: 2,
          name: '操作量',
          xValueMapper: (Map item, _) => item['AccountName'],
          yValueMapper: (Map item, _) => item['RecordNum'],
          markerSettings: MarkerSettings(isVisible: false))
    ];
  }
}
