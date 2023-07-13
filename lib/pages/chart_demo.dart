///
/// Author: youlai 761364115@qq.com
/// Date: 2023-07-13 14:31:40
/// LastEditors: youlai 761364115@qq.com
/// LastEditTime: 2023-07-13 14:35:42
/// FilePath: /xigyu_manager/lib/pages/chart_demo.dart
/// Description:
///
/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

///Renders default line series chart
class LineDefault extends StatefulWidget {
  List<Map> data;

  ///Creates default line series chart
  LineDefault({Key? key, required this.data}) : super(key: key);

  @override
  _LineDefaultState createState() => _LineDefaultState();
}

class _LineDefaultState extends State<LineDefault> {
  _LineDefaultState();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultLineChart();
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: '工单操作量'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
          // labelFormat: '{value}%',
          axisLine: AxisLine(width: 1),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: _getDefaultLineSeries(),
      zoomPanBehavior: ZoomPanBehavior(
          enableDoubleTapZooming: true,
          enablePinching: true,
          enableMouseWheelZooming: true,
          enableSelectionZooming: true,
          enablePanning: true),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<Map, String>> _getDefaultLineSeries() {
    return <LineSeries<Map, String>>[
      LineSeries<Map, String>(
          animationDuration: 2500,
          dataSource: widget.data,
          xValueMapper: (Map item, _) => item['AccountName'],
          yValueMapper: (Map item, _) => item['BrowseNum'],
          width: 2,
          name: '浏览量',
          markerSettings: MarkerSettings(isVisible: false)),
      LineSeries<Map, String>(
          animationDuration: 2500,
          dataSource: widget.data,
          width: 2,
          name: '操作量',
          xValueMapper: (Map item, _) => item['AccountName'],
          yValueMapper: (Map item, _) => item['RecordNum'],
          markerSettings: MarkerSettings(isVisible: false))
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}
