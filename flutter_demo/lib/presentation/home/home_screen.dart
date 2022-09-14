import 'package:flutter/material.dart';
import 'package:flutter_demo/presentation/resources/routes_manager.dart';
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
              MenuWidget(
                  text: AppStrings.sqlDemo,
                  onClick: () => _openSQLDemo(context)),
              MenuWidget(
                  text: AppStrings.noSqlDemo,
                  onClick: () => _openNonSQLDemo(context)),
              MenuWidget(
                  text: AppStrings.compareSqlAndNoSqlDemo,
                  onClick: () => _openCompareScreen(context)),
            ]),
      ),
    );
  }

  void _openSQLDemo(BuildContext context) {
    Navigator.pushNamed(context, Routes.sqlScreenRoute);
  }

  void _openNonSQLDemo(BuildContext context) {
    Navigator.pushNamed(context, Routes.noSqlScreenRoute);
  }

  void _openCompareScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.compareScreenRoute);
  }
}
