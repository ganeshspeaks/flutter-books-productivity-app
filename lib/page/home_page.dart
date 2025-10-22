import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:presum/constants/constants.dart';
import 'package:presum/page/profile_page.dart';
import 'package:presum/preview_pages/article_preview_screen.dart';
import 'package:presum/preview_pages/book_summary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userName = '';
  String _selectedAvatar = 'assets/avatars/avatar1.png';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _loadAvatar();
  }

  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _userName = userDoc['name'];
      });
    }
  }

  Future<void> _loadAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedAvatar = prefs.getString('selectedAvatar') ?? 'assets/avatars/avatar1.png';
    });
  }

  Future<String> _fetchQuote() async {
    DocumentSnapshot snapshot = await _firestore.collection('quotes').doc('quote').get();
    return snapshot['text'].toString();
  }

  Future<List<Map<String, String>>> _fetchBooks() async {
    QuerySnapshot snapshot = await _firestore.collection('books').limit(5).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'cover': data['cover'].toString(),
        'author': data['author'].toString(),
        'title': data['title'].toString(),
        'summary': data['summary'].toString(),
      };
    }).toList();
  }

  Future<List<Map<String, String>>> _fetchArticles() async {
    QuerySnapshot snapshot = await _firestore.collection('articles').limit(5).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'body': data['body']?.toString() ?? '',
        'title': data['title']?.toString() ?? '',
      };
    }).toList();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildWelcomeSection(),
          
              Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)
                  )
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    _buildQuoteSection(),
          
                    _buildBooksSection(),
                
                    _buildArticlesSection(),
        
                    const SizedBox(height: 30,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: bodyTextStyle.copyWith(
                  color: tertiaryColor,
                ),
              ),
              Text(
                _userName,
                style: headingStyle.copyWith(
                  fontSize: 25,
                  color: backgroundColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ).then((_) {
                _loadAvatar();
              });
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(_selectedAvatar),
              backgroundColor: primaryColor,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildQuoteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Inspiration", style: headingStyle),
          const SizedBox(height: 16),
          FutureBuilder<String>(
            future: _fetchQuote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: secondaryColor));
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text("No quotes available.");
              }
              return Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: tertiaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: secondaryColor, width: 2),
                ),
                child: Text(
                  snapshot.data!,
                  textAlign: TextAlign.center,
                  style: bodyTextStyle.copyWith(
                    fontStyle: FontStyle.italic,
                    color: primaryColor,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBooksSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Reading Recommendations", 
            style: headingStyle,
          ),

          const SizedBox(height: 16),

          FutureBuilder<List<Map<String, String>>>(
            future: _fetchBooks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: secondaryColor));
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text("No books available.");
              }
              return SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final book = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookSummaryScreen(
                              author: book['author']!,
                              title: book['title']!,
                              coverUrl: book['cover']!,
                              summary: book['summary']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        margin:const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 150+75,
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
                            const SizedBox(height: 10),
                            
                            Text(
                              book['author']!,
                              style: bodyTextStyle,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Latest Insights", style: headingStyle),

          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, String>>>(
            future: _fetchArticles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: secondaryColor));
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text("No articles available.");
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final article = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticlePreviewScreen(
                            title: article['title']!,
                            body: article['body']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['title']!,
                                  style: bodyTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  article['body']!,
                                  style: bodyTextStyle.copyWith(fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}