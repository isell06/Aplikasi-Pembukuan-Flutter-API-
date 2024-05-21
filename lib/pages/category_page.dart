import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apk_pembukuan_konter_hp/models/api_response.dart';
import 'package:apk_pembukuan_konter_hp/services/category_service.dart';
import 'package:apk_pembukuan_konter_hp/models/category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryService _categoryService = CategoryService();
  List<Category> categories = [];
  bool isIncome = true;
  String type = "Income" "Expense";
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Corrected method invocation
  }

  Future<List<Category>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/category'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Category> categories =
          data.map((category) => Category.fromJson(category)).toList();
      setState(() {
        this.categories = categories;
      });
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> _createCategory(String name, int type) async {
    try {
      ApiResponse response =
          await _categoryService.createCategory(name, (isIncome) ? 2 : 1);

      if (response.error == null) {
        // Successfully created category, reload the categories
        await fetchCategories();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating category: ${response.error}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating category: $e')),
      );
    }
  }

  Future<void> _editCategory(int categoryId, String name, int type) async {
    try {
      ApiResponse response =
          await _categoryService.editCategory(categoryId, name, type);

      if (response.error == null) {
        // Successfully edited category, reload the categories
        await fetchCategories();
      } else {
        // Handle error here
        print('Error editing category: ${response.error}');
      }
    } catch (e) {
      // Handle error here
      print('Error editing category: $e');
    }
  }

  Future<void> _deleteCategory(int categoryId) async {
    try {
      ApiResponse response = await _categoryService.deleteCategory(categoryId);

      if (response.error == null) {
        // Successfully deleted category, reload the categories
        await fetchCategories();
      } else {
        // Handle error here
        print('Error deleting category: ${response.error}');
      }
    } catch (e) {
      // Handle error here
      print('Error deleting category: $e');
    }
  }

  void openDialog(Category? category) {
    if (category != null) {
      name.text = category.name;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    (type == "Income")
                        ? "Add Income"
                        : "Add Expense", // Use 'type' instead of 'isIncome'
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: (type == "Income")
                          ? Colors.blueGrey
                          : Colors.red, // Use 'type' instead of 'isIncome'
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (category == null) {
                        _createCategory(
                            name.text,
                            (type == "Income")
                                ? 2
                                : 1); // Use 'type' instead of 'isIncome'
                      } else {
                        _editCategory(
                            category.id,
                            name.text,
                            (type == "Income")
                                ? 2
                                : 1); // Use 'type' instead of 'isIncome'
                      }
                      // Close the dialog
                      Navigator.of(context).pop();
                      setState(() {
                        name.clear();
                      });
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: (type == "Income"),
                  onChanged: (bool value) {
                    setState(() {
                      type = value ? "Income" : "Expense";
                    });
                  },
                  inactiveTrackColor:
                      (type == "Income") ? Colors.blueGrey : Colors.red[200],
                  inactiveThumbColor:
                      (type == "Income") ? Colors.blueGrey : Colors.red,
                  activeColor:
                      (type == "Income") ? Colors.blueGrey : Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    openDialog(null);
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Displaying Categories or a message
          Expanded(
            child: categories.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      Category category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            leading: (category.type == "Expense")
                                ? Icon(Icons.download, color: Colors.red)
                                : Icon(Icons.upload, color: Colors.blueGrey),
                            title: Text(category.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _deleteCategory(category.id);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    openDialog(category);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
