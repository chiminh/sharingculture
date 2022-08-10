import 'package:flutter/material.dart';
import 'package:flutter_demo/presentation/resources/strings_manager.dart';
import 'package:flutter_demo/widgets/menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.title)),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MenuWidget(text: AppStrings.sqlDemo, onClick: () {}),
              MenuWidget(text: AppStrings.nonSqlDemo, onClick: () {}),
              MenuWidget(
                  text: AppStrings.compareSqlAndNonSqlDemo, onClick: () {}),
            ]),
      ),
    );
  }
}
