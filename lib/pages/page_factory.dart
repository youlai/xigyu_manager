// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, sdk_version_ui_as_code

/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:20:05
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-04-13 17:47:26
 * @FilePath: /xigyu_manager/lib/main.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/utils/request_util.dart';
import 'package:xigyu_manager/utils/utils.dart';

class FactoryManage extends StatefulWidget {
  ///0有取消按钮 1无取消按钮
  int type;
  FactoryManage({Key? key, this.type = 0}) : super(key: key);

  @override
  State<FactoryManage> createState() => _FactoryManageState();
}

class _FactoryManageState extends State<FactoryManage> {
  RxList enumList = [].obs;
  RxList accountList = [].obs;
  int page = 1;
  int rows = 20;
  RxString keyword = ''.obs;

  ///充值类型
  RxInt type = 0.obs;
  String money = '';

  RefreshController refreshController = RefreshController();
  // The focus node to use for manipulating focus on the search page. This is
  // managed, owned, and set by the _SearchPageRoute using this delegate.
  late FocusNode _focusNode;

  final TextEditingController _queryTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getEnum();
    getFactoryAccount();
  }

  ///获取枚举
  getEnum() {
    RequestUtil.post(Api.getEnum, {
      'LoginId': loginId.value,
      'Name': 'RechargeType',
      'IsAll': '1',
      'NotIn': '0,1'
    }).then((value) {
      if (value['Success']) {
        enumList.value=value['rows'];
        enumList.insert(0, {'Value': 0, 'Name': '充值类型'});
      }
    });
  }
  ///获取工厂账号
  getFactoryAccount() {
    RequestUtil.post(Api.getFactoryAccount, {
      'LoginId': loginId.value,
      'UserId': keyword.value,
      'IsCertify': '-1',
      'IsSend': '-1',
      // 'IsUse': 0,
      'Page': page,
      'Rows': rows,
      'Order': 'desc',
      'Sort': 'Amount',
    }).then((value) {
      if (value['Success']) {
        refreshController.refreshCompleted();
        refreshController.loadComplete();
        List list = value['rows']['rows'];
        if (page == 1) {
          accountList.value = list;
        } else {
          if (list.isNotEmpty) {
            accountList.addAll(list);
          } else {
            refreshController.loadNoData();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          leading: null,
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 60),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryTextController,
                    // focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {
                      page = 1;
                      getFactoryAccount();
                    },
                    onChanged: (txt) {
                      keyword.value = txt;
                    },
                    onSubmitted: (txt) {
                      keyword.value = txt;
                      page = 1;
                      getFactoryAccount();
                    },
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: '请输入工厂账号或名称'),
                  ),
                ),
                Obx(() => Visibility(
                      visible: keyword.isNotEmpty,
                      child: GestureDetector(
                          onTap: () {
                            keyword.value = '';
                            _queryTextController.text = '';
                            page = 1;
                            getFactoryAccount();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey[200],
                          )),
                    ))
              ],
            ),
          ),
          actions: [
            if (widget.type == 0)
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  pop(context);
                },
              )
          ],
        ),
        body: Obx(() => accountList.isEmpty
            ? Center(child: Text('暂无数据'))
            : SmartRefresher(
                controller: refreshController,
                enablePullUp: true,
                onRefresh: () {
                  page = 1;
                  refreshController.resetNoData();
                  getFactoryAccount();
                },
                onLoading: () {
                  page++;
                  getFactoryAccount();
                },
                child: ListView.builder(
                    itemBuilder: ((context, index) => Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('登录账号：${accountList[index]['UserId']}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('工厂名称：${accountList[index]['NickName']}'),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          '可用余额：${accountList[index]['Amount']}')),
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (c) => AlertDialog(
                                                  title: Text('充值'),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('充值类型：'),
                                                          Expanded(
                                                              child: Obx(() =>
                                                                  DropdownButton(
                                                                      hint: Text(
                                                                          '充值类型'),
                                                                      value: type
                                                                          .value,
                                                                      isExpanded:
                                                                          true,
                                                                      isDense:
                                                                          true,
                                                                      items: enumList.map((element) => DropdownMenuItem(
                                                                            child:
                                                                                Text(element['Name']),
                                                                            value: element['Value'])).toList(),
                                                                      onChanged:
                                                                          (value) {
                                                                        type.value =
                                                                            value as int;
                                                                      }))),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('充值金额：'),
                                                          Expanded(
                                                              child: TextField(
                                                            onChanged:
                                                                ((value) {
                                                              money = value;
                                                            }),
                                                            keyboardType:
                                                                TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        '请输入金额'),
                                                          )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          pop(context);
                                                        },
                                                        child: Text('取消')),
                                                    TextButton(
                                                        onPressed: () {
                                                          if (type.value ==
                                                              0) {
                                                            showToast(
                                                                '请选择充值类型');
                                                            return;
                                                          }
                                                          if (money.isEmpty) {
                                                            showToast(
                                                                '请输入充值金额');
                                                            return;
                                                          }
                                                          if (double.parse(
                                                                  money) ==
                                                              0) {
                                                            showToast('金额不能为0');
                                                            return;
                                                          }
                                                          RequestUtil
                                                              .showLoadingDialog(
                                                                  context);
                                                          RequestUtil.post(
                                                              Api.topupAmount, {
                                                            'LoginId':
                                                                loginId.value,
                                                            'FactoryUserId':
                                                                accountList[
                                                                        index]
                                                                    ['UserId'],
                                                            'FunState':
                                                                type.value,
                                                            'Remark': '',
                                                            'Num': money
                                                          }).then((value) {
                                                            RequestUtil
                                                                  .hiddenLoadingDialog(
                                                                      context);
                                                            if (value[
                                                                'Success']) {
                                                              showToast('充值成功');
                                                              page=1;
                                                              getFactoryAccount();
                                                              pop(context);
                                                            } else {
                                                              showToast(
                                                                  value['msg']);
                                                            }
                                                          });
                                                        },
                                                        child: Text('确定')),
                                                  ],
                                                ));
                                      },
                                      child: Text('充值'))
                                ],
                              ),
                              Text('暂冻结：${accountList[index]['FrozenAmount']}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('已结算：${accountList[index]['WithAmount']}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('总充值：${accountList[index]['Recharge']}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('入驻时间：${accountList[index]['AddTime']}'),
                            ],
                          ),
                        ))),
                    itemCount: accountList.length),
              )));
  }
}
