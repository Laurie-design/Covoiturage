import 'package:flutter/material.dart';
import 'views/home_view.dart'; // Import de la page d'accueil publique

void main() {
  runApp(const TransPortoApp());
}

class TransPortoApp extends StatelessWidget {
  const TransPortoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransPorto - Covoiturage au Togo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0052CC)), // Ton bleu royal Figma
        useMaterial3: true,
      ),
      home: const HomeView(), // On démarre sur la landing page publique
    );
  }
}
