import 'package:apk_pembukuan_konter_hp/pages/category_page.dart';
import 'package:apk_pembukuan_konter_hp/pages/home_page.dart';
import 'package:apk_pembukuan_konter_hp/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _children = [HomePage(), CategoryPage()];
  int currentIndex = 0;

  void onTapTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (currentIndex == 0)
            ? CalendarAppBar(
                backButton: false,
                locale: 'id',
                onDateChanged: (value) => print(value),
                firstDate: DateTime.now().subtract(Duration(days: 360)),
                lastDate: DateTime.now(),
                accent: Colors.blueGrey,
              )
            : PreferredSize(
                child: Container(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  child: Text(
                    'Categories',
                    style: GoogleFonts.montserrat(fontSize: 20),
                  ),
                )),
                preferredSize: Size.fromHeight(100)),
        floatingActionButton: Visibility(
          visible: (currentIndex == 0) ? true : false,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => TransactionPage(),
              ))
                  .then((value) {
                setState(() {});
              });
            },
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.add),
          ),
        ),
        body: _children[currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                onPressed: () {
                  onTapTapped(0);
                },
                icon: Icon(Icons.home)),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  onTapTapped(1);
                },
                icon: Icon(Icons.list))
          ]),
        ));
  }
}
