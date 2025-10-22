import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:presum/constants/constants.dart';
import 'package:presum/preview_pages/book_summary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesBooksPage extends StatefulWidget {
  final List<Map<String, String>> favoriteBooks;
  final Function onFavoritesUpdated; 

  const FavoritesBooksPage({
    super.key,
    required this.favoriteBooks,
    required this.onFavoritesUpdated,
  });

  @override
  State<FavoritesBooksPage> createState() => _FavoritesBooksPageState();
}

class _FavoritesBooksPageState extends State<FavoritesBooksPage> {
  late List<Map<String, String>> _favoriteBooks;

  @override
  void initState() {
    super.initState();
    _favoriteBooks = widget.favoriteBooks;
  }

  Future<void> _removeFromFavorites(int index) async {
    setState(() {
      _favoriteBooks.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteBooksStringList = _favoriteBooks
        .map((book) => json.encode(book))
        .toList();
    await prefs.setStringList('favoriteBooks', favoriteBooksStringList);
    widget.onFavoritesUpdated(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Favorite Books', style: headingStyle.copyWith(color: backgroundColor)),
        centerTitle: true,
        iconTheme:const IconThemeData(
          color: backgroundColor,
        ),
      ),
      body: _favoriteBooks.isEmpty
          ? const Center(child: Text("No favorite books added."))
          : ListView.builder(
              itemCount: _favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = _favoriteBooks[index];
                return Dismissible(
                  key: Key(book['title']!), 
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeFromFavorites(index);
                  },
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookSummaryScreen(
                            title: book['title']!,
                            author: book['author']!,
                            coverUrl: book['cover']!,
                            summary: book['summary']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              book['cover']!,
                              fit: BoxFit.cover,
                              // scale: 0.3,
                              width: 40,
                              height: 60,
                            ),
                          ),
                    
                          const SizedBox(width: 10,),
                      
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book['title']!,
                                style: headingStyle,
                              ),
                      
                              Text(
                                book['author']!,
                                style: bodyTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
