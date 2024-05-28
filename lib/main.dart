import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/welcome_page.dart';
import '../models/app_settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppSettings>(
      create: (_) => AppSettings(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Japanese Learning App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: WelcomePage(),
      ),
    );
  }
}
