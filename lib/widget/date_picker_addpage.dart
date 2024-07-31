import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerAddWidget extends StatefulWidget {
  final Function(DateTime?)? onDateSelected;

  DatePickerAddWidget({this.onDateSelected});

  @override
  _DatePickerAddWidgetState createState() => _DatePickerAddWidgetState();
}

class _DatePickerAddWidgetState extends State<DatePickerAddWidget> {
  DateTime? selectDate;

  void _selectDate(BuildContext context) {
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
              selectionMode: DateRangePickerSelectionMode.single,
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              initialSelectedDate: selectDate,
              maxDate: DateTime.now(),
              minDate: DateTime(DateTime.now().year - 10),
              onCancel: () {
                Navigator.of(context).pop();
              },
              showActionButtons: true,
              onSubmit: (value) {
                if (value != null && value is DateTime) {
                  setState(() {
                    selectDate = value;
                  });
                  if (widget.onDateSelected != null) {
                    widget.onDateSelected!(selectDate);
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
      onTap: () => _selectDate(context),
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
            selectDate != null 
              ? DateFormat('dd MMM yyyy').format(selectDate!)
              : DateFormat('dd MMM yyyy').format(now), // Show current date if no date is selected
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
    );
  }
}
