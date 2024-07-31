import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../service/no_user.dart';

class AddIncome extends StatefulWidget {
  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  List<dynamic> _categories = [];
  String _selectedCategory = '';
  int _selectedCategoryIndex = 0;
  List<dynamic> _tags = [];
  List<String> _selectedTags = [];
  bool isLoading = true; // เริ่มต้นด้วยสถานะการโหลด
  bool _isFavorite = false; // ตัวแปรเก็บสถานะ favorite
  List<dynamic> _favoriteTransactions = [];

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
              _tags = data['data']['summaryTags']; // Adjust according to your API response structure
              isLoading = false; // ตั้งค่าสถานะเป็น false เมื่อโหลดข้อมูลเสร็จ
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

  // Future<void> _fetchFavoriteTransactions() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');

  //   try {
  //     final response = await http.get(
  //       Uri.parse('${Config.apiUrl}/getFavorite?fav=1'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       if (data['status'] == 'ok') {
  //         if (mounted) {
  //           setState(() {
  //             _favoriteTransactions = data['data']['favorite']; // Adjust according to your API response structure
  //           });
  //           _showFavoriteTransactionPicker();
  //         }
  //       } else {
  //         navigateToLogin(context);
  //         throw Exception('Failed to load favorite transactions');
  //       }
  //     } else {
  //       navigateToLogin(context);
  //       throw Exception('Failed to load favorite transactions');
  //     }
  //   } catch (e) {
  //     navigateToLogin(context);
  //     throw Exception('Failed to load favorite transactions');
  //   }
  // }

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
      _isFavorite = !_isFavorite; // สลับค่า _isFavorite
    });
  }

  // void _toggleFavorite() {
  //   if (!_isFavorite) {
  //     _fetchFavoriteTransactions();
  //   } else {
  //     setState(() {
  //       _isFavorite = false;
  //     });
  //   }
  // }

  // void _showFavoriteTransactionPicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 300,
  //         child: ListView.builder(
  //           itemCount: _favoriteTransactions.length,
  //           itemBuilder: (context, index) {
  //             final transaction = _favoriteTransactions[index];
  //             return ListTile(
  //               title: Text(transaction['name']),
  //               onTap: () {
  //                 setState(() {
  //                   _nameController.text = transaction['name'];
  //                   _amountController.text = transaction['amount'].toString();
  //                   _noteController.text = transaction['note'];
  //                   _selectedCategory = transaction['category'] ?? _selectedCategory;
  //                   _selectedTags = List<String>.from(transaction['tags'] ?? []);
  //                   _isFavorite = true;
  //                 });
  //                 Navigator.of(context).pop();
  //               },
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 20,
                        ),
                      ],
                    ),
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
                                    choiceItems: C2Choice.listFrom<String, dynamic>(
                                      source: _tags,
                                      value: (i, v) => v['tag_name'],
                                      label: (i, v) => v['tag_name'],
                                    ),
                                    wrapped: false, // Set wrapped to false for horizontal scrolling
                                  ),
                                ],
                              ),
                            ),
                          ),
                    if (!isLoading)
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Text('Selected Tags: ${_selectedTags.join(', ')}'),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    final String amount = _amountController.text;
    final String note = _noteController.text;
    final String name = _nameController.text;

    if (amount.isEmpty || note.isEmpty || name.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final Map<String, dynamic> formData = {
      'categorie_id': _selectedCategory,
      'amount': amount,
      'note': name,
      'detail': note,
      'tag_id': _selectedTags,
      'favorite': _isFavorite ? 1 : 0, // เพิ่มค่านี้เพื่อส่งไปยัง backend
    };

    // Submit formData to the backend
    print(formData);
  }
}
