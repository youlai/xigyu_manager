/// 
/// Author: youlai 761364115@qq.com
/// Date: 2023-07-11 09:16:28
/// LastEditors: youlai 761364115@qq.com
/// LastEditTime: 2023-07-11 10:00:08
/// FilePath: /xigyu_manager/lib/pages/bar_chart/bar_chart_page3.dart
/// Description: 
/// 

import 'package:flutter/material.dart';
import 'package:xigyu_manager/pages/bar_chart/samples/bar_chart_sample6.dart';
import 'package:xigyu_manager/pages/bar_chart/samples/bar_chart_sample7.dart';

import '../bar_chart/samples/bar_chart_sample3.dart';
import '../bar_chart/samples/bar_chart_sample4.dart';
import '../bar_chart/samples/bar_chart_sample5.dart';

class BarChartPage3 extends StatelessWidget {
  const BarChartPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const <Widget>[
          BarChartSample7(),
          SizedBox(
            height: 18,
          ),
          BarChartSample3(),
          SizedBox(
            height: 18,
          ),
          BarChartSample5(),
          SizedBox(
            height: 18,
          ),
          BarChartSample6(),
          SizedBox(
            height: 18,
          ),
          BarChartSample4(),
        ],
      ),
    );
  }
}
