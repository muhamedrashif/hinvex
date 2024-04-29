import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TestScreen extends StatefulWidget {
  const TestScreen();

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String _range = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _range =
        '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}';
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = args.value.startDate;
        _endDate = args.value.endDate ?? args.value.startDate;
        _range =
            '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}';
      }
    });
  }

  void _onOkPressed() {
    log('Selected start date: $_startDate');
    log('Selected end date: $_endDate');
    Navigator.of(context).pop(); // Close the dialog
  }

  void _onCancelPressed() {
    setState(() {
      // Clear the selected date range.
      _range = '';
      _startDate = DateTime.now();
      _endDate = DateTime.now();
    });
    Navigator.of(context).pop(); // Close the dialog
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
                  initialSelectedRange: PickerDateRange(
                    _startDate!,
                    _endDate!,
                  ),
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
                            backgroundColor: sentButtonColor,
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _onCancelPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sentButtonColor,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
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
