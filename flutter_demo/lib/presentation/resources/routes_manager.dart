import 'package:flutter/material.dart';
import 'package:flutter_demo/presentation/compare/compare_screen.dart';
import 'package:flutter_demo/presentation/home/home_screen.dart';
import 'package:flutter_demo/presentation/non_sql/non_sql_screen.dart';
import 'package:flutter_demo/presentation/sql/sql_screen.dart';

class Routes {
  static const homeRoute = "/";
  static const sqlScreenRoute = "sql_screen_route";
  static const nonSqlScreenRoute = "non_sql_screen_route";
  static const compareScreenRoute = "compare_screen_route";
}

class RouteGenerator {
  static Map<String, Widget Function(BuildContext)> getRoute() {
    return {
      Routes.sqlScreenRoute: (_) => const SQLScreen(),
      Routes.homeRoute: (_) => const HomeScreen(),
      Routes.nonSqlScreenRoute: (_) => const NonSQLScreen(),
      Routes.compareScreenRoute: (_) => const CompareScreen(),
    };
  }
}
