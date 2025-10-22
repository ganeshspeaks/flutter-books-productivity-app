import 'package:flutter/material.dart';
import 'package:presum/constants/constants.dart';
import 'package:presum/page/articles_page.dart';
import 'package:presum/page/books_page.dart';
import 'package:presum/page/home_page.dart';
import 'package:presum/page/vision_board_page.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedPage = 0;
  List<Widget> pages = [
    const HomePage(),
    const BooksPage(),
    const ArticlesPage(),
    const VisionBoardPage(),
  ];

  void changePage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     systemNavigationBarColor:secondaryColor, // navigation bar color
    //     // statusBarColor: Colors.pink, // status bar color
    //   )
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: selectedPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            label: 'Vision',
          ),
        ],
        
        currentIndex: selectedPage,
        backgroundColor:secondaryColor,
        
        selectedItemColor: backgroundColor,
        unselectedItemColor: Colors.grey[500],
        onTap: changePage,
      ),
    );
  }
}
