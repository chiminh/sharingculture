import 'package:flutter/material.dart';
import 'package:flutter_demo/model/contact.dart';
import 'package:flutter_demo/presentation/resources/routes_manager.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await Isar.open(
    schemas: [ContactSchema],
    directory: (await getApplicationDocumentsDirectory()).path,
  );
  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  Isar isar;
  MyApp({Key? key, required this.isar}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: RouteGenerator.getRoute(isar: isar),
    );
  }
}
