import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'views/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // يمكنك إضافة ChangeNotifier هنا لإدارة الحالة لاحقاً
      ],
      child: const LuxuriousApp(),
    ),
  );
}

class LuxuriousApp extends StatelessWidget {
  const LuxuriousApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luxurious Chat & Feed',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
        primaryColor: const Color(0xFFD4AF37), // لون ذهبي فخم
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFF8A2BE2),
          surface: Color(0xFF1A1A24),
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
