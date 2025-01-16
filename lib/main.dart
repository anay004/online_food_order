import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_food_order/providers/user_provider.dart';
import 'package:online_food_order/screens/admin/admin_dashboard.dart';
import 'package:online_food_order/screens/user/user_dashboard.dart';
import 'package:online_food_order/screens/user/user_login.dart';
import 'package:online_food_order/services/firebase_service.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("here 1");


  try {
    if (Firebase.apps.isEmpty) {
      // Initialize Firebase with default options for the current platform
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase initialized");
    } else {
      print("Firebase already initialized");
    }
  } catch (e) {
    print("Error during Firebase initialization: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(UserModel(name: "name", email: "email", phone: "phone", userImage: "userImage" )),
      child: const MyApp(),
    ),

  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:
      FlexThemeData.light(
        scheme: FlexScheme.sanJuanBlue, // Choose a predefined color scheme
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold, // Customization
        blendLevel: 30,
        appBarStyle: FlexAppBarStyle.background, // Matches the material style
        visualDensity: VisualDensity.comfortable,
        textTheme: GoogleFonts.adaminaTextTheme(),
        useMaterial3: true,
        bottomAppBarElevation: 20,
      ),
      //home: AdminDashboard(),
      home: UserLogin(),
    );
  }
}

