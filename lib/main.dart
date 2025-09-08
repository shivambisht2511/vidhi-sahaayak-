import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/category/category_screen.dart';
import 'presentation/screens/chat/chat_screen.dart';

void main() {
  runApp(const LawChatApp());
}

class LawChatApp extends StatelessWidget {
  const LawChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Law Chatbot",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/onboarding": (context) => const OnboardingScreen(),
        "/category": (context) => const CategoryScreen(),
        "/chat": (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ChatScreen(category: args["category"] ?? "Chat");
        },
      },
    );
  }
}
