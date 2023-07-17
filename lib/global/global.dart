
/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:24:38
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-06-14 14:22:39
 * @FilePath: /xigyu_manager/lib/api/api.dart
 * @Description: 全局变量
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info/package_info.dart';

///当前版本信息
Rx<PackageInfo> packageInfo =
    PackageInfo(appName: '', packageName: '', version: '--', buildNumber: '').obs;

///当前登录ID
RxString loginId = ''.obs;

///是否是超级管理员
RxBool isAdmin = false.obs;

///token
RxString token = ''.obs;

///当前登录账号
RxMap account = RxMap();

///缓存
GetStorage box = GetStorage();

///选中的操作组ID
RxInt groupId = (-1).obs;

///选中的客服ID
RxInt serviceId = (-1).obs;

///选中的工厂ID
RxInt factoryId = (-1).obs;

///主题色
Color mainColor = Colors.blue;

///工单数量
RxList orderNum = [
  {'key': 'All', 'name': '全部', 'count': 0, 'state': -1}.obs,
  {'key': 'WaipPintNum', 'name': '未分配', 'count': 0, 'state': 0}.obs,
  {'key': 'UnAssignNum', 'name': '未指派', 'count': 0, 'state': 1}.obs,
  {'key': 'UnTackNum', 'name': '未接单', 'count': 0, 'state': 2}.obs,
  {'key': 'AppoinNum', 'name': '未预约', 'count': 0, 'state': 3}.obs,
  {'key': 'DoorNum', 'name': '未上门', 'count': 0, 'state': 4}.obs,
  {'key': 'ServiceNum', 'name': '服务中', 'count': 0, 'state': 5}.obs,
  {'key': 'ThingNum', 'name': '待返件', 'count': 0, 'state': 13}.obs,
  {'key': 'AuditNum', 'name': '待核实', 'count': 0, 'state': 6}.obs,
  {'key': 'TagNum', 'name': '标记工单', 'count': 0, 'state': 14}.obs,
  {'key': 'CheckNum', 'name': '待审核', 'count': 0, 'state': 7}.obs,
  {'key': 'StayCompletedNum', 'name': '待完结', 'count': 0, 'state': 9}.obs,
  {'key': 'StayAbolishNum', 'name': '待废除', 'count': 0, 'state': 8}.obs,
  {'key': 'CompletedNum', 'name': '已完结', 'count': 0, 'state': 11}.obs,
  {'key': 'EndOrderNum', 'name': '二次完结', 'count': 0, 'state': 12}.obs,
  {'key': 'RunAbolishNum', 'name': '已废除', 'count': 0, 'state': 10}.obs,
].obs;
