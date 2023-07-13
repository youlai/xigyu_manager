/*
 * @Author: youlai 761364115@qq.com
 * @Date: 2023-04-03 10:24:38
 * @LastEditors: youlai 761364115@qq.com
 * @LastEditTime: 2023-05-20 15:19:56
 * @FilePath: /xigyu_manager/lib/api/api.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
class Api {
  // static String baseUrl = 'http://192.168.0.95:8810/api/';
  // static String baseUrl = 'http://192.168.101.82:8810/api/';
  // static String baseUrl = 'http://192.168.0.203:8810/api/';
  // static String baseUrl = 'http://192.168.0.26:8810/api/';
  // static String baseUrl = 'http://192.168.0.50:8098/';
  // static String baseUrl = 'http://192.168.0.21:6589/';
  static String baseUrl = 'https://newapi.xigyu.com/';
  // static String baseUrl = 'https://api.xigyu.com/api/';

  ///------------------------------------api--------------------------------------

  //==========新版接口==========
  ///登录
  static String login = "Account/Login";

  ///获取账号角色
  static String getUserRoler = "Roler/GetUserRoler";

  ///注册入驻
  static String register = "Master/Account/Add";

  ///获取角色菜单
  static String getRolerList = "Menu/GetRolerList";

  ///查询工厂账号
  static String getFactoryAccount = "FactoryAccount/GetPageList";

  ///获取枚举
  static String getEnum = "Enum/GetList";

  ///工厂充值
  static String topupAmount = "FactoryAccount/TopupAmount";

  ///获取统计数量
  static String getOrderNum = "Order/GetOrderNum";

  ///获取急需处理数量
  static String getHomePanel = "Order/GetHomePanel";

  ///获取工单面板数量
  static String getOrderPanelNum = "Order/GetOrderPanelNum";

  ///获取工单面板急需处理数量 (今日)
  static String getDealwithPanelNum = "Order/GetDealwithPanelNum";

  ///获取工单面板急需处理数量（昨日）
  static String dealwithPanelGetNum = "DealwithPanel/GetNum";

  ///获取工单面板快捷操作数量
  static String getOperatePanelNum = "Order/GetOperatePanelNum";

  ///操作组
  static String getGroupList = "Group/GetList";

  ///工厂
  static String getFactoryList = "FactoryAccount/GetSelect";

  ///所属操作组
  static String getGroup = "Account/GetGroup";

  ///操作组下客服
  static String getServiceAccount = "ServiceAccount/GetList";

  ///工单列表
  static String getPageList = "Order/GetPageList";

  ///工单详情
  static String getDetail = "Order/GetDetail";

  ///师傅列表
  static String getPageSpace = "MasterAccount/GetPageSpace";

  ///指派师傅
  static String assignMaster = "Order/AssignMaster";

  ///禁用师傅
  static String forbidMaster = "MasterAccount/Disable";

  ///获取充值列表
  static String getRechargeList = "Recharge/GetPageList";

  ///获取工厂工单量
  static String getFactoryOrderNum = "Order/GetFactoryOrderNum";

  ///客服利润率
  static String profitAdminRate = "Account/ProfitAdminRate";

  ///费用申请率
  static String feeRate = "Account/FeeRate";

  ///留存率
  static String totalRate = "Account/TotalRate";

  ///完结时效率
  static String endRate = "Account/EndRate";

  ///工单操作量
  static String getNum = "OrderAccess/GetNum";

  ///用户联系量
  static String getContactUseNum = "Order/GetContactUseNum";
}
