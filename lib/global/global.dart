/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:24:38
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-04-11 15:55:36
 * @FilePath: /xigyu_manager/lib/api/api.dart
 * @Description: 全局变量
 */
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info/package_info.dart';

///当前版本信息
Rx<PackageInfo> packageInfo=Rxn();

///当前登录ID
RxString loginId = ''.obs;

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
