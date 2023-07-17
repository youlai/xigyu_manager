// ignore_for_file: must_be_immutable, sdk_version_ui_as_code

import 'dart:io';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:collection/collection.dart";
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/page_customer.dart';
import 'package:xigyu_manager/pages/page_master.dart';
import 'package:xigyu_manager/pages/page_order_record.dart';
import 'package:xigyu_manager/utils/screen_utils.dart';
import 'package:xigyu_manager/utils/utils.dart';

import '../utils/request_util.dart';

class OrderDetailB extends StatefulWidget {
  var orderNumber;

  OrderDetailB(this.orderNumber);

  @override
  _OrderDetailBState createState() => _OrderDetailBState();
}

class _OrderDetailBState extends State<OrderDetailB> {
  EdgeInsets btnEdgeInsets = EdgeInsets.fromLTRB(5, 5, 5, 5);
  List<List<String>> recordList = [
    ['2020-07-01 14:30', '发送预约成功短信给用户...'],
    ['2020-07-01 12:42', '杨师傅同意接单'],
    ['2020-07-01 10:42', '指定派单给杨师傅，给用...'],
  ];

  ///
  ///   *       Model:{
  ///   *         "Id": 25,
  ///   *         "OrderNumber": "221125376637",
  ///   *         "TypeId": 1,
  ///   *         "TypeName": "维修",
  ///   *         "PaoneId": 0,
  ///   *         "PaoneName": "保内",
  ///   *         "OriginId": 0,
  ///   *         "OriginName": "线下",
  ///   *         "UserName": "小小怪",
  ///   *         "Phone": "16623362339",
  ///   *         "ProvinceName": "天津市",
  ///   *         "CityName": "天津市",
  ///   *         "AreaName": "河东区",
  ///   *         "Address": "炉房花苑",
  ///   *         "FullAddress": "天津市天津市河东区炉房花苑",
  ///   *         "Longitude": "117.266838",
  ///   *         "Dimension": "39.138245",
  ///   *         "FactoryId": 1,
  ///   *         "FactoryUserId": "16623392336",
  ///   *         "FactoryName": "2345科技有限公司",
  ///   *         "Product": "美的_冰箱_冰箱_M77-e,美的_冷柜_冷柜_E87-f",
  ///   *         "Amount": 50.0,
  ///   *         "FactoryAmount": 50.0,
  ///   *         "FactoryFrozenAmount": 50.0,
  ///   *         "MasterAmount": 20.0,
  ///   *         "MasterFrozenAmount": 20.0,
  ///   *         "ThirdNumber": null,
  ///   *         "ShopName": null,
  ///   *         "AddTime": "2022-11-25 10:22:56",
  ///   *         "State": 2,
  ///   *         "StateName": "待接单",
  ///   *         "PartsState": 0,
  ///   *         "PartsStateName": "待申请",
  ///   *         "PartsAllSatte": 0,
  ///   *         "PartsAllSatteName": "待申请",
  ///   *         "CustomerId": 89,
  ///   *         "CustomerUserId": "82202258",
  ///   *         "CustomerName": "灰心超人",
  ///   *         "CustomerTime": "2022-11-25 10:23:11",
  ///   *         "GroupId": 2,
  ///   *         "GroupName": "测试2",
  ///   *         "MasterId": 20,
  ///   *         "MasterUserId": "xx",
  ///   *         "MasterName": "fffff",
  ///   *         "MasterAssignTime": "2022-11-25 10:23:27",
  ///   *         "TackInvalidTime": "2022-12-02 10:23:27",
  ///   *         "TackTime": null,
  ///   *         "RefuseTime": null,
  ///   *         "RefuseMsg": null,
  ///   *         "AppointmentTime": null,
  ///   *         "AppointExpectTime": null,
  ///   *         "IsApoint": 0,
  ///   *         "AppointmentNum": 0,
  ///   *         "CheckTime": null,
  ///   *         "CheckNum": 0,
  ///   *         "IsDoor": 0,
  ///   *         "IsPartCheck": 0,
  ///   *         "IsPartDeliver": 0,
  ///   *         "IsPartSign": 0,
  ///   *         "IsPartChecked": 0,
  ///   *         "IsPartCancel": 0,
  ///   *         "IsFeeCheck": 0,
  ///   *         "IsFeeChecked": 0,
  ///   *         "IsFeeCancel": 0,
  ///   *         "IsPartBack": 0,
  ///   *         "IsPartBackCheck": 0,
  ///   *         "IsPartBackChecked": 0,
  ///   *         "PartsTime": null,
  ///   *         "PartsCheckTime": null,
  ///   *         "PartsDeliverTime": null,
  ///   *         "PartsCheckedTime": null,
  ///   *         "PartsBackTime": null,
  ///   *         "PartsBackCheckTime": null,
  ///   *         "CommitTime": null,
  ///   *         "CommitNum": 0,
  ///   *         "CommitEndTime": null,
  ///   *         "CommitEndNum": 0,
  ///   *         "CommitAbolishTime": null,
  ///   *         "CommitAbolishNum": 0,
  ///   *         "BeforeExamineState": -1,
  ///   *         "BeforeExamineStateName": null,
  ///   *         "CommitCancelTime": null,
  ///   *         "CommitCancelNum": 0,
  ///   *         "BeforeCancelState": -1,
  ///   *         "BeforeCancelStateName": null,
  ///   *         "ExamineTime": null,
  ///   *         "EndTime": null,
  ///   *         "BackTime": null,
  ///   *         "LastLeveMessage": null,
  ///   *         "LastLeveMessageTime": null,
  ///   *         "LastRecordMessage": "指派师傅:xx(fffff)",
  ///   *         "LastRecordMessageTime": "2022-11-25 10:23:27",
  ///   *         "NextFollowTime": null,
  ///   *         "FollowNum": 0,
  ///   *         "LastLeveMessageUser": null,
  ///   *         "IsPartCheckTime": null,
  ///   *         "IsPartDeliverTime": null,
  ///   *         "IsPartSignTime": null,
  ///   *         "IsPartCheckedTime": null,
  ///   *         "IsPartCancelTime": null,
  ///   *         "IsFeeCheckTime": null,
  ///   *         "IsFeeCheckedTime": null,
  ///   *         "IsFeeCancelTime": null,
  ///   *         "IsPartBackTime": null,
  ///   *         "IsPartBackCheckTime": null,
  ///   *         "IsPartBackCheckedTime": null,
  ///   *         "Requirements": "安装费",
  ///   *         "ReminderNum": 0,
  ///   *         "Memo": null,
  ///   *         "IsOperation": 0,
  ///   *         "IsEnd": 0,
  ///   *         "IsEndName": null,
  ///   *         "TackNum": null
  ///   *       },
  ///   *       "Fee": [
  ///   *         {
  ///   *           "Id": 61,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "FeeModelId": 2,
  ///   *           "FeeModelName": "安装费/维修费",
  ///   *           "ProductId": 27,
  ///   *           "Product": "美的_冰箱_冰箱_M77-e",
  ///   *           "Msg": null,
  ///   *           "AccountId": 0,
  ///   *           "UserId": null,
  ///   *           "UserName": null,
  ///   *           "FactoryAmount": 15.0,
  ///   *           "MasterAmount": 10.0,
  ///   *           "AddTime": "2022-11-25 10:22:56",
  ///   *           "IsDefault": 1
  ///   *         },
  ///   *         {
  ///   *           "Id": 62,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "FeeModelId": 0,
  ///   *           "FeeModelName": "平台费",
  ///   *           "ProductId": 27,
  ///   *           "Product": "美的_冰箱_冰箱_M77-e",
  ///   *           "Msg": null,
  ///   *           "AccountId": 0,
  ///   *           "UserId": null,
  ///   *           "UserName": null,
  ///   *           "FactoryAmount": 10.0,
  ///   *           "MasterAmount": 0.0,
  ///   *           "AddTime": "2022-11-25 10:22:56",
  ///   *           "IsDefault": 1
  ///   *         },
  ///   *         {
  ///   *           "Id": 63,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "FeeModelId": 2,
  ///   *           "FeeModelName": "安装费/维修费",
  ///   *           "ProductId": 28,
  ///   *           "Product": "美的_冷柜_冷柜_E87-f",
  ///   *           "Msg": null,
  ///   *           "AccountId": 0,
  ///   *           "UserId": null,
  ///   *           "UserName": null,
  ///   *           "FactoryAmount": 15.0,
  ///   *           "MasterAmount": 10.0,
  ///   *           "AddTime": "2022-11-25 10:22:56",
  ///   *           "IsDefault": 1
  ///   *         },
  ///   *         {
  ///   *           "Id": 64,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "FeeModelId": 0,
  ///   *           "FeeModelName": "平台费",
  ///   *           "ProductId": 28,
  ///   *           "Product": "美的_冷柜_冷柜_E87-f",
  ///   *           "Msg": null,
  ///   *           "AccountId": 0,
  ///   *           "UserId": null,
  ///   *           "UserName": null,
  ///   *           "FactoryAmount": 10.0,
  ///   *           "MasterAmount": 0.0,
  ///   *           "AddTime": "2022-11-25 10:22:56",
  ///   *           "IsDefault": 1
  ///   *         }
  ///   *       ],
  ///   *       "Record": [
  ///   *         {
  ///   *           "Id": 178,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "State": 0,
  ///   *           "StateName": "工单记录",
  ///   *           "TypeId": 0,
  ///   *           "TypeName": "文字",
  ///   *           "Content": "指派师傅:xx(fffff)",
  ///   *           "HideContent": "指派师傅:xx(fffff)",
  ///   *           "FilePath": null,
  ///   *           "VideoPath": null,
  ///   *           "AddTime": "2022-11-25 10:23:27",
  ///   *           "IsFactory": 0,
  ///   *           "IsFactoryName": "可见",
  ///   *           "IsMaster": 0,
  ///   *           "IsMasterName": "可见",
  ///   *           "CareteAccountId": 20,
  ///   *           "CreateUserId": "师傅：xx",
  ///   *           "HideCreateUserId": "师傅：xx",
  ///   *           "CreateUserName": "fffff"
  ///   *         },
  ///   *         {
  ///   *           "Id": 177,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "State": 0,
  ///   *           "StateName": "工单记录",
  ///   *           "TypeId": 0,
  ///   *           "TypeName": "文字",
  ///   *           "Content": "指派客服:82202258(灰心超人)",
  ///   *           "HideContent": "指派客服:82202258(灰心超人)",
  ///   *           "FilePath": null,
  ///   *           "VideoPath": null,
  ///   *           "AddTime": "2022-11-25 10:23:11",
  ///   *           "IsFactory": 0,
  ///   *           "IsFactoryName": "可见",
  ///   *           "IsMaster": 0,
  ///   *           "IsMasterName": "可见",
  ///   *           "CareteAccountId": 89,
  ///   *           "CreateUserId": "客服：82202258",
  ///   *           "HideCreateUserId": "客服：82202258",
  ///   *           "CreateUserName": "灰心超人"
  ///   *         },
  ///   *         {
  ///   *           "Id": 176,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "State": 0,
  ///   *           "StateName": "工单记录",
  ///   *           "TypeId": 0,
  ///   *           "TypeName": "文字",
  ///   *           "Content": "工厂(2345科技有限公司):新建工单",
  ///   *           "HideContent": "工厂(2345科技有限公司):新建工单",
  ///   *           "FilePath": null,
  ///   *           "VideoPath": null,
  ///   *           "AddTime": "2022-11-25 10:22:56",
  ///   *           "IsFactory": 0,
  ///   *           "IsFactoryName": "可见",
  ///   *           "IsMaster": 0,
  ///   *           "IsMasterName": "可见",
  ///   *           "CareteAccountId": 1,
  ///   *           "CreateUserId": "16623392336",
  ///   *           "HideCreateUserId": "166****2336",
  ///   *           "CreateUserName": "2345科技有限公司"
  ///   *         }
  ///   *       ],
  ///   *       "Product": [
  ///   *         {
  ///   *           "Id": 27,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "CategoryId": 1,
  ///   *           "CategroyName": "冰洗类12",
  ///   *           "ProductId": 1,
  ///   *           "ProductName": "冰箱",
  ///   *           "SpecId": 1,
  ///   *           "SpecName": "冰箱",
  ///   *           "ModelId": 1,
  ///   *           "ModelName": "M77-e",
  ///   *           "BrandId": 2,
  ///   *           "BrandName": "美的",
  ///   *           "Product": "美的_冰箱_冰箱_M77-e",
  ///   *           "Num": 1,
  ///   *           "BuyTime": "2022-11-04 00:00:00",
  ///   *           "BarCode": null,
  ///   *           "Requirements": "安装费",
  ///   *           "FactoryAmount": 25.0,
  ///   *           "MasterAmount": 10.0,
  ///   *           "Remark": null
  ///   *         },
  ///   *         {
  ///   *           "Id": 28,
  ///   *           "OrderId": 25,
  ///   *           "OrderNumber": "221125376637",
  ///   *           "CategoryId": 1,
  ///   *           "CategroyName": "冰洗类12",
  ///   *           "ProductId": 3,
  ///   *           "ProductName": "冷柜",
  ///   *           "SpecId": 4,
  ///   *           "SpecName": "冷柜",
  ///   *           "ModelId": 2,
  ///   *           "ModelName": "E87-f",
  ///   *           "BrandId": 2,
  ///   *           "BrandName": "美的",
  ///   *           "Product": "美的_冷柜_冷柜_E87-f",
  ///   *           "Num": 1,
  ///   *           "BuyTime": "2022-11-30 00:00:00",
  ///   *           "BarCode": null,
  ///   *           "Requirements": "安装费",
  ///   *           "FactoryAmount": 25.0,
  ///   *           "MasterAmount": 10.0,
  ///   *           "Remark": null
  ///   *         }
  ///   *       ],
  ///   *       "Master": {
  ///   *         "Id": 20,
  ///   *         "OpenId": "oTf5z5Id-UZMxuIii8B3LXDrQD9M",
  ///   *         "GZOpenId": "oBWcn1kD0By00eV2Kl-8MBJoGmps",
  ///   *         "UserId": "xx",
  ///   *         "NickName": "ohh",
  ///   *         "TrueName": "fffff",
  ///   *         "Photo": "https://bucket.xigyu.com/Product/Uploads/Wxapplets/Image/20221121/40a0fc70-605b-441b-a6a8-01d1143a5cff.jpg",
  ///   *         "ProvinceName": "安徽省",
  ///   *         "CityName": "安庆市",
  ///   *         "AreaName": "桐城市",
  ///   *         "Address": "柳西",
  ///   *         "FullAddress": "安徽省安庆市桐城市柳西",
  ///   *         "Longitude": "117.064079",
  ///   *         "Dimension": "30.54311",
  ///   *         "Phone": "33333333333",
  ///   *         "Password": "e10adc3949ba59abbe56e057f20f883e",
  ///   *         "Payword": "ba00819f263287af1ff0100c5a323355",
  ///   *         "IdCard": "511622200203242249",
  ///   *         "CardImage": "https://xigyubuckettest.oss-cn-hangzhou.aliyuncs.com/Product/Uploads/Wxapplets/Image/20221109/c0906352-6f0f-4ca3-b53a-ef1738b6e492.jpg,https://xigyubuckettest.oss-cn-hangzhou.aliyuncs.com/Product/Uploads/Wxapplets/Image/20221109/c05cbdb0-8e9e-4c1d-99c0-dbba1047c9ef.png",
  ///   *         "Remark": null,
  ///   *         "IsUse": "Y",
  ///   *         "IsTack": 0,
  ///   *         "Star": 5.0,
  ///   *         "GreenStar": 5.0,
  ///   *         "Service": 98.0,
  ///   *         "Efficiency": 100.0,
  ///   *         "Quality": 0.0,
  ///   *         "Amount": 0.0,
  ///   *         "FrozenAmount": 0.0,
  ///   *         "WithTotalAmount": 0.0,
  ///   *         "WithAmount": 0.0,
  ///   *         "Recharge": 0.0,
  ///   *         "SignAmount": 0.0,
  ///   *         "IsSign": 0,
  ///   *         "WarrantyAmount": 0.0,
  ///   *         "UnTackNum": 12,
  ///   *         "TackNum": 5,
  ///   *         "UnApointNum": 0,
  ///   *         "UnCheckNum": 1,
  ///   *         "ServiceNum": 6,
  ///   *         "SettleNum": 2,
  ///   *         "FinishNum": 0,
  ///   *         "CancelNum": 0,
  ///   *         "AddTime": "2022-10-27 11:17:01",
  ///   *         "LoginNum": 8,
  ///   *         "LastLoginTime": "2022-11-24 15:33:26",
  ///   *         "ParentId": 0,
  ///   *         "RefuseNum": 0
  ///   *       },
  ///   *       "Parts": []
  ///   *     }
  RxMap order = RxMap();

