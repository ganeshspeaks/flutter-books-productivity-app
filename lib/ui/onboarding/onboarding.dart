import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:presum/auth/log_in.dart';
import 'package:presum/auth/sign_up.dart';
import 'package:presum/constants/constants.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        addController: true,
        controllerColor: secondaryColor,
        centerBackground: true,
        finishButtonText: 'Register',
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: primaryColor,
        ),
        skipTextButton: const Text(
          'Skip',
        ),
        totalPage: 3, 
        trailing: TextButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>const LoginPage())
            );
          }, 
          child: const Text(
            'Log in',
          ),
        ),
        headerBackgroundColor:backgroundColor, 
        pageBackgroundColor: backgroundColor,
        onFinish: (){  // on finish
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>const SignUpPage())
          );
        },
        background: [
          Image.asset(
            'assets/images/onboarding/books.png',
            height: 250,
            // width: 50,
          ),
      
          Image.asset(
            'assets/images/onboarding/articles.png',
            height: 250,
          ),
      
          // Image.asset(
          //   'assets/images/onboarding/philosophy.png',
          //   height: 250,
          // ),
      
          Image.asset(
            'assets/images/onboarding/vision_board.png',
            height: 250,
          ),
        ], 
        speed:1.8, 
        pageBodies: [
          
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:180),
                Text(
                  'BOOKS',
                  style: headingStyle,
                ),
            
                SizedBox(height:10),
                Text(
                  "Unlock key insights from the world's best books in minutes. Learn faster, grow smarter.",
                  textAlign: TextAlign.center,
                  style: bodyTextStyle,
      
                )
              ],
            ),
          ),
      
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:100),
            
                Text(
                  'ARTICLES',
                  style: headingStyle,
                ),
            
                SizedBox(height:10),
                Text(
                  "Stay ahead with articles that spark curiosity and fuel your passion for knowledge.",
                  textAlign: TextAlign.center,
                  style: bodyTextStyle,
                )
              ],
            ),
          ),
      
          // Container(
          //   alignment: Alignment.center,
          //   width: MediaQuery.of(context).size.width,
          //   padding: const EdgeInsets.symmetric(horizontal: 40),
          //   child: const Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       SizedBox(height:100),
            
          //       Text(
          //         'PHILOSOPHY',
          //         style: headingStyle,
          //       ),
            
          //       SizedBox(height:10),
          //       Text(
          //         "Explore profound thoughts that challenge perspectives and deepen your understanding of life's complexities.",
          //         textAlign: TextAlign.center,
          //         style: bodyTextStyle,
      
          //       )
          //     ],
          //   ),
          // ),
      
      
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:100),
            
                Text(
                  'VISION BOARD',
                  style: headingStyle,
                ),
            
                SizedBox(height:10),
                Text(
                  "Visualize your dreams, set goals, and track your journey toward success.",
                  textAlign: TextAlign.center,
                  style: bodyTextStyle,
      
                )
              ],
            ),
          ),
        ]
      ),
    );
  }
}