import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart'; // DateTime

class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;

  void _showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Date',textAlign: TextAlign.center,),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
             children: [SfDateRangePicker(
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
              ),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                todayTextStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is DateTime) {
                  setState(() {
                    selectedDate = args.value as DateTime;
                  });
                }
              },
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: DateTime.now(),
              showActionButtons: true,
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (Object? val) {
                Navigator.pop(context);
              },
            ),
             ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // สีเงา
              offset: Offset(0, 2), // ตำแหน่งเงา
              blurRadius: 4, // ระยะการเบลอของเงา
            ),
          ],
        ),
        child: Center(
          child: Text(
            selectedDate != null
                ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                : DateFormat('dd MMMM yyyy').format(DateTime.now()), // แสดงวันที่ปัจจุบันหากยังไม่เลือก
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
