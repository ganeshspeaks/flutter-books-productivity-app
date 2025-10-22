import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presum/constants/constants.dart';
import 'package:presum/page/bottom_nav_bar.dart';
import 'package:presum/ui/onboarding/onboarding.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), checkAuthentication);
  }

  void checkAuthentication() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if(mounted){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnBoardingPage()),
          );
        }
      } else {
        if(mounted){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset:const  Offset(1, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'assets/images/playstore.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),

            const SizedBox(height: 10,),

            const Text(
              'PreSum',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                color: backgroundColor,
                fontFamily: 'OpenSans'
              ),
            )
          ],
        ),
      ),
    );
  }
}
