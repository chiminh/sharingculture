import 'package:flutter/material.dart';
import 'package:flutter_demo/presentation/compare/compare_screen.dart';
import 'package:flutter_demo/presentation/home/home_screen.dart';
import 'package:flutter_demo/presentation/non_sql/non_sql_screen.dart';
import 'package:flutter_demo/presentation/sql/sql_screen.dart';
import 'package:isar/isar.dart';

class Routes {
  static const homeRoute = "/";
  static const sqlScreenRoute = "sql_screen_route";
  static const nonSqlScreenRoute = "non_sql_screen_route";
  static const compareScreenRoute = "compare_screen_route";
}

class RouteGenerator {
  static Map<String, Widget Function(BuildContext)> getRoute(
      {required Isar isar}) {
    return {
      Routes.sqlScreenRoute: (_) => const SQLScreen(),
      Routes.homeRoute: (_) => const HomeScreen(),
      Routes.nonSqlScreenRoute: (_) => NonSQLScreen(isar: isar),
      Routes.compareScreenRoute: (_) => const CompareScreen(),
    };
  }
}