  ///价格标准集合
  RxList price = RxList();

  ///费用单集合
  RxList feeList = RxList();

  ///拒绝原因集合
  RxList reasonList = RxList();

  ///产品是否展开
  RxBool proExpand = true.obs;

  ///配件是否展开
  RxBool partsExpand = true.obs;

  ///费用是否展开
  RxBool feeExpand = true.obs;

  ///选中的拒绝工单原因下标
  RxInt reasonIndex = 0.obs;

  ///确认选中的拒绝工单原因下标
  RxInt cReasonIndex = (-1).obs;

  ///其它拒绝工单原因
  RxString otherReason = ''.obs;

  ///同区域工单数量
  RxInt sameAreaCount = 0.obs;

  ///该工单产品数量
  RxInt num = 0.obs;

  ///安装工单完结码
  RxString tackNum = ''.obs;

  ///获取客服下师傅是否可以申请费用 IsFee 0可以 1不可以
  RxInt isFee = 0.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.orderNumber = '230413285201';
    getDetail();
  }

  ///获取工单详情
  void getDetail() {
    RequestUtil.post(Api.getDetail, {'OrderNumber': widget.orderNumber})
        .then((value) {
      if (value['Success']) {
        order.value = value['rows'];
        List sortProduct = (order['Model']['SortProduct'] as String).split(',');
        Map map = groupBy(sortProduct, (e) => e);
        var str = '';
        map.forEach((key, value) {
          str += (value[0] as String)
                  .substring(0, (value[0] as String).length - 3) +
              'x${value.length},';
        });
        if (str.contains(',')) {
          str = str.substring(0, str.lastIndexOf(','));
          order['Model']['SortProduct'] = str;
        }
        print(str);
        List products = order['Product'];
        num.value = products.length;
        Map groups = groupBy(products, (e) => (e! as Map)['Product']);
        groups.forEach((key, value) {
          var pros = [];
          var pro = value[0];
          pro['Num'] = value.length;
          pros.add(pro);
          order['Product'] = pros;
        });
      } else {
        showToast(value['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('工单详情', [], context),
      body: Obx(() => order.isEmpty
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: [
                ///顶部信息
                // Container(
                //   color: Color(0xffFFF0D7),
                //   padding: EdgeInsets.symmetric(vertical: 10),
                //   child: Column(
                //     children: [
                //       Text(
                //         '路线里程1.6km，骑行需要10分钟',
                //         style: TextStyle(color: Color(0xffFF5800)),
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Image.asset(
                //             'assets/time.png',
                //             width: 20,
                //             height: 20,
                //           ),
                //           SizedBox(
                //             width: 5,
                //           ),
                //           CountDownText(DateTime.now().millisecondsSinceEpoch,
                //               DateTime.parse('20221124 17:30:00')),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: ListView(
                    children: [
                      ///工单信息
                      buildOrderInfo(),

                      ///用户信息
                      buildUserInfo(),

                      ///产品信息
                      buildProducts(),

                      ///完工要求故障描述
                      buildMemo(),

                      ///配件信息 TypeId 安装0 维修1 用户送修2 寄修3   PaoneId 0保内 1保外
                      if (order['Model']['TypeId'] != 0 &&
                          order['Model']['PaoneId'] == 0)
                        buildAccInfo(),

                      ///费用信息
                      buildFeeInfo(),

                      ///配件信息 TypeId 安装0 维修1 用户送修2 寄修3   PaoneId 0保内 1保外
                      if (order['Model']['TypeId'] == 0) buildExpress(),

                      ///服务信息
                      buildWorkerInfo(),

                      ///费用明细
                      buildFeeDetail(),

                      ///工单进度
                      buildOrderRecords(context),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top:
                                BorderSide(width: 1, color: Colors.grey[200]!))),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showPhone();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/call_phone.png',
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  '拨打电话',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              ///指派客服
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  overlayColor: MaterialStateProperty.all(
                                      Color(0xff888888)),
                                  backgroundColor:
                                      MaterialStateProperty.all(mainColor),
                                  padding:
                                      MaterialStateProperty.all(btnEdgeInsets),
                                ),
                                onPressed: () async {
                                  var result = await pushTo(
                                      context,
                                      CustomerPage(
                                        orderId: order['Model']['Id'],
                                        orderNumber: widget.orderNumber,
                                      ));
                                  if (result != null) {
                                    pop(context,true);
                                  }
                                },
                                child: Text('指派客服',
                                    style: TextStyle(fontSize: 16)),
                              ),
                              ///指派师傅
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  overlayColor: MaterialStateProperty.all(
                                      Color(0xff888888)),
                                  backgroundColor:
                                      MaterialStateProperty.all(mainColor),
                                  padding:
                                      MaterialStateProperty.all(btnEdgeInsets),
                                ),
                                onPressed: () async {
                                  var result = await pushTo(
                                      context,
                                      MasterPage(
                                        orderId: order['Model']['Id'],
                                        orderNumber: widget.orderNumber,
                                      ));
                                  if (result != null) {
                                    pop(context,true);
                                  }
                                },
                                child: Text('指派师傅',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ],
            )),
    );
  }

  ///工单信息
  Container buildOrderInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '工单信息',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  copyOrderInfo();
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/copy.png',
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      '复制工单信息',
                      style: TextStyle(color: mainColor),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() {
            return Text(
              order['Model']['SortProduct'] ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: List.generate(2, (index) {
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        color: index == 0
                            ? (order['Model']['PaoneId'] == 0
                                ? mainColor
                                : Colors.red)
                            : Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: Text(
                      index == 0
                          ? order['Model']['PaoneName'] +
                              order['Model']['TypeName']
                          : order['Model']['StateName'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ));
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Obx(() {
              return Text('工单编号:${order['Model']['OrderNumber']}');
            }),
          ),
          Obx(() {
            return Text('发单时间:${order['Model']['AddTime']}');
          }),
        ],
      ),
    );
  }

  ///产品信息
  Widget buildProducts() {
    return Obx(() {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '产品信息',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // Row(
                //   children: [
                //     Text(
                //       '维修资料',
                //       style: TextStyle(color: mainColor),
                //     ),
                //     Image.asset(
                //       'assets/right.png',
                //       width: 20,
                //       height: 20,
                //     ),
                //   ],
                // )
              ],
            ),
            if ((order['Product'] as List).length > 0)
              Obx(() {
                return Column(
                  children: List.generate(
                      proExpand.value ? (order['Product'] as List).length : 1,
                      (index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      margin: EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                '产品品牌:${order['Product'][index]['BrandName']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                '产品类型:${order['Product'][index]['ProductName']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                '产品规格:${order['Product'][index]['SpecName']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                                '产品型号:${order['Product'][index]['ModelName']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child:
                                Text('产品数量:x${order['Product'][index]['Num']}'),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }),
            if ((order['Product'] as List).length > 1)
              InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Text(
                            proExpand.value ? '收起' : '展开更多',
                            style: TextStyle(fontSize: 14),
                          );
                        }),
                        proExpand.value
                            ? Icon(Icons.arrow_drop_up)
                            : Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                  onTap: () {
                    proExpand.value = !proExpand.value;
                  })
          ],
        ),
      );
    });
  }

  ///服务要求，故障描述
  Container buildMemo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order['Model']['TypeId'] == 0 ? '完工要求：' : '故障描述：',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Color(0xffF3F3F3),
                border: Border.all(color: Color(0xffd4d4d4)),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text(
              order['Model']['Memo'] ?? '暂无',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  ///用户信息
  Container buildUserInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '用户信息',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        copyAddr();
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          child: Text('复制',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white))),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Color(0xff888888)),
                  backgroundColor: MaterialStateProperty.all(mainColor),
                  padding: MaterialStateProperty.all(btnEdgeInsets),
                ),
                onPressed: () {
                  showToast('研发中。。。');
                  // showChooseMap();
//                  pushTo(context, SocketPage());
                },
                child: Text('导航', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Obx(() {
              return Text(
                  '${order['Model']['UserName']}   ${order['Model']['Phone']}' +
                      (order['Model']['PhoneExtend'] == null ||
                              order['Model']['PhoneExtend'] == ''
                          ? ''
                          : '（分机号：${order['Model']['PhoneExtend']}）'));
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Obx(() {
              return Text('${order['Model']['FullAddress']}');
            }),
          )
        ],
      ),
    );
  }

  ///配件信息
  Container buildAccInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Row(
                children: [
                  Expanded(
                    child: Text(
                      '配件信息',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ///待上门 服务中 保内 维修
                  if ((order['Model']['State'] == 4 ||
                          order['Model']['State'] == 5) &&
                      order['Model']['TypeId'] != 0 &&
                      order['Model']['PaoneId'] == 0)
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor:
                            MaterialStateProperty.all(Color(0xff888888)),
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        padding: MaterialStateProperty.all(btnEdgeInsets),
                      ),
                      onPressed: () async {},
                      child: Text('申请配件', style: TextStyle(fontSize: 16)),
                    )
                ],
              )),
          if ((order['Parts'] as List).length == 0) Text('暂未申请配件，无配件单信息'),
          if ((order['Parts'] as List).length > 0)
            Obx(() {
              return Column(
                children: List.generate(
                    partsExpand.value ? (order['Parts'] as List).length : 1,
                    (index) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // pushTo(context,
                            //     AccDetailPage(order['Parts'][index]['Id']));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Color(0xffF3F3F3),
                                border: Border.all(color: Color(0xffd4d4d4)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            '配件单号：${order['Parts'][index]['PartsNumber']}'),
                                      ),
                                      Image.asset(
                                        'assets/right.png',
                                        width: 15,
                                        height: 15,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '${order['Parts'][index]['Name']} x${order['Parts'][index]['Num']}')),
                                      Text(
                                        '${order['Parts'][index]['StateName']}' +
                                            (order['Parts'][index]['State'] == 4
                                                ? (order['Parts'][index]
                                                            ['IsReturn'] ==
                                                        1
                                                    ? '/需要返件'
                                                    : '/不需要返件')
                                                : ''),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
              );
            }),
          if ((order['Parts'] as List).length > 1)
            InkWell(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        return Text(
                          partsExpand.value ? '收起' : '展开更多',
                          style: TextStyle(fontSize: 14),
                        );
                      }),
                      partsExpand.value
                          ? Icon(Icons.arrow_drop_up)
                          : Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                onTap: () {
                  partsExpand.value = !partsExpand.value;
                })
        ],
      ),
    );
  }

  ///费用信息
  Container buildFeeInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Row(
                children: [
                  Expanded(
                    child: Text(
                      '费用信息',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ///待上门 服务中 保内
                  if ((order['Model']['State'] == 4 ||
                          order['Model']['State'] == 5) &&
                      order['Model']['PaoneId'] == 0 &&
                      isFee.value == 0)
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor:
                            MaterialStateProperty.all(Color(0xff888888)),
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        padding: MaterialStateProperty.all(btnEdgeInsets),
                      ),
                      onPressed: () async {
                        // var result = await pushTo(context,
                        //     FeeApplyPageB(orderNumber: widget.orderNumber));
                        // if (result != null) {
                        //   getDetail();
                        //   getOrderFeeList();
                        // }
                      },
                      child: Text('申请费用', style: TextStyle(fontSize: 16)),
                    )
                ],
              )),
          if (feeList.length == 0) Text('暂未申请费用，无费用单信息'),
          if (feeList.length > 0)
            Obx(() {
              return Column(
                children: List.generate(
                    feeExpand.value ? feeList.length : 1,
                    (index) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // pushTo(context, FeeApplyDetailPage(feeList[index]));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Color(0xffF3F3F3),
                                border: Border.all(color: Color(0xffd4d4d4)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            '费用单号：${feeList[index]['ExpenseNumber']}'),
                                      ),
                                      Image.asset(
                                        'assets/right.png',
                                        width: 15,
                                        height: 15,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '${feeList[index]['Name']} ${feeList[index]['MasterAmount']}元')),
                                      Text(
                                        feeList[index]['State'] == 0
                                            ? '待审核'
                                            : (feeList[index]['State'] == 1 ||
                                                    feeList[index]['State'] ==
                                                        3)
                                                ? '通过'
                                                : '不通过',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
              );
            }),
          if (feeList.length > 1)
            InkWell(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        return Text(
                          feeExpand.value ? '收起' : '展开更多',
                          style: TextStyle(fontSize: 14),
                        );
                      }),
                      feeExpand.value
                          ? Icon(Icons.arrow_drop_up)
                          : Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                onTap: () {
                  feeExpand.value = !feeExpand.value;
                })
        ],
      ),
    );
  }

  ///物流信息
  Container buildExpress() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '物流信息',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (order['Product'][0]['ExpressNumber'] == null) Text('暂无物流信息'),
          if (order['Product'][0]['ExpressNumber'] != null)
            Column(
                children: List.generate(
                    order['Product'].length,
                    (index) => Row(
                          children: [
                            Expanded(
                              child: Text(
                                  order['Product'][index]['ExpressNumber'] ??
                                      '--',
                                  style: TextStyle(color: mainColor)),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                overlayColor: MaterialStateProperty.all(
                                    Color(0xff888888)),
                                backgroundColor:
                                    MaterialStateProperty.all(mainColor),
                                padding:
                                    MaterialStateProperty.all(btnEdgeInsets),
                              ),
                              onPressed: () async {
                                // pushTo(
                                //     context,
                                //     DeliverInfoPage(
                                //         order['Product'][index]
                                //             ['ExpressNumber'],
                                //         '物流信息',
                                //         ''));
                              },
                              child:
                                  Text('查看物流', style: TextStyle(fontSize: 16)),
                            )
                          ],
                        )).toList())
        ],
      ),
    );
  }

  ///服务信息
  Container buildWorkerInfo() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '服务信息',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Color(0xff888888)),
                  backgroundColor: MaterialStateProperty.all(mainColor),
                  padding: MaterialStateProperty.all(btnEdgeInsets),
                ),
                onPressed: () async {
                  var result = await pushTo(
                      context,
                      MasterPage(
                        orderId: order['Model']['Id'],
                        orderNumber: widget.orderNumber,
                      ));
                  if (result != null) {
                    pop(context,true);
                  }
                },
                child: Text('指派师傅', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('接单师傅：${order['Model']['MasterName'] ?? '--'}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('接单时间：${order['Model']['TackTime'] ?? '--'}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('预约时间：${order['Model']['AppointmentTime'] ?? '--'}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('签到时间：${order['Model']['CheckTime'] ?? '--'}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('完结时间：${order['Model']['CommitTime'] ?? '--'}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('提交时间：${order['Model']['EndTime'] ?? '--'}'),
          ),
        ],
      ),
    );
  }

  ///费用明细
  Container buildFeeDetail() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '费用明细',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Color(0xff888888)),
                  backgroundColor: MaterialStateProperty.all(mainColor),
                  padding: MaterialStateProperty.all(btnEdgeInsets),
                ),
                onPressed: () {
                  showToast('研发中。。。');
                  if (order['Model']['PaoneId'] != 0) {
                    showToast('保外单请自行与用户协商收费');
                    return;
                  }
                },
                child: Text('价格标准', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (order['Model']['State'] <= 5 || order['Model']['State'] == 13)
                return;
              /**是否需与子账号分佣 */
              var model = order['Model'];
              var shouldShare =
                  (model['State'] == 11 || model['State'] == 12) &&
                      model['MainMasterUserId'] != null &&
                      model['MainMasterUserId'] != model['MasterUserId'] &&
                      model['IsDomestic'] == 0;
              // var result = await pushTo(
              //     context,
              //     FeeDetailPage(widget.orderNumber, shouldShare, order['Fee'],
              //         model['ScaleAmount']));
              // if (result != null) {
              //   getDetail();
              // }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      order['Model']['State'] <= 5 ||
                              order['Model']['State'] == 13
                          ? '工单尚未完结，费用明细暂未产生'
                          : '合计：¥${order['Fee'][0]['MasterAmount']}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                  if (order['Model']['State'] > 5 &&
                      order['Model']['State'] != 13)
                    Image.asset('assets/right.png', width: 15, height: 15)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///工单进度
  Container buildOrderRecords(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(top: 8, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '工单进度',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Color(0xff888888)),
                  backgroundColor: MaterialStateProperty.all(mainColor),
                  padding: MaterialStateProperty.all(btnEdgeInsets),
                ),
                onPressed: () async {
                  // var result = await pushTo(
                  //     context, LeaveMsgPage(order['Model']['OrderNumber']));
                  // if (result != null) {
                  //   getDetail();
                  // }
                },
                child: Text('添加留言', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              pushTo(context, OrderRecordPage(order['Record']));
            },
            child: Obx(() {
              return Column(
                  children: List.generate(
                      (order['Record'] as List).length > 5
                          ? 5
                          : (order['Record'] as List).length,
                      (position) => Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 0, right: 0),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  //这个Container描绘左侧的线和圆点
                                  Container(
                                    margin: EdgeInsets.only(left: 0),
                                    width: 20,
                                    //需要根据文本内容调整高度，不然文本太长会撑开Container，导致线会断开
//                        height: getHeight(recordList[position].stateName),
                                    child: Column(
                                      //中心对齐，
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              //第一个item圆点上方的线就不显示了
                                              width: position == 0 ? 0 : 1,
                                              color: Colors.grey.shade300,
                                            )),
                                        //第一个item显示稍大一点的绿色圆点
                                        position == 0
                                            ? Stack(
                                                //圆心对齐（也就是中心对齐）
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  //为了实现类似阴影的圆点
                                                  Container(
                                                    height: 16,
                                                    width: 16,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade200,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                      color: mainColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7)),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                              ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: position ==
                                                      ((order['Record'] as List)
                                                                      .length >
                                                                  5
                                                              ? 5
                                                              : (order['Record']
                                                                      as List)
                                                                  .length) -
                                                          1
                                                  ? 0
                                                  : 1,
                                              color: Colors.grey.shade300,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 20, 5),
                                      child: Text(
                                        '${order['Record'][position]['AddTime']}    ${order['Record'][position]['HideContent'] ?? '--'}',
                                        style: TextStyle(
                                          //第一个item字体颜色为绿色+稍微加粗
                                          color: position == 0
                                              ? mainColor
                                              : Colors.black,
                                          fontWeight: position == 0
                                              ? FontWeight.w600
                                              : null,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )));
            }),
          ),
