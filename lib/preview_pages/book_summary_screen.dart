import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:presum/constants/constants.dart';

class BookSummaryScreen extends StatelessWidget {
  final String author;
  final String title;
  final String coverUrl;
  final String summary;

  const BookSummaryScreen({
    super.key,
    required this.author,
    required this.title,
    required this.coverUrl,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          title, 
          style: headingStyle.copyWith(color: backgroundColor),
        ),
        backgroundColor: secondaryColor,
        iconTheme:const IconThemeData(
          color: backgroundColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display cover photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    coverUrl,
                    height: 300,
                    
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                // Book title
                Text(
                  author,
                  style: bodyTextStyle,
                ),
                const SizedBox(height: 16),
                // Book summary in HTML format
                HtmlWidget(
                  summary,
                  textStyle: TextStyle(fontSize: 16, fontFamily: bodyTextStyle.fontFamily),
                  // onTapUrl: (url) {
                    
                  // },
                  // Additional optional parameters can be set here
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
