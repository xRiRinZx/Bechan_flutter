import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../service/no_user.dart';
import '../widget/date_picker_addpage.dart';

class AddIncome extends StatefulWidget {
  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  List<dynamic> _categories = [];
  Map<String, dynamic> _categoryMap = {};
  String _selectedCategory = '';
  int _selectedCategoryIndex = 0;
  List<dynamic> _tags = [];
  Map<String, dynamic> _tagMap = {};
  List<String> _selectedTags = [];
  bool isLoading = true;
  bool _isFavorite = false;
  DateTime? selectDate;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    selectDate = now;
    _fetchCategories();
    _fetchTags();
  }

  Future<void> _fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${Config.apiUrl}/getcategories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          if (mounted) {
            setState(() {
              _categories = data['data']['income'];
              _categoryMap = {for (var category in _categories) category['name']: category['categorie_id']};
              _selectedCategory = _categories.isNotEmpty ? _categories[0]['name'] : '';
            });
          }
        } else {
          navigateToLogin(context);
          throw Exception('Failed to load categories');
        }
      } else {
        navigateToLogin(context);
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      navigateToLogin(context);
      throw Exception('Failed to load categories');
    }
  }

  Future<void> _fetchTags() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${Config.apiUrl}/getTags'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          if (mounted) {
            setState(() {
              _tags = data['data']['summaryTags'];
              _tagMap = {for (var tag in _tags) tag['tag_name']: tag['tag_id']};
              isLoading = false;
            });
          }
        } else {
          navigateToLogin(context);
          throw Exception('Failed to load tags');
        }
      } else {
        navigateToLogin(context);
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      navigateToLogin(context);
      throw Exception('Failed to load tags');
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(initialItem: _selectedCategoryIndex),
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedCategoryIndex = index;
                _selectedCategory = _categories[index]['name'];
              });
            },
            children: _categories.map((category) {
              return Center(child: Text(category['name']));
            }).toList(),
          ),
        );
      },
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void onDateSelected(DateTime? date) {
    setState(() {
      selectDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blue.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DatePickerAddWidget(onDateSelected: onDateSelected),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Enter amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 33, 243, 184).withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showCategoryPicker,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.format_list_bulleted_rounded,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedCategory.isNotEmpty ? _selectedCategory : 'Select Category',
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
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 243, 222, 33).withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          labelText: 'Note',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            height: 60, // Set height for the scrollable area
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ChipsChoice<String>.multiple(
                                    value: _selectedTags,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedTags = val;
                                      });
                                    },
                                    choiceItems: C2Choice.listFrom<String, String>(
                                      source: _tags.map<String>((tag) => tag['tag_name'].toString()).toList(),
                                      value: (i, v) => v,
                                      label: (i, v) => v,
                                    ),
                                    wrapped: false, 
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 243, 33, 184).withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Container(
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_outline_rounded,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Favorite',
                        style: TextStyle(
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
              ),
            ),
          ),
          const SizedBox(height: 30),
        Expanded(
  child: Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity, // ปรับความกว้างของปุ่มให้เต็ม
        child: ElevatedButton(
          onPressed: _saveIncome,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            backgroundColor: Color.fromARGB(255, 96, 194, 148),
          ),
          child: Text(
            '+',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    ),
  ),
),

        ],
      ),
    );
  }

  // Future<void> _saveIncome() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');

  //   final incomeData = {
  //     'categorie_id': _categoryMap[_selectedCategory],
  //     'amount': _amountController.text,
  //     'note': _nameController.text,
  //     'detail': _noteController.text,
  //     'transaction_datetime': selectDate,
  //     'fav': _isFavorite ? 1 : 0,
  //     'tag_id': _selectedTags.map((tag) => _tagMap[tag]).toList(),
  //   };

  //   print(incomeData);
  // }

  Future<void> _saveIncome() async {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final formattedDate = selectDate != null ? dateFormat.format(selectDate!) : '';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/record'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'categorie_id': _categoryMap[_selectedCategory],
              'amount': _amountController.text,
              'note': _nameController.text,
              'detail': _noteController.text,
              'transaction_datetime': formattedDate,
              'fav': _isFavorite ? 1 : 0,
              'tag_id': _selectedTags.map((tag) => _tagMap[tag]).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok') {
          Navigator.pop(context, true);
        } else if (data['status'] == 'error') {
           ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save income: ${data['message']}')),
        );
        }
      } else {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save income: Server error')),
      );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
    }
  }
}
