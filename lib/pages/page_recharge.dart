// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/utils/request_util.dart';
import '../../utils/utils.dart';

class RechargePage extends StatefulWidget {
  int index;

  RechargePage({this.index = 0});

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage>
    with AutomaticKeepAliveClientMixin {
  ///账号类型
  List typeGroup = [
    {
      'name': '全部',
      'TypeId': -1,
    },
    {
      'name': '工厂',
      'TypeId': 2,
    },
    {
      'name': '师傅',
      'TypeId': 1,
    },
  ];

  ///交易状态
  List stateGroup = [
    {
      'name': '全部',
      'State': -1,
    },
    {
      'name': '充值成功',
      'State': 1,
    },
    {
      'name': '充值失败',
      'State': 2,
    },
    {
      'name': '等待充值',
      'State': 0,
    },
  ];

  ///支付方式
  List rechargeTypeGroup = [
    {
      'name': '全部',
      'State': -1,
    },
    {
      'name': '微信',
      'State': 0,
    },
    {
      'name': '支付宝',
      'State': 1,
    },
    {
      'name': '线下充值',
      'State': 2,
    },
    {
      'name': '预充',
      'State': 3,
    },
    {
      'name': '充值补贴',
      'State': 4,
    },
    {
      'name': '充值赔付',
      'State': 5,
    },
  ];
  RxInt typeId = (-1).obs;
  RxInt state = (-1).obs;
  RxInt rechargeType = (-1).obs;
  RxString typeName = '账号类型'.obs;
  RxString stateName = '交易状态'.obs;
  RxString rechargeTypeName = '支付方式'.obs;
  RefreshController refreshController = RefreshController();
  int page = 1;
  int rows = 10;
  RxList<Map> rechargeList = <Map>[].obs;

  GlobalKey stackKey = GlobalKey();
  GZXDropdownMenuController dropdownMenuController =
      GZXDropdownMenuController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageList();
  }

//   后台获取充值列表
// /Recharge/GetPageList
// TypeId：-1
// State：充值状态 -1
// RechargeType：充值类型
// UserId：充值账号
// UserName：账号姓名
// StartTime：充值时间（开始）
// EndTime：充值时间（结束）
// Page：页码
// Rows：每页显示数
// Sort：字段
// Order：排序方式
  void getPageList() {
    var params = {
      'State': state.value,
      'RechargeType': rechargeType.value,
      'Page': page,
      'Rows': rows,
      'TypeId': typeId.value,
    };
    RequestUtil.post(Api.getRechargeList, params).then((value) {
      if (value['Success']) {
        refreshController.loadComplete();
        refreshController.refreshCompleted();
        List<Map> list = (value['rows']['List']['rows'] as List).cast<Map>();
        if (page == 1) {
          rechargeList.value = list;
        } else {
          if ((value['rows']['List']['rows'] as List).length > 0) {
            rechargeList.addAll(list);
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
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: Text('充值管理',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal)),
        centerTitle: true,
        elevation: 0.1,
        brightness: Brightness.dark,
      ),
      body: Stack(
        key: stackKey,
        children: [
          Column(
            children: [
              // 下拉菜单头部
              Obx(() => GZXDropDownHeader(
                    // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                    items: [
                      GZXDropDownHeaderItem(
                          typeName.value == '全部' ? '账号类型' : typeName.value),
                      GZXDropDownHeaderItem(
                          stateName.value == '全部' ? '交易状态' : stateName.value),
                      GZXDropDownHeaderItem(rechargeTypeName.value == '全部'
                          ? '支付方式'
                          : rechargeTypeName.value),
                    ],
                    // GZXDropDownHeader对应第一父级Stack的key
                    stackKey: stackKey,
                    // controller用于控制menu的显示或隐藏
                    controller: dropdownMenuController,
                    // 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
                    onItemTap: (index) {
                      // if (index == 3) {
                      //   _dropdownMenuController.hide();
                      //   _scaffoldKey.currentState.openEndDrawer();
                      // }
                    },
                    //                // 头部的高度
                    //                height: 40,
                    //                // 头部背景颜色
                    //                color: Colors.red,
                    //                // 头部边框宽度
                    //                borderWidth: 1,
                    //                // 头部边框颜色
                    //                borderColor: Color(0xFFeeede6),
                    //                // 分割线高度
                    //                dividerHeight: 20,
                    //                // 分割线颜色
                    //                dividerColor: Color(0xFFeeede6),
                    //                // 文字样式
                    style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                    //                // 下拉时文字样式
                    dropDownStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                    //                // 图标大小
                    //                iconSize: 20,
                    //                // 图标颜色
                    //                iconColor: Color(0xFFafada7),
                    //                // 下拉时图标颜色
                    //                iconDropDownColor: Theme.of(context).primaryColor,
                  )),
              Expanded(
                  child: Container(
                color: Color(0xfff3f3f3),
                child: Obx(() {
                  return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: refreshController,
                    onRefresh: () {
                      page = 1;
                      refreshController.resetNoData();
                      getPageList();
                    },
                    onLoading: () {
                      page++;
                      getPageList();
                    },
                    child: rechargeList.length == 0
                        ? buildEmptyContainer()
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: rechargeList.length,
                            itemBuilder: (context, index) =>
                                buildOrderItem(context, rechargeList[index])),
                  );
                }),
              )),
            ],
          ),
          // 下拉菜单，注意GZXDropDownMenu目前只能在Stack内，后续有时间会改进，以及支持CustomScrollView和NestedScrollView
          GZXDropDownMenu(
            // controller用于控制menu的显示或隐藏
            controller: dropdownMenuController,
            // 下拉菜单显示或隐藏动画时长
            animationMilliseconds: 300,
            // 下拉后遮罩颜色
//          maskColor: Theme.of(context).primaryColor.withOpacity(0.5),
//          maskColor: Colors.red.withOpacity(0.5),
            dropdownMenuChanging: (isShow, index) {
              // setState(() {
              //   _dropdownMenuChange = '(正在${isShow ? '显示' : '隐藏'}$index)';
              //   print(_dropdownMenuChange);
              // });
            },
            dropdownMenuChanged: (isShow, index) {
              // setState(() {
              //   _dropdownMenuChange = '(已经${isShow ? '显示' : '隐藏'}$index)';
              //   print(_dropdownMenuChange);
              // });
            },
            // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
            menus: [
              GZXDropdownMenuBuilder(
                  dropDownHeight: 40.0 * typeGroup.length,
                  dropDownWidget: ListView.builder(
                      itemCount: typeGroup.length,
                      itemBuilder: ((context, index) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            typeId.value = typeGroup[index]['TypeId'];
                            typeName.value = typeGroup[index]['name'];
                            page = 1;
                            rechargeList.value = [];
                            getPageList();
                            dropdownMenuController.hide();
                          },
                          child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(typeGroup[index]['name'])))))),
              GZXDropdownMenuBuilder(
                  dropDownHeight: 40.0 * stateGroup.length,
                  dropDownWidget: ListView.builder(
                      itemCount: stateGroup.length,
                      itemBuilder: ((context, index) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            state.value = stateGroup[index]['State'];
                            stateName.value = stateGroup[index]['name'];
                            page = 1;
                            rechargeList.value = [];
                            getPageList();
                            dropdownMenuController.hide();
                          },
                          child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(stateGroup[index]['name'])))))),
              GZXDropdownMenuBuilder(
                  dropDownHeight: 40.0 * rechargeTypeGroup.length,
                  dropDownWidget: ListView.builder(
                      itemCount: rechargeTypeGroup.length,
                      itemBuilder: ((context, index) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            rechargeType.value =
                                rechargeTypeGroup[index]['State'];
                            rechargeTypeName.value =
                                rechargeTypeGroup[index]['name'];
                            page = 1;
                            rechargeList.value = [];
                            getPageList();
                            dropdownMenuController.hide();
                          },
                          child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child:
                                  Text(rechargeTypeGroup[index]['name'])))))),
            ],
          )
        ],
      ),
    );
  }

  ///暂无数据
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
              '暂无数据',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildOrderItem(BuildContext context, account) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '充值账号：${account['UserId']}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                (account['TypeId'] == 1 ? '师傅姓名：' : '工厂名称：') +
                    '${account['UserName']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '账号类型：${account['TypeName']}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '交易平台：${account['OriginName']}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '支付方式：${account['RechargeTypeName']}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '充值时间：${account['AddTime']}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '交易状态：${account['StateName']}',
                style: TextStyle(
                    fontSize: 16,
                    color: account['State'] == 1
                        ? Colors.green
                        : account['State'] == -1
                            ? Colors.red
                            : Colors.yellow),
              ),
              Text(
                '充值金额：${account['Amount']}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
