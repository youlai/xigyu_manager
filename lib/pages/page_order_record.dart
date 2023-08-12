// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/utils/utils.dart';
import 'package:xigyu_manager/widgets/gallery.dart';

class OrderRecordPage extends StatefulWidget {
  List recordList;

  OrderRecordPage(this.recordList);

  @override
  State<StatefulWidget> createState() {
    return OrderRecordPageState();
  }
}

class OrderRecordPageState extends State<OrderRecordPage> {
  List get recordList => widget.recordList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('工单跟踪', [], context),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        buildListView(context),
      ],
    );
  }

  Widget buildListView(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
            //想设置item为固定高度可以设置这个，不过文本过长就显示不全了
//            itemExtent: 100,
            itemCount: recordList == null ? 0 : recordList.length,
            itemBuilder: (BuildContext context, int position) {
              return buildListViewItem(context, position);
            }),
      ),
    );
  }

  Widget buildListViewItem(BuildContext context, int position) {
    String imgList = recordList[position]['FilePath'];
    List<String> urlList = [];
    if (imgList != null) {
      urlList = imgList.split(',');
    }
    if (recordList.length != 0) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, right: 10),
        child: IntrinsicHeight(
          child: Row(
            children: [
              //这个Container描绘左侧的线和圆点
              Container(
                margin: EdgeInsets.only(left: 10),
                width: 20,
                child: Column(
                  //中心对齐，
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade200,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
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
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          width: position == recordList.length - 1 ? 0 : 1,
                          color: Colors.grey.shade300,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(
                        data: recordList[position]['HideContent'] ?? '--',
                        shrinkWrap: true,
                        // style: TextStyle(
                        //   fontSize: 15,
                        //   //第一个item字体颜色为绿色+稍微加粗
                        //   color: position == 0 ? mainColor : Colors.black,
                        //   fontWeight: position == 0 ? FontWeight.w600 : null,
                        // ),
                      ),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: List.generate(
                            urlList.length,
                            (index) => SizedBox(
                                width: 40,
                                height: 40,
                                child: buildItem(context, index, urlList))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        recordList[position]['AddTime'],
                        style: TextStyle(
                          fontSize: 15,
                          //第一个item字体颜色为绿色+稍微加粗
                          color: position == 0 ? mainColor : Colors.grey,
                          fontWeight: position == 0 ? FontWeight.w600 : null,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        recordList[position]['CreateUserId'],
                        style: TextStyle(
                          fontSize: 15,
                          //第一个item字体颜色为绿色+稍微加粗
                          color: position == 0 ? mainColor : Colors.black,
                          fontWeight:
                              position == 0 ? FontWeight.w600 : FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
