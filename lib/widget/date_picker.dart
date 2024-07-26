import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateFormat

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime?, DateTime?)? onDateRangeSelected;

  DatePickerWidget({this.onDateRangeSelected});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? now,
        end: endDate ?? now,
      ),
      firstDate: DateTime(now.year - 10), // Date range starts from 10 years ago
      lastDate: DateTime(now.year + 10), // Date range goes up to 10 years ahead
    );

    if (result != null) {
      setState(() {
        startDate = result.start;
        endDate = result.end;
      });
      if (widget.onDateRangeSelected != null) {
        widget.onDateRangeSelected!(startDate, endDate);
      }
    }
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
