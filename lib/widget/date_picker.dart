import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime?, DateTime?)? onDateRangeSelected;

  DatePickerWidget({this.onDateRangeSelected});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? startDate;
  DateTime? endDate;

  void _selectDateRange(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            width: double.maxFinite, // Adjust the width as needed
            height: 300, // Adjust the height as needed
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              backgroundColor: Colors.white,
              selectionMode: DateRangePickerSelectionMode.range,
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              initialSelectedRange: startDate != null && endDate != null
                  ? PickerDateRange(startDate!, endDate!)
                  : null,
              maxDate: DateTime.now(),
              minDate: DateTime(DateTime.now().year - 10),
              onCancel: () {
                Navigator.of(context).pop();
              },
              showActionButtons: true,
              onSubmit: (value) {
                if (value != null && value is PickerDateRange) {
                  setState(() {
                    startDate = value.startDate;
                    endDate = value.endDate ?? value.startDate;
                  });
                  if (widget.onDateRangeSelected != null) {
                    widget.onDateRangeSelected!(startDate, endDate);
                  }
                }
                Navigator.of(context).pop();
              },
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
      onTap: () => _selectDateRange(context),
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
              startDate != null && endDate != null
                  ? (startDate!.isAtSameMomentAs(endDate!)
                      ? DateFormat('dd MMM yyyy').format(startDate!)
                      : '${DateFormat('dd MMM yyyy').format(startDate!)} - ${DateFormat('dd MMM yyyy').format(endDate!)}')
                  : DateFormat('dd MMM yyyy').format(now), // Show current date if no range is selected
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
