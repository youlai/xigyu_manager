// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, sdk_version_ui_as_code

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-05-20 16:53:12
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/utils/request_util.dart';

class FactoryOrderNum extends StatefulWidget {
  ///0有取消按钮 1无取消按钮
  int type;
  FactoryOrderNum({Key? key, this.type = 0}) : super(key: key);

  @override
  State<FactoryOrderNum> createState() => _FactoryOrderNumState();
}

class _FactoryOrderNumState extends State<FactoryOrderNum> {
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
    getFactoryOrderNum();
  }

  ///获取昨天
  getYesterday() {
    addStartTime.value = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    addEndTime.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getFactoryOrderNum();
  }

  ///获取本月
  getThisMonth() {
    var year = DateTime.now().year;
    var month = DateTime.now().month;
    addStartTime.value = DateFormat('yyyy-MM-dd').format(DateTime(year, month));
    addEndTime.value =
        DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1));
    dateTimeRange.value = '${addStartTime.value}~${addEndTime.value}';
    getFactoryOrderNum();
  }

  ///获取工厂账号
  getFactoryOrderNum() {
    RequestUtil.post(Api.getFactoryOrderNum, {
      'LoginId': loginId.value,
      'StartTime': addStartTime.value,
      'EndTime': addEndTime.value
    }).then((value) {
      if (value['Success']) {
        // accountList.value = [];
        refreshController.refreshCompleted();
        List list = value['rows']['Today'];
        accountList.value = list;
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
              getFactoryOrderNum();
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
                            getFactoryOrderNum();
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
                      itemBuilder: ((context, index) => Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                    child:
                                        Text('${accountList[index]['Name']}')),
                                Text('${accountList[index]['Num']}'),
                              ],
                            ),
                          ))),
                      itemCount: accountList.length)),
                ),
              ],
            ),
          ));
  }
}
