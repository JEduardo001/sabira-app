import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sabira/provider/ClientProvider.dart';
import 'package:sabira/provider/FirebaseProvider.dart';
import 'package:sabira/provider/ProviderHome.dart';
import 'package:sabira/screens/Inicio.dart';
import 'package:provider/provider.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await Firebase.initializeApp(); 
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderHome()),
        ChangeNotifierProvider(create: (context) => FirebaseProvider()),
        ChangeNotifierProvider(create: (context) => ClientProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      navigatorKey: navigatorKey,  
      title: 'Mi App',
      initialRoute: '/',  
      routes: {
        '/': (context) => Inicio(),  
      
      },
    );
  }
}