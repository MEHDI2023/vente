import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vente/login/LoginPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDQt72Oqv2HpT9XVVWFaJLHi5jaWkfVFwc",
      authDomain: "projet-vente-ff1b9",
      projectId: "projet-vente-ff1b9",
      appId: '1:385440380654:android:266f1ca11a3e4591c025ff',
      messagingSenderId:
          'BEQr8NAYNuHqnIxSl6iBqEjRri2qftU1XqBVLcmGd4W_tytO_KUoW4_iOq0JPTYaKcv4AqCRFNf6Iwd94PEGmmg',
      // Other necessary configurations...
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop-Elgaied',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://th.bing.com/th/id/OIG.0OUt0sE24Jl.UASP6U7h?pid=ImgGn"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitCircle(
                color: Colors.black87,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
