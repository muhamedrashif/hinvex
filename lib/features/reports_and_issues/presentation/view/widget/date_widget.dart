// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hinvex/features/reports_and_issues/presentation/provider/report_and_issue_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangeService extends StatefulWidget {
  const DateRangeService({
    super.key,
  });

  @override
  State<DateRangeService> createState() => _DateRangeServiceState();
}

class _DateRangeServiceState extends State<DateRangeService> {
  String _range = '';
  late DateTime _startDate;
  late DateTime _endDate;
  // ignore: unused_field
  bool _reportsFetched = false;

  @override
  void initState() {
    super.initState();
    _clearList();
    _startDate = DateTime.now().subtract(const Duration(days: 30));
    _endDate = DateTime.now();
    _updateRangeString();
  }

  void _updateRangeString() {
    _range =
        '${DateFormat('dd/MM/yyyy').format(_startDate)} - ${DateFormat('dd/MM/yyyy').format(_endDate)}';
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = args.value.startDate;
        _endDate = args.value.endDate ?? args.value.startDate;
        _updateRangeString();
      }
    });
  }

  void _clearList() {
    Provider.of<ReportsAndIssuesProvider>(context, listen: false)
        .clearFetchReportList();
  }

  // void _onOkPressed() {
  //   if (_startDate != null && _endDate != null && !_reportsFetched) {
  //     Provider.of<ReportsAndIssuesProvider>(context, listen: false)
  //         .fetchReports(startDate: _startDate, endDate: _endDate);
  //     Provider.of<ReportsAndIssuesProvider>(context, listen: false)
  //         .fetchNextReports(startDate: _startDate, endDate: _endDate);
  //     _reportsFetched = true;
  //   }
  //   Navigator.of(context).pop();
  // }

  // void _onCancelPressed() {
  //   if (_startDate != null && _endDate != null && !_reportsFetched) {
  //     Provider.of<ReportsAndIssuesProvider>(context, listen: false)
  //         .fetchReports(
  //             startDate: DateTime.now().subtract(const Duration(days: 30)),
  //             endDate: DateTime.now());
  //     Provider.of<ReportsAndIssuesProvider>(context, listen: false)
  //         .fetchNextReports(
  //             startDate: DateTime.now().subtract(const Duration(days: 30)),
  //             endDate: DateTime.now());
  //     _reportsFetched = true;
  //   }
  //   Navigator.of(context).pop();
  // }

  void _onOkPressed() {
    try {
      if (_startDate != null && _endDate != null) {
        Provider.of<ReportsAndIssuesProvider>(context, listen: false)
            .fetchReports(startDate: _startDate, endDate: _endDate);
        Provider.of<ReportsAndIssuesProvider>(context, listen: false)
            .fetchNextReports(startDate: _startDate, endDate: _endDate);
        _reportsFetched = true;
      }
    } catch (error) {
      log('Error occurred while sending dates: $error');
    }
    Navigator.of(context).pop();
  }

  void _onCancelPressed() {
    try {
      if (_startDate != null && _endDate != null) {
        Provider.of<ReportsAndIssuesProvider>(context, listen: false)
            .fetchReports(startDate: _startDate, endDate: _endDate);
        Provider.of<ReportsAndIssuesProvider>(context, listen: false)
            .fetchNextReports(startDate: _startDate, endDate: _endDate);
        _reportsFetched = true;
      }
    } catch (error) {
      log('Error occurred while sending dates: $error');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                width: 500,
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  maxDate: DateTime.now(),
                  initialSelectedRange: PickerDateRange(_startDate, _endDate),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'Selected range: $_range',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _onOkPressed,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: sentButtonColor),
                          child: const Text('OK',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _onCancelPressed,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: sentButtonColor),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
