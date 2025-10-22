import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:presum/constants/constants.dart';


class ArticlePreviewScreen extends StatelessWidget {
  final String title;
  final String body;

  const ArticlePreviewScreen({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // title: Text(title),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 16),
                Text(
                  title,
                  style: headingStyle,
                ),
        
                const Divider(),
                const SizedBox(height: 16),
                
                
                HtmlWidget(
                  body,
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
