import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout_apps/datetime/date_time.dart';

class CalendarHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;
  const CalendarHeatMap(
      {super.key, required this.datasets, required this.startDateYYYYMMDD});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        defaultColor: Colors.grey.shade300,
        textColor: Colors.black87,
        showColorTip: false,
        scrollable: true,
        showText: true,
        size: 30,
        colorsets: {
          1: Colors.green.shade400,
        },
      ),
    );
  }
}
