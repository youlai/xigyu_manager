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

///指派师傅页面

class MasterPage extends StatefulWidget {
  var orderId;
  var orderNumber;
  MasterPage({this.orderId,this.orderNumber});
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage>
    with AutomaticKeepAliveClientMixin {
  var page = 1;
  var rows = 10;

  ///1 同区域师傅 0跨区域师傅
  RxInt selectType = 1.obs;
  String search = '';
  TextEditingController searchCtr = TextEditingController();
  RxList<Map> masterList = <Map>[].obs;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// LoginId: Cyl
// OrderNumber: 230419766027
// UserId
// IsArea: 1
// Page: 1
// Rows: 10
  void fetchData() {
    var params = {
      'LoginId': loginId.value,
      'OrderNumber': widget.orderNumber,
      'UserId': search,
      'Rows': rows,
      'Page': page,
      'IsArea': selectType.value
    };
    RequestUtil.post(Api.getPageSpace, params).then((value) {
      if (value['Success']) {
        refreshController.loadComplete();
        refreshController.refreshCompleted();
        List<Map> list = (value['rows']['rows'] as List).cast<Map>();
        if (page == 1) {
          masterList.value = list;
        } else {
          if (list.length > 0) {
            masterList.addAll(list);
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
              hintText: '请输入账号或姓名',
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
                          '同区域师傅',
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
                          '跨区域师傅',
                          style: TextStyle(color: Colors.white),
                        ))),
                  ),
                ],
              ),
              Expanded(
                child: Obx(() => masterList.length == 0
                    ? buildSmartRefresher(buildEmptyContainer())
                    : buildSmartRefresher(ListView.builder(
                        itemBuilder: (context, i) {
                          return buildMasterItem(context, masterList[i], i);
                        },
                        itemCount: masterList.length,
                      ))),
              ),
            ],
          ),
        ));
  }

  Widget buildMasterItem(BuildContext context, master, i) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[100]),
                      borderRadius: BorderRadius.all(Radius.circular(75)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: master['Photo'],
                      width: 50,
                      height: 50,
                      placeholder: (c, t) => Image.asset('assets/avator.png'),
                      errorWidget: (c, t, x) =>
                          Image.asset('assets/avator.png'),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                master['TrueName'] ?? '--',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Text(
                              master['IsSign'] == 1 ? '已签约' : '未签约',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: master['IsSign'] == 1
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              master['StateName'] ?? '未认证',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: master['State'] == 2
                                      ? Colors.green
                                      : Colors.red),
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
                              child: Text(
                                '备注：${master['Remark'] ?? '--'}',
                                style: TextStyle(fontSize: 14),
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
                            Text('账号：${master['UserId']}',
                                style: TextStyle(fontSize: 11)),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 10,
                                  color: Colors.blue,
                                ),
                                Text('${master['Space'].toInt()}km',
                                    style: TextStyle(
                                        fontSize: 11, color: mainColor)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('星级：', style: TextStyle(fontSize: 11)),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: RatingBar(
                                    value: master['GreenStar'],
                                    size: 15,
                                    padding: 1,
                                    nomalImage: 'assets/star_normal.png',
                                    selectImage: 'assets/star.png',
                                    selectAble: false,
                                    maxRating: 5,
                                    count: 5,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('未接单：${master['OrderUnTack']}',
                                style: TextStyle(fontSize: 11)),
                            Text('未预约：${master['OrderUnApoint']}',
                                style: TextStyle(fontSize: 11)),
                            Text('待上门：${master['OrderUnCheck']}',
                                style: TextStyle(fontSize: 11)),
                            Text('服务中：${master['OrderService']}',
                                style: TextStyle(fontSize: 11)),
                            Text('已完成：${master['OrderFinish']}',
                                style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('店铺地址：${master['FullAddress']}',
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
                ///禁用师傅
                GestureDetector(
                  onTap: () {
                    forbidMasterDialog(master);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.grey[100]),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                        child: Text(
                      '禁',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),

                ///拨打电话
                GestureDetector(
                  onTap: () {
                    FlutterPhoneDirectCaller.callNumber(master['Phone']);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 30, 8, 33),
                      border: Border.all(color: Colors.grey[100]),
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

                ///指派师傅
                GestureDetector(
                  onTap: () {
                    assignMasterDialog(master);
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

  ///指派师傅
  void assignMasterDialog(master) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('是否指派给师傅${master['TrueName']}？'),
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
                assignMaster(master);
              },
            ),
          ],
        );
      },
    );
  }

  ///指派师傅
  void assignMaster(master) {
// LoginId: zhangsan
// Ids: 7560
// UserId: 45678912355
// Space: 91.00
    RequestUtil.post(Api.assignMaster, {
      'LoginId': loginId.value,
      'Ids': widget.orderId,
      'UserId': master['UserId'],
      'Space': master['Space']
    }).then((value) {
      if (value['Success']) {
        showToast('指派成功');
        pop(context,true);
      } else {
        showToast(value['msg']);
      }
    });
  }

  ///禁用师傅
  void forbidMasterDialog(master) {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('是否禁用师傅${master['TrueName']}？'),
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
                forbidMaster(master);
              },
            ),
          ],
        );
      },
    );
  }

  ///禁用师傅
  void forbidMaster(master) {
// LoginId: zhangsan
// Ids: 7560
// UserId: 45678912355
// Space: 91.00
    RequestUtil.post(
            Api.forbidMaster, {'LoginId': loginId.value, 'Id': master['Id']})
        .then((value) {
      if (value['Success']) {
        showToast('禁用成功');
        fetchData();
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
              '暂无师傅',
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
      enablePullUp: masterList.length != 0,
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
