import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:presum/constants/constants.dart';
import 'package:presum/page/favorite_books_page.dart';
import 'package:presum/preview_pages/book_summary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> _books = [];
  List<Map<String, String>> _filteredBooks = [];
  List<Map<String, String>> _favoriteBooks = []; 

  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _loadFavorites(); 
  }

  Future<void> _fetchBooks() async {
    QuerySnapshot snapshot = await _firestore.collection('books').get();
    _books = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'cover': data['cover'].toString(),
        'title': data['title'].toString(),
        'author': data['author'].toString(),
        'summary': data['summary'].toString(),
      };
    }).toList();

    _filteredBooks = _books;
    setState(() {});
  }

 Future<void> _loadFavorites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final favoriteBooksStringList = prefs.getStringList('favoriteBooks') ?? [];


  _favoriteBooks = favoriteBooksStringList.map((bookString) {
    Map<String, dynamic> bookMap = json.decode(bookString) as Map<String, dynamic>;

    return bookMap.map((key, value) => MapEntry(key, value.toString()));
  }).toList();

  setState(() {});
}


  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert each book map to JSON string
    final favoriteBooksStringList = _favoriteBooks
        .map((book) => json.encode(book))
        .toList();
    
    await prefs.setStringList('favoriteBooks', favoriteBooksStringList);
  }

  void _toggleFavorite(Map<String, String> book) {
    setState(() {
      final existingBook = _favoriteBooks.firstWhere(
        (favBook) => favBook['title'] == book['title'],
        orElse: () => {},
      );
      
      if (existingBook.isNotEmpty) {
        _favoriteBooks.remove(existingBook);
      } else {
        _favoriteBooks.add(book);
      }

      _saveFavorites();
    });
  }

  bool _isFavorite(String title) {
    return _favoriteBooks.any((book) => book['title'] == title);
  }

  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query;
      _filteredBooks = query.isEmpty
          ? _books
          : _books.where((book) {
              final titleLower = book['title']!.toLowerCase();
              final authorLower = book['author']!.toLowerCase();
              final searchLower = query.toLowerCase();
              return titleLower.contains(searchLower) || authorLower.contains(searchLower);
            }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _filteredBooks = _books;
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: _isSearching
            ? TextField(
                autofocus: true,
                onChanged: _filterBooks,
                decoration: const InputDecoration(
                  hintText: 'Search by book title or author',
                  hintStyle: bodyTextStyle,
                  border: InputBorder.none,
                ),
                style: bodyTextStyle,
              )
            : Text('Books', style: headingStyle.copyWith(color: backgroundColor)),
        // centerTitle: true,
        actions: [
          
          IconButton(
            icon: const Icon(Icons.bookmark, color: backgroundColor,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesBooksPage(
                    favoriteBooks: _favoriteBooks,
                    onFavoritesUpdated: _loadFavorites,
                  ),
                ),
              );
            },
          ),

          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: backgroundColor,
            ),
            onPressed: _toggleSearch,

          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _filteredBooks.isEmpty
                  ? const Center(child: Text("No books found."))
                  : GridView.builder(
                      padding: const EdgeInsets.all(20.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        crossAxisSpacing: 20, 
                        mainAxisSpacing: 20, 
                        childAspectRatio: 0.6,
                      ),
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        final isFavorite = _isFavorite(book['title']!);
                        return GestureDetector(
                          onTap: () {
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(0.2),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: NetworkImage(book['cover']!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
        
                                    // bookmark icon on image
        
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(0.2),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite ? Icons.bookmark : Icons.bookmark_border,
                                            color: isFavorite ? Colors.red : Colors.white,
                                          ),
                                          onPressed: () {
                                            _toggleFavorite(book);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  book['author']!,
                                  style: bodyTextStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );

  }
}

