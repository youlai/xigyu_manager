// ignore_for_file: must_be_immutable, unused_import
//@dart=2.9
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http_parser/http_parser.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/utils/request_util.dart';
import 'package:xigyu_manager/utils/utils.dart';
import 'package:xigyu_manager/widgets/grid_images_view.dart';

///工单留言
class LeaveMsgPage extends StatefulWidget {
  String orderid;

  LeaveMsgPage(this.orderid);

  @override
  State<StatefulWidget> createState() {
    return LeaveMsgPageState();
  }
}

class LeaveMsgPageState extends State<LeaveMsgPage> {
  TextEditingController msgCon = TextEditingController();
  ImagesGridviewWidget imagesGridviewWidget;

  @override
  void initState() {
    super.initState();
    imagesGridviewWidget = ImagesGridviewWidget(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('工单留言', [], context),
      //未获取到数据就居中显示加载图标
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        /*输入框*/
        Container(
            margin: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
            padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromARGB(180, 240, 240, 240),
                border: Border.all(width: 0.2, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: TextField(
              controller: msgCon,
              style: TextStyle(fontSize: 13, color: Colors.black),
              maxLines: 4,
//              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: '请输入留言',
                counterText: '',
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            )),
        Container(
          padding: EdgeInsets.all(10),
          child: imagesGridviewWidget,
        ),
        Container(
          color: Colors.transparent,
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.all(10),
          child: RaisedButton(
            onPressed: () {
              if (isFastClick()) return; //防重复点击
              List<String> images = [];
              if (msgCon.text.isEmpty) {
                showToast('内容不能为空');
                return;
              }
              if (imagesGridviewWidget.images.length == 0) {
                RequestUtil.post(Api.leaveMsg, {
                  'LoginId': loginId.value,
                  'OrderNumber': widget.orderid,
                  'MSg': msgCon.text,
                  'FilePath': '',
                }).then((value) {
                  if (value['Success']) {
                    showToast('留言成功');
                    pop(context, true);
                  } else {
                    showToast(value['msg']);
                  }
                });
              } else {
                images.clear();
                RequestUtil.showLoadingDialog(context);
                imagesGridviewWidget.images.forEach((element) async {
                  Dio dio = Dio();
                  String objkey =
                      'TemporaryArea/APP/LeaveMsg/${widget.orderid}/${element.uuid}.jpg';
                  String path = element.asset;
                  File origin = File(path);
                  // print('原图大小：${getPrintSize(origin.lengthSync())}');
                  File file = await FlutterNativeImage.compressImage(path,
                      percentage: 100, quality: 90);
                  // print('压缩后大小：${getPrintSize(file.lengthSync())}');
                  List imageData = file.readAsBytesSync();
                  // List imageData = File(element.asset).readAsBytesSync();
                  MultipartFile multipartFile = MultipartFile.fromBytes(
                    imageData,
                    // 文件名
                    filename: objkey,
                    // 文件类型
                    contentType: MediaType("image", "jpg"),
                  );
                  //表单需要的参数: AccessKeyId、AccessKeySecret、SecurityToken;
                  FormData formdata = new FormData.fromMap({
                    'file': multipartFile
                    //必须放在参数最后
                  });
                  //然后通过存储地址直接把表单(formdata)上传上去;
                  dio.options.responseType = ResponseType.json;
                  var response = await dio.post(Api.baseUrl + Api.uploadImg,
                      data: formdata);
                  if (response.statusCode == 200) {
                    // print(value.data['Data']['host'] + objkey);
                    Map res = response.data;
                    print(res);
                    images.add(res['rows']);
                    if (images.length == imagesGridviewWidget.images.length) {
                      var photo = '';
                      for (int i = 0; i < images.length; i++) {
                        photo += images[i] + ',';
                      }
                      if (photo.contains(',')) {
                        photo = photo.substring(0, photo.lastIndexOf(','));
                      }
                      RequestUtil.post(Api.leaveMsg, {
                        'LoginId': loginId.value,
                        'OrderNumber': widget.orderid,
                        'MSg': msgCon.text,
                        'FilePath': photo,
                      }).then((value) {
                        RequestUtil.hiddenLoadingDialog(context);
                        if (value['Success']) {
                          showToast('留言成功');
                          pop(context, true);
                        } else {
                          showToast(value['msg']);
                        }
                      });
                    }
                  } else {
                    showToast('上传失败，请重试。');
                    RequestUtil.hiddenLoadingDialog(context);
                  }
                });
              }
            },
            child: Text(
              '提交',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          ),
        )
      ],
    );
  }
}
