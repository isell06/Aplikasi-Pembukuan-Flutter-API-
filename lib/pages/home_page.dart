import 'package:apk_pembukuan_konter_hp/constant.dart';
import 'package:apk_pembukuan_konter_hp/models/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apk_pembukuan_konter_hp/services/transaction_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionService _transactionService = TransactionService();
  bool isIncome = true;

  Future<void> _editTransaction(int transactionId, int amount, int categoryId,
      DateTime transaction_date, String description) async {
    try {
      ApiResponse response = await _transactionService.editTransaction(
          transactionId, amount, categoryId, transaction_date, description);

      if (response.error == null) {
        
      } else {
        // Handle error here
        print('Error editing transaction: ${response.error}');
      }
    } catch (e) {
      // Handle error here
      print('Error editing transaction: $e');
    }
  }

  Future<void> _deleteTransaction(int transactionId) async {
    try {
      ApiResponse response =
          await _transactionService.deleteTransaction(transactionId);

      if (response.error == null) {
      } else {
        // Handle error here
        print('Error deleting transaction: ${response.error}');
      }
    } catch (e) {
      // Handle error here
      print('Error deleting transaction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        //dashboard total income & expenses
                        Container(
                          child: Icon(Icons.download, color: Colors.blueGrey),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Income",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white, fontSize: 12)),
                            Text(
                              "RP. 3.800.000,00",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 14),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Icon(Icons.upload, color: Colors.blueGrey),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Expense",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white, fontSize: 12)),
                            Text(
                              "RP. 3.800.000,00",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 14),
                            )
                          ],
                        )
                      ],
                    )
                  ]),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  child: Text(
                    "Transactions",
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Switch(
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
              ),
            ],
          ),

          //list transaksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading: (isIncome)
                    ? Icon(Icons.download, color: Colors.blueGrey)
                    : Icon(Icons.upload, color: Colors.red),
                title: Text(
                  "Rp. 120.000,00",
                ),
                subtitle: Text("Service LCD iPhone 11"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
