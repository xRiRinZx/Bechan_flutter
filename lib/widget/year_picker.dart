import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class YearPickerWidget extends StatefulWidget {
  final Function(DateTime?)? onYearSelected;

  YearPickerWidget({this.onYearSelected, DateTime? selectedYear, DateTime? selectedMonth});

  @override
  _YearPickerWidgetState createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  DateTime? selectedYear;

  void _selectYear(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: SfDateRangePicker(
              maxDate: DateTime.now(),
              showNavigationArrow: true,
              allowViewNavigation: false,
              view: DateRangePickerView.decade,
              backgroundColor: Colors.white,
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onCancel: () {
                Navigator.of(context).pop();
              },
              showActionButtons: true,
              onSubmit: (value) {
                if (value != null && value is DateTime) {
                  setState(() {
                    selectedYear = value;
                  });
                  if (widget.onYearSelected != null) {
                    widget.onYearSelected!(selectedYear);
                  }
                }
                Navigator.of(context).pop();
              },
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: selectedYear ?? DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return GestureDetector(
      onTap: () => _selectYear(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              offset: const Offset(0, 2), // Shadow position
              blurRadius: 4, // Blur radius of the shadow
            ),
          ],
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              selectedYear != null
                  ? DateFormat('yyyy').format(selectedYear!)
                  : DateFormat('yyyy').format(now), // Show current month and year if no date is selected
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
