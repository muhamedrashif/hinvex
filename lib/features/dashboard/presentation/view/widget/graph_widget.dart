import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({
    super.key,
    // required this.title,
    this.isAverage = false,
  });

  // final String title;
  final bool isAverage;

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  List<Color> gradientColors = [
    const Color.fromARGB(95, 0, 0, 0),
    const Color.fromARGB(255, 0, 0, 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              widget.isAverage ? avgData() : mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    late Widget text;
    const style = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR');
        break;
      case 5:
        text = const Text(
          'JUN',
        );
        break;
      case 8:
        text = const Text(
          'SEP',
        );
        break;
      default:
        text = const Text(
          '',
        );
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    late String text;
    switch (value.toInt()) {
      case 1:
        text = '200';
        break;
      case 3:
        text = '400';
        break;
      case 5:
        text = '500';
        break;
      default:
        text = '';
        break;
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return _generateChartData(false);
  }

  LineChartData avgData() {
    return _generateChartData(true);
  }

  LineChartData _generateChartData(bool isAverage) {
    List<HorizontalLine> extraLines = [];

    // Add horizontal lines at y = 0 with caps of unit length in the x-axis
    for (double i = 0; i <= 11; i++) {
      extraLines.add(HorizontalLine(
        y: 0,
        color: Colors.black,
        strokeWidth: 2,
        dashArray: [5, 5], // Customize this array to control dash pattern
        label: HorizontalLineLabel(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      ));
    }

    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      extraLinesData: ExtraLinesData(horizontalLines: extraLines),
    );
  }
}

class GraphWidgetnew extends StatefulWidget {
  const GraphWidgetnew({
    Key? key,
    // required this.title,
    this.isAverage = false,
  }) : super(key: key);

  // final String title;
  final bool isAverage;

  @override
  State<GraphWidgetnew> createState() => _GraphWidgetnewState();
}

class _GraphWidgetnewState extends State<GraphWidgetnew> {
  List<Color> gradientColors = [
    Color.fromARGB(95, 0, 0, 0),
    Color.fromARGB(255, 0, 0, 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              widget.isAverage ? avgData() : mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    late Widget text;
    const style = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
    );
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR');
        break;
      case 5:
        text = const Text(
          'JUN',
        );
        break;
      case 8:
        text = const Text(
          'SEP',
        );
        break;
      default:
        text = const Text(
          '',
        );
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    late String text;
    switch (value.toInt()) {
      case 1:
        text = '200';
        break;
      case 3:
        text = '400';
        break;
      case 5:
        text = '500';
        break;
      default:
        text = '';
        break;
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return _generateChartData(false);
  }

  LineChartData avgData() {
    return _generateChartData(true);
  }

  LineChartData _generateChartData(bool isAverage) {
    List<HorizontalLine> extraLines = [];

    // Add horizontal lines at y = 0 with caps of unit length in the x-axis
    for (double i = 0; i <= 11; i++) {
      extraLines.add(HorizontalLine(
        y: 0,
        color: Colors.black,
        strokeWidth: 2,
        dashArray: [5, 5], // Customize this array to control dash pattern
        label: HorizontalLineLabel(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      ));
    }

    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 5),
            FlSpot(9, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      extraLinesData: ExtraLinesData(horizontalLines: extraLines),
    );
  }
}
