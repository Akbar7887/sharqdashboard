import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sharqmotors/pages/login_page.dart';
import 'package:sharqmotors/provider/simle_provider.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


void main() async {
  //  // client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  // //

  // HttpClient client = HttpClient();
  WidgetsFlutterBinding.ensureInitialized();
  

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SimpleProvider()),
      // ChangeNotifierProvider(create: (_) => ModelsProvider()),
      // ChangeNotifierProvider(create: (_) => SectionProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tas group',
      theme: ThemeData(
        textTheme: TextTheme(),
        // colorScheme: Colors.grey
        // textButtonTheme: TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.)),
        primarySwatch: Colors.yellow,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
      // home: Home(),
    );
  }
}