//            Divider(),
          InkWell(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '查看更多',
                      style: TextStyle(fontSize: 14),
                    ),
                    Image.asset(
                      'assets/right.png',
                      width: 15,
                      height: 15,
                    )
                  ],
                ),
              ),
              onTap: () {
                pushTo(this.context, OrderRecordPage(order['Record']));
              })
        ],
      ),
    );
  }

  ///拨打电话
  showPhone() {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            height: 76 * 3.toDouble(),
            child: Column(
              children: ListTile.divideTiles(tiles: [
//                ListTile(
//                  contentPadding: EdgeInsets.symmetric(vertical: 10),
//                  title:
//                      Center(child: Text("厂家技术电话：${order.value.artisanPhone}")),
//                  onTap: () async {
//                    Navigator.of(context).pop();
//                    _callNumber(order.value.artisanPhone);
//                  },
//                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  title: Center(
                      child:
                          Text("客服电话：${order['Model'][''] ?? '4006262365'}")),
                  onTap: () async {
                    Navigator.of(context).pop();
                    callNumber(order['Model'][''] ?? '4006262365');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  title: Center(child: Text("用户电话：${order['Model']['Phone']}")),
                  onTap: () async {
                    Navigator.of(context).pop();
                    callNumber(order['Model']['Phone']);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  title: Center(child: Text("取消")),
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ], color: Colors.grey)
                  .toList(),
            ),
          ),
        );
      },
      elevation: 10,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    );
  }

  callNumber(String phone) async {
    if (!Platform.isIOS) {
      PermissionStatus status = await Permission.phone.request();
      switch (status) {
        case PermissionStatus.granted:
          FlutterPhoneDirectCaller.callNumber(phone);
          return;
        case PermissionStatus.restricted:
        // case PermissionStatus.undetermined:
        case PermissionStatus.permanentlyDenied:
        case PermissionStatus.limited:
        case PermissionStatus.denied:
          phoneIsGranted();
          return;
        default:
          throw UnimplementedError();
      }
    } else {
      FlutterPhoneDirectCaller.callNumber(phone);
    }
  }

  ///检查电话权限
  void phoneIsGranted() {
    showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('检测到你未开启拨打电话权限，是否前往开启？'),
          ),
          titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                pop(context);
              },
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () {
                pop(context);
                AppSettings.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  ///复制工单信息
  void copyOrderInfo() {
    String copyText = "工单号：" +
        order['Model']['OrderNumber'] +
        "\n" +
        "下单时间：" +
        order['Model']['AddTime'] +
        "\n" +
        "用户信息：" +
        order['Model']['UserName'] +
        " " +
        order['Model']['Phone'] +
        "\n" +
        "用户地址：" +
        order['Model']['FullAddress'] +
        "\n" +
        "产品信息：" +
        order['Model']['SortProduct'] +
        "\n" +
        "售后类型：" +
        order['Model']['PaoneName'] +
        "\n" +
        "服务类型：" +
        order['Model']['TypeName'];
    //复制
    Clipboard.setData(ClipboardData(text: copyText));
    showToast('复制成功');
  }

  ///复制地址信息
  void copyAddr() {
    String copyText = order['Model']['FullAddress'];
    //复制
    Clipboard.setData(ClipboardData(text: copyText));
    showToast('复制成功');
  }
}
