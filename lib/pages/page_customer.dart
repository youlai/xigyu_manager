// ignore_for_file: sdk_version_ui_as_code, use_key_in_widget_constructors, must_be_immutable

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/page_order_detail.dart';
import 'package:xigyu_manager/utils/utils.dart';
import 'package:xigyu_manager/widgets/jh_login_textfield.dart';
import 'package:xigyu_manager/widgets/rating_bar.dart';

import '../../utils/request_util.dart';
import "package:collection/collection.dart";

///指派客服页面

class CustomerPage extends StatefulWidget {
  var orderId;
  var orderNumber;
  CustomerPage({this.orderId, this.orderNumber});
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage>
    with AutomaticKeepAliveClientMixin {
  var page = 1;
  var rows = 10;

  ///0 同区域客服 1跨区域客服
  RxInt selectType = 0.obs;
  String search = '';
  TextEditingController searchCtr = TextEditingController();
  RxList<Map> customerList = <Map>[].obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// LoginId: Cyl
// OrderNum: 230419766027
// UserName
// IsArea: 1跨区域 0同区域
// Page: 1
// limit: 10
  void fetchData() {
    var params = {
      'LoginId': loginId.value,
      'OrderNum': widget.orderNumber,
      'UserName': search,
      'limit': rows,
      'Page': page,
      'IsArea': selectType.value
    };
    RequestUtil.post(Api.getOrderAreaList, params).then((value) {
      if (value['Success']) {
        refreshController.loadComplete();
        refreshController.refreshCompleted();
        List<Map> list = (value['rows']['rows'] as List).cast<Map>();
        if (page == 1) {
          customerList.value = list;
        } else {
          if (list.length > 0) {
            customerList.addAll(list);
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
              hintText: '请输入姓名',
              isShowDeleteBtn: true,
              isDense: true,
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
          padding: EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      selectType.value = 0;
                      page = 1;
                      fetchData();
                    },
                    child: Obx(() => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: selectType.value == 0
                                ? Colors.blue
                                : Colors.blue[200],
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          '同区域客服',
                          style: TextStyle(color: Colors.white),
                        ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.swap_horiz,
                      size: 25,
                      color: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      selectType.value = 1;
                      page = 1;
                      fetchData();
                    },
                    child: Obx(() => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: selectType.value == 1
                                ? Colors.blue
                                : Colors.blue[200],
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          '跨区域客服',
                          style: TextStyle(color: Colors.white),
                        ))),
                  ),
                ],
              ),
              Expanded(
                child: Obx(() => customerList.length == 0
                    ? buildSmartRefresher(buildEmptyContainer())
                    : buildSmartRefresher(ListView.builder(
                        itemBuilder: (context, i) {
                          return buildCustomerItem(context, customerList[i], i);
                        },
                        itemCount: customerList.length,
                      ))),
              ),
            ],
          ),
        ));
  }

  Widget buildCustomerItem(BuildContext context, customer, i) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                customer['TrueName'] ?? '--',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('账号：${customer['UserId']}',
                                  style: TextStyle(fontSize: 11)),
                            ),
                            Text('手机号：${customer['Phone']}',
                                style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('未完成：${customer['NoFinfshNum']}',
                                style: TextStyle(fontSize: 11)),
                            Text('审核中：${customer['CheckNum']}',
                                style: TextStyle(fontSize: 11)),
                            Text('已完成：${customer['FinishNum']}',
                                style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('接单区域：${customer['Address'] ?? '--'}',
                            style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///拨打电话
                GestureDetector(
                  onTap: () {
                    FlutterPhoneDirectCaller.callNumber(customer['Phone']);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 30, 8, 33),
                      border: Border.all(color: Colors.grey[100]!),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.phone_in_talk,
                      size: 15,
                      color: Colors.white,
                    )),
                  ),
                ),

                ///指派客服
                GestureDetector(
                  onTap: () {
                    assignCustomerDialog(customer);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(child: Text('派')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///指派客服
  void assignCustomerDialog(customer) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('是否指派给客服${customer['TrueName']}？'),
          ),
          titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
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
                Navigator.of(context).pop();
                assignCustomer(customer);
              },
            ),
          ],
        );
      },
    );
  }

  ///指派客服
  void assignCustomer(customer) {
// LoginId: Cyl
// Token: mi9gAwC22huiOvmMMz5D+cmCb1xQSh+mIjFzZD3T9zKFMUiw8GPO/CQgS27gVQ/cOvDv4Gl4go2AMPt6gDd2pw==
// OrderNumber: 230217045666
// UserId: kefu1013
    RequestUtil.post(Api.assignCustomer, {
      'LoginId': loginId.value,
      'OrderNumber': widget.orderNumber,
      'UserId': customer['UserId']
    }).then((value) {
      if (value['Success']) {
        showToast('指派成功');
        pop(context, true);
      } else {
        showToast(value['msg']);
      }
    });
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
              '暂无客服',
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
      enablePullUp: customerList.length != 0,
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
