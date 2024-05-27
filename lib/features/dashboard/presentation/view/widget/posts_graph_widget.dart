import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PostGraphWidget extends StatefulWidget {
  const PostGraphWidget({
    super.key,
    this.isAverage = false,
  });

  final bool isAverage;

  @override
  State<PostGraphWidget> createState() => _PostGraphWidgetState();
}

class _PostGraphWidgetState extends State<PostGraphWidget> {
  Color lineColor = const Color(0xFFFFB000);
  // Color shadowColor = Colors.black.withOpacity(1);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 8, left: 8, right: 26, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '21',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.72,
                      ),
                    ),
                    Text(
                      'Posts Added\n    Today',
                      style: TextStyle(
                        fontSize: 9.52,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF929292),
                      ),
                    ),
                    SizedBox(height: 30), // Adjust spacing as needed
                    Text(
                      '210',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.72,
                      ),
                    ),
                    Text(
                      'Posts Added\n  This Week',
                      style: TextStyle(
                        fontSize: 9.52,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF929292),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    width: 20), // Add some space between labels and chart
                Expanded(
                  child: LineChart(
                    widget.isAverage ? avgData() : mainData(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    late Widget text;
    // ignore: unused_local_variable
    const style = TextStyle(
      fontSize: 9.52,
    );
    switch (value.toInt()) {
      case 1:
        text = const Text('Sun');
        break;
      case 3:
        text = const Text('Mon');
        break;
      case 5:
        text = const Text('Tue');
        break;
      case 7:
        text = const Text('Wed');
        break;
      case 9:
        text = const Text('Thu');
        break;
      case 11:
        text = const Text('Fri');
        break;
      case 13:
        text = const Text('Sat');
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainData() {
    return _generateChartData(false);
  }

  LineChartData avgData() {
    return _generateChartData(true);
  }

  LineChartData _generateChartData(bool isAverage) {
    List<HorizontalLine> extraLines = [];

    // Add horizontal lines at each y-axis value
    for (double y = 0; y <= 20; y++) {
      extraLines.add(HorizontalLine(
        y: y,
        color: const Color(0xFFD7D7D7),
        strokeWidth: 1,
        label: HorizontalLineLabel(
          show: false,
          alignment: Alignment.centerRight,
          labelResolver: (line) => y == 0 ? '' : line.y.toString(),
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
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 14,
      minY: 0,
      maxY: 20,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(1, 0),
            FlSpot(3, 4),
            FlSpot(5, 8),
            FlSpot(7, 4),
            FlSpot(9, 6),
            FlSpot(11, 7),
            FlSpot(13, 3),
          ],
          isCurved: true,
          color: lineColor,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
      extraLinesData: ExtraLinesData(horizontalLines: extraLines),
    );
  }
}
