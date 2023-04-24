// ignore_for_file: sdk_version_ui_as_code, use_key_in_widget_constructors

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/page_order_detail.dart';
import 'package:xigyu_manager/utils/utils.dart';
import 'package:xigyu_manager/widgets/jh_login_textfield.dart';

import '../../utils/request_util.dart';
import "package:collection/collection.dart";

///工单搜索页面

class SearchOrderPage extends StatefulWidget {
  @override
  _SearchOrderPageState createState() => _SearchOrderPageState();
}

class _SearchOrderPageState extends State<SearchOrderPage>
    with AutomaticKeepAliveClientMixin {
  var page = 1;
  var rows = 10;
  String search = '';
  TextEditingController searchCtr = TextEditingController();
  RxList<Map> orderList = <Map>[].obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    var params = {
      'LoginId': loginId.value,
      'OrderNumber': search,
      'State': '-1',
      'Page': page,
      'Rows': rows,
      'Order': 'desc',
      'CategoryId': '-1',
      'ProductId': '-1',
      'ProductTypeId': '-1',
      'Tab': '-1',
      'FactoryId': '-1',
      'IsDoor': '-1',
      'GroupId': '-1',
      'CustomerId': serviceId.value,
      'StateId': '-1',
      'TypeId': '-1',
      'PaoneId': '-1',
    };
    RequestUtil.post(Api.getPageList, params).then((value) {
      if (value['Success']) {
        refreshController.loadComplete();
        refreshController.refreshCompleted();
        List<Map> list = (value['rows']['List'] as List).cast<Map>();
        list.forEach((order) {
          List sortProduct = (order['SortProduct'] as String).split(',');
          Map map = groupBy(sortProduct, (e) => e);
          var str = '';
          map.forEach((key, value) {
            str += (value[0] as String)
                    .substring(0, (value[0] as String).length - 3) +
                'x${value.length},';
          });
          if (str.contains(',')) {
            str = str.substring(0, str.lastIndexOf(','));
            order['SortProduct'] = str;
          }
          print(str);
        });
        if (page == 1) {
          orderList.value = list;
        } else {
          if (list.length > 0) {
            orderList.addAll(list);
          } else {
            refreshController.loadNoData();
          }
        }
      } else {
        showToast(value['msg']);
      }
    });
  }

  @override
  void dispose() {
    print('dispose');
    refreshController.dispose();
    super.dispose();
  }

  void onRefresh() {
    page = 1;
    refreshController.resetNoData();
    fetchData();
  }

  void onLoading() {
    page++;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //必须实现 不然 在push过后页面会刷新
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          title: Container(
            margin: EdgeInsets.only(left: 10),
//            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: new BoxDecoration(
//              border: Border.all(color: Colors.white, width: 1.0), //灰色的一层边框
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            alignment: Alignment.center,
            height: 38,
//           padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: JhLoginTextField(
              controller: searchCtr,
//              leftWidget: Icon(Icons.search,size: 25,),
              hintText: '工单号、客户手机号、客户姓名、地址',
              isShowDeleteBtn: true,
              isDense: true,
              textInputAction: TextInputAction.search,
              border: OutlineInputBorder(
                  /*边角*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  borderSide: BorderSide(
                    color: Colors.grey, //边线颜色
                    width: 0.2, //边线宽度
                  )),
              inputCallBack: (keyword) {
                search = keyword;
              },
              onEditingComplete: () {
                page = 1;
                refreshController.resetNoData();
                fetchData();
              },
            ),
          ),
          titleSpacing: 0,
          actions: [
            TextButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          automaticallyImplyLeading: false, //隐藏返回箭头
//          leading: IconButton(
//            icon: Icon(Icons.arrow_back_ios, color: Colors.white), //自定义图标
//            onPressed: () {
//              Navigator.pop(context);
//            },
//          ),
          elevation: 0.1,
//          brightness: Brightness.light,
        ),
        body: Container(
          color: Color(0xffF2F2F2),
          // padding: EdgeInsets.only(top: 10),
          child: Obx(() => orderList.length == 0
              ? buildSmartRefresher(buildEmptyContainer())
              : buildSmartRefresher(ListView.builder(
                  itemBuilder: (context, i) {
                    return buildOrderItem(context, orderList[i], i);
                  },
                  itemCount: orderList.length,
                ))),
        ));
  }

  ///@order
  ///
  ///    *         {
  ///    *            "Id": 17,
  ///    *            "OrderNumber": "221116353611",
  ///    *            "TypeId": 0,
  ///    *            "TypeName": "安装",
  ///    *            "PaoneId": 0,
  ///    *            "PaoneName": "保内",
  ///    *            "OriginId": 0,
  ///    *            "OriginName": "线下",
  ///    *            "UserName": "小小怪",
  ///    *            "Phone": "15233623365",
  ///    *            "ProvinceName": "北京市",
  ///    *            "CityName": "北京市",
  ///    *            "AreaName": "东城区",
  ///    *            "Address": "炉房花苑",
  ///    *            "FullAddress": "北京市北京市东城区炉房花苑",
  ///    *            "Longitude": "116.398964",
  ///    *            "Dimension": "39.937798",
  ///    *            "FactoryId": 1,
  ///    *            "FactoryUserId": "16623392336",
  ///    *            "FactoryName": "2345科技有限公司",
  ///    *            "Product": "小米_冷柜_冷柜_E87-f",
  ///    *            "Amount": 21.0,
  ///    *            "FactoryAmount": 21.0,
  ///    *            "FactoryFrozenAmount": 21.0,
  ///    *            "MasterAmount": 5.0,
  ///    *            "MasterFrozenAmount": 5.0,
  ///    *            "ThirdNumber": "32643365659",
  ///    *            "ShopName": "xiaodain1",
  ///    *            "AddTime": "2022-11-16 16:20:08",
  ///    *            "State": 5,
  ///    *            "StateName": "服务中",
  ///    *            "PartsState": 0,
  ///    *            "PartsStateName": "待申请",
  ///    *            "PartsAllSatte": 0,
  ///    *            "PartsAllSatteName": "待申请",
  ///    *            "CustomerId": 89,
  ///    *            "CustomerUserId": "82202258",
  ///    *            "CustomerName": "灰心超人",
  ///    *            "CustomerTime": "2022-11-17 10:23:21",
  ///    *            "GroupId": 2,
  ///    *            "GroupName": "测试2",
  ///    *            "MasterId": 20,
  ///    *            "MasterUserId": "xx",
  ///    *            "MasterName": "fffff",
  ///    *            "MasterAssignTime": "2022-11-17 10:23:31",
  ///    *            "TackInvalidTime": "2022-11-24 13:40:21",
  ///    *            "TackTime": "2022-11-17 13:39:00",
  ///    *            "RefuseTime": null,
  ///    *            "RefuseMsg": null,
  ///    *            "AppointmentTime": "2022-11-17 13:39:22",
  ///    *            "AppointExpectTime": "2022-11-23 09:00:00",
  ///    *            "IsApoint": 0,
  ///    *            "AppointmentNum": 1,
  ///    *            "CheckTime": "2022-11-17 13:40:21",
  ///    *            "CheckNum": 1,
  ///    *            "IsDoor": 1,
  ///    *            "IsPartCheck": 0,
  ///    *            "IsPartDeliver": 0,
  ///    *            "IsPartSign": 0,
  ///    *            "IsPartChecked": 0,
  ///    *            "IsPartCancel": 0,
  ///    *            "IsFeeCheck": 0,
  ///    *            "IsFeeChecked": 0,
  ///    *            "IsFeeCancel": 0,
  ///    *            "IsPartBack": 0,
  ///    *            "IsPartBackCheck": 0,
  ///    *            "IsPartBackChecked": 0,
  ///    *            "PartsTime": null,
  ///    *            "PartsCheckTime": null,
  ///    *            "PartsDeliverTime": null,
  ///    *            "PartsCheckedTime": null,
  ///    *            "PartsBackTime": null,
  ///    *            "PartsBackCheckTime": null,
  ///    *            "CommitTime": null,
  ///    *            "CommitNum": 0,
  ///    *            "CommitEndTime": null,
  ///    *            "CommitEndNum": 0,
  ///    *            "CommitAbolishTime": null,
  ///    *            "CommitAbolishNum": 0,
  ///    *            "BeforeExamineState": -1,
  ///    *            "BeforeExamineStateName": null,
  ///    *            "CommitCancelTime": null,
  ///    *            "CommitCancelNum": 0,
  ///    *            "BeforeCancelState": -1,
  ///    *            "BeforeCancelStateName": null,
  ///    *            "ExamineTime": null,
  ///    *            "EndTime": null,
  ///    *            "BackTime": null,
  ///    *            "LastLeveMessage": null,
  ///    *            "LastLeveMessageTime": null,
  ///    *            "LastRecordMessage": "师傅：xx(fffff)，已上门服务",
  ///    *            "LastRecordMessageTime": "2022-11-17 13:40:21",
  ///    *            "NextFollowTime": null,
  ///    *            "FollowNum": 0,
  ///    *            "LastLeveMessageUser": null,
  ///    *            "IsPartCheckTime": null,
  ///    *            "IsPartDeliverTime": null,
  ///    *            "IsPartSignTime": null,
  ///    *            "IsPartCheckedTime": null,
  ///    *            "IsPartCancelTime": null,
  ///    *            "IsFeeCheckTime": null,
  ///    *            "IsFeeCheckedTime": null,
  ///    *            "IsFeeCancelTime": null,
  ///    *            "IsPartBackTime": null,
  ///    *            "IsPartBackCheckTime": null,
  ///    *            "IsPartBackCheckedTime": null,
  ///    *            "Requirements": "平台费1",
  ///    *            "ReminderNum": 0,
  ///    *            "Memo": null,
  ///    *            "IsOperation": 0,
  ///    *            "IsEnd": 0,
  ///    *            "IsEndName": null,
  ///    *            "TackNum": "674075"
  ///    *          },
  GestureDetector buildOrderItem(BuildContext context, order, i) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        var result = await pushTo(context, OrderDetailB(order['OrderNumber']));
        if (result != null) {}
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 8, right: 8, bottom: 8, top: i == 0 ? 10 : 0),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
//            border: Border.all(color: Colors.grey[300]),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('工单号：${order['OrderNumber']}')),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        copyOrderInfo(order);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/copy.png',
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            '复制工单',
                            style: TextStyle(color: mainColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: List.generate(
                        2,
                        (index) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 3),
                            decoration: BoxDecoration(
                                color: index == 0
                                    ? (order['PaoneId'] == 0
                                        ? mainColor
                                        : Colors.red)
                                    : Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: Text(
                              index == 0
                                  ? order['PaoneName'] + order['TypeName']
                                  : order['StateName'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ))),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
//                  CachedNetworkImage(
//                    imageUrl:
//                        'https://xigyubuckettest.oss-cn-hangzhou.aliyuncs.com/TemporaryArea/APP/EndPic/2000020152/0dd561d0-cf0b-11eb-b19b-4525a4e24175.jpg',
//                    width: 60,
//                    height: 60,
//                    fit: BoxFit.cover,
//                  ),
//                  SizedBox(
//                    width: 5,
//                  ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order['SortProduct'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            if (order['TypeId'] == 1)
                              Text('故障描述:${order['Memo'] ?? '暂无'}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey)),
                            if (order['TypeId'] != 1)
                              Text('服务要求:${order['Memo'] ?? '暂无'}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
//                  Image.asset(
//                    'assets/location.png',
//                    width: 20,
//                    height: 20,
//                  ),
                      Expanded(
                        child: Text(
                          '${order['UserName'] + '    ' + order['Phone'] + '\n' + order['FullAddress']}',
                          style: TextStyle(color: mainColor),
                        ),
                      ),
                    ],
                  ),
                ),
//            buildButton(order),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/time.png',
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${TimelineUtil.formatByDateTime(DateTime.parse(order['AddTime']), locale: 'zh', dayFormat: DayFormat.Full)}',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/touxiang.png',
                              width: 15,
                              height: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(order['Customer'] ?? '--',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/touxiang.png',
                                width: 15,
                                height: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(order['MasterName'] ?? '--',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // if (order['IsMasterHead'] == 1)
          //   Positioned(
          //       left: 8,
          //       top: i == 0 ? 10 : 0,
          //       child: Image.asset(
          //         'assets/zhiding.png',
          //         width: 30,
          //         height: 30,
          //       ))
        ],
      ),
    );
  }

  ///复制工单信息
  void copyOrderInfo(order) {
    String copyText = "工单号：" +
        order['OrderNumber'] +
        "\n" +
        "下单时间：" +
        order['AddTime'] +
        "\n" +
        "用户信息：" +
        order['UserName'] +
        " " +
        order['Phone'] +
        "\n" +
        "用户地址：" +
        order['FullAddress'] +
        "\n" +
        "产品信息：" +
        order['SortProduct'] +
        "\n" +
        "售后类型：" +
        order['PaoneName'] +
        "\n" +
        "服务类型：" +
        order['TypeName'];
    //复制
    Clipboard.setData(ClipboardData(text: copyText));
    showToast('复制成功');
  }

  Container buildEmptyContainer() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/v3_nodata.png',
              width: 100,
              height: 100,
            ),
            Text(
              '暂无工单',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  SmartRefresher buildSmartRefresher(Widget child) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: orderList.length != 0,
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
