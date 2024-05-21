import 'package:apk_pembukuan_konter_hp/models/api_response.dart';
import 'package:apk_pembukuan_konter_hp/services/transaction_service.dart';
import 'package:apk_pembukuan_konter_hp/models/transaction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TransactionService _transactionService = TransactionService();
  bool isIncome = true;
  int type = 2;
  List<String> categories = [];
  String selectedValue = '';
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

Future<void> _createTransactionAndValidate() async {
    try {
      // Validate the amount field
      String amountText = amountController.text;
      if (amountText.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter the amount.'),
          ),
        );
        return; // Stop further execution if the amount is empty
      }

      // Parse the amount
      int amount = int.tryParse(amountText.trim()) ?? -1;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid positive amount.'),
          ),
        );
        return; // Stop further execution if the amount is not a positive integer
      }

      // Proceed with creating the transaction
      await _createTransactionInternal(amount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating transaction: $e')),
      );
    }
  }



  Future<void> _createTransactionInternal(int amount) async {
    try {
      ApiResponse response = await _transactionService.createTransaction(
        amount,
        categories.indexOf(selectedValue) +
            1, // Assuming the category IDs start from 1
        DateTime.parse(dateController.text),
        descriptionController.text,
      );

      if (response.error == null) {
        // Successfully created transaction, you may want to do something here
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating transaction: ${response.error}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Switch(
                      value: isIncome,
                      onChanged: (bool value) {
                        setState(() {
                          isIncome = value;
                        });
                      },
                      inactiveTrackColor: Colors.red[200],
                      inactiveThumbColor: Colors.red,
                      activeColor: Colors.blueGrey,
                    ),
                    Text(
                      isIncome ? 'Income' : 'Expense',
                      style: GoogleFonts.montserrat(fontSize: 14),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Amount",
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Category',
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
                FutureBuilder<List<String>>(
                  future: fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<String> categories = snapshot.data!.toSet().toList();

                      if (categories.isEmpty) {
                        return Text('No categories available');
                      }

                      // Ensure that the selectedValue is a valid item in the list
                      if (!categories.contains(selectedValue)) {
                        selectedValue = categories.first;
                      }

                      return DropdownButton<String>(
                        isExpanded: true,
                        value: selectedValue,
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(labelText: "Enter Date"),
                  onTap: () async {
                    DateTime? pickDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2099),
                    );

                    if (pickDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickDate);

                      dateController.text = formattedDate;
                    }
                  },
                ),
                SizedBox(height: 25),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Description",
                  ),
                ),
                SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _createTransactionAndValidate(
                      );
                    },

                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<String>> fetchCategories() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/category'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<String> categories =
        data.map((category) => category['name'].toString()).toList();
    return categories;
  } else {
    throw Exception('Failed to load categories');
  }
}
