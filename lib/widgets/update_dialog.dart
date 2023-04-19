// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UpdateDialog extends StatefulWidget {
  final key;
  final Map upgradeInfo;
  final Function onClickWhenDownload;
  final Function onClickWhenNotDownload;

  UpdateDialog({
    this.key,
    this.upgradeInfo,
    this.onClickWhenDownload,
    this.onClickWhenNotDownload,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => UpdateDialogState();
}

class UpdateDialogState extends State<UpdateDialog> {
  int _downloadProgress = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      getExternalStorageDirectory().then((tempDir) {
        String tempPath = tempDir.path;
        String savePath =
            '$tempPath/update_${widget.upgradeInfo['buildVersion']}.apk';
        File file = File(savePath);
        file.exists().then((value) async {
          setState(() {
            if (value) {
              _downloadProgress = 100;
            } else {
              _downloadProgress = 0;
            }
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_downloadProgress:$_downloadProgress');
    var _textStyle = TextStyle(fontSize: 12);
    double width = MediaQuery.of(context).size.width - 48;
    double height = MediaQuery.of(context).size.height / 2;
    var btnTxt = '立即更新';
    if (_downloadProgress == 0) {
      btnTxt = '立即更新';
    } else if (_downloadProgress > 0 && _downloadProgress < 100) {
      btnTxt = '$_downloadProgress%';
    } else {
      btnTxt = '安装';
    }
    return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    'assets/tc_head.png',
//            width: double.infinity,
                    height: width * 382 / 792,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                      bottom: 15,
                      child: Text(
                        '版本：v${widget.upgradeInfo['buildVersion']}    大小：${getPrintSize(int.parse(widget.upgradeInfo['buildFileSize']))}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ))
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: Text(
                        "更新说明：\n${widget.upgradeInfo['buildUpdateDescription'] == '' ? '暂无说明' : widget.upgradeInfo['buildUpdateDescription']}",
                        style: _textStyle,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5))),
                child: Row(
                  children: [
                    Visibility(
                      ///是否强制更新
                      visible: !widget.upgradeInfo['needForceUpdate'],
                      child: Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: OutlinedButton(
                            child: Text(
                              '下次再说',
                              style: _textStyle,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OutlinedButton(
                          child: Text(
                            btnTxt,
                            style: _textStyle,
                          ),
                          onPressed: () {
                            if (_downloadProgress != 0 &&
                                _downloadProgress != 100) {
                              widget.onClickWhenDownload("正在更新中");
                              return;
                            }
                            widget.onClickWhenNotDownload();
//                          Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
//      actions: <Widget>[
//         TextButton(
//          child:  Text(
//            '更新',
//            style: _textStyle,
//          ),
//          onPressed: () {
//            if (_downloadProgress != 0.0) {
//              widget.onClickWhenDownload("正在更新中");
//              return;
//            }
//            widget.onClickWhenNotDownload();
////            Navigator.of(context).pop();
//          },
//        ),
//         TextButton(
//          child:  Text('取消'),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//      ],
        );
  }

//size.substring(0,size.indexOf(".")+3) 小数点位数
  getPrintSize(limit) {
    String size = "";
    //内存转换
    if (limit < 1 * 1024) {
      //小于0.1KB，则转化成B
      size = limit.toString();
      size = size.substring(0, size.indexOf(".") + 3) + "  B";
    } else if (limit < 1 * 1024 * 1024) {
      //小于0.1MB，则转化成KB
      size = (limit / 1024).toString();
      size = size.substring(0, size.indexOf(".") + 3) + "  KB";
    } else if (limit < 1 * 1024 * 1024 * 1024) {
      //小于0.1GB，则转化成MB
      size = (limit / (1024 * 1024)).toString();
      print(size.indexOf("."));
      size = size.substring(0, size.indexOf(".") + 3) + "  MB";
    } else {
      //其他转化成GB
      size = (limit / (1024 * 1024 * 1024)).toString();
      size = size.substring(0, size.indexOf(".") + 3) + "  GB";
    }
    return size;
  }

  set progress(_progress) {
    setState(() {
      _downloadProgress = _progress;
//      if (_downloadProgress == 100) {
//        Navigator.of(context).pop();
//        _downloadProgress = 0;
//      }
    });
  }
}
