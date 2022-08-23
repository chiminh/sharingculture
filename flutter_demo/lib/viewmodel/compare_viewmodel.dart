import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/viewmodel/base_viewmodel.dart';
import 'package:isar/isar.dart';

import '../helper/db_helper.dart';
import '../model/contact.dart';

class CompareViewModel extends BaseViewModel
    implements CompareViewModeOutputs, CompareViewModelInputs {
  final StreamController _streamController =
      StreamController<CompareViewModelObject>();
  static const int count = 10000;
  Isar isar;
  bool _isNonSQLStatus = false;
  int _startTime = 0;
  int _endTime = 0;

  CompareViewModel({required this.isar});

  @override
  void onDisposed() {
    _streamController.close();
  }

  @override
  void onStart() {
    // TODO: implement onStart
  }

  @override
  void setSwitStatus(bool isNonSQL) {
    _isNonSQLStatus = isNonSQL;
    _postDataToViews();
  }

  @override
  Sink get viewModelInput => _streamController.sink;

  @override
  Stream<CompareViewModelObject> get viewModelOuput =>
      _streamController.stream.map((event) => event);

  @override
  void insert() {
    _postDataToViews(showLoading: true);
    if (_isNonSQLStatus) {
      _insertNonSQL();
    } else {
      _insertSQL();
    }
  }

  @override
  void filter(int age) async {
    _postDataToViews(showLoading: true);
    if (_isNonSQLStatus) {
      _filterNonSQL(age);
    } else {
      _filterSQL(age);
    }
  }

  @override
  void deleteAll() async {
    debugPrint("Delete All");
    _postDataToViews(showLoading: true);
    _deleteAllNonSQL();
    _deleteAllSQL();
  }

  void _postDataToViews({bool showLoading = false}) {
    var periodTime = (_endTime - _startTime) / 1000;
    _streamController.add(CompareViewModelObject(
        isNonSQLStatus: _isNonSQLStatus,
        periodTime: periodTime,
        showLoading: showLoading));
  }

  void _insertNonSQL() async {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    // insert 1000 users with age from 1 -> 1000
    await isar.writeTxn((isar) async {
      for (var i = 0; i < count; i++) {
        final contact = Contact();
        contact.name = "name $i";
        contact.age = i;
        await isar.contacts.put(contact);
      }
    });
    _endTime = DateTime.now().millisecondsSinceEpoch;
    _postDataToViews();
  }

  void _insertSQL() async {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    // insert 1000 users with age from 1 -> 1000
    for (var i = 0; i < count; i++) {
      await DBHelper.getInstance().insertUser("name $i", i);
    }
    _endTime = DateTime.now().millisecondsSinceEpoch;
    _postDataToViews();
  }

  void _filterSQL(int age) async {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    final users = await DBHelper.getInstance().filterUsers(age);
    _endTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint("user count: ${users.length}");
    _postDataToViews();
  }

  void _filterNonSQL(int age) async {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    final contacts =
        await isar.contacts.filter().ageLessThan(age, include: true).findAll();
    _endTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint("contact count: ${contacts.length}");
    _postDataToViews();
  }

  void _deleteAllSQL() async {
    DBHelper.getInstance().deleteAllUsers();
    _postDataToViews();
  }

  void _deleteAllNonSQL() async {
    await isar.writeTxn((isar) async {
      isar.contacts.clear();
    });

    _postDataToViews();
  }
}

abstract class CompareViewModelInputs {
  void setSwitStatus(bool isNonSQL);
  void insert();
  void filter(int age);
  void deleteAll();

  Sink get viewModelInput;
}

abstract class CompareViewModeOutputs {
  Stream<CompareViewModelObject> get viewModelOuput;
}

class CompareViewModelObject {
  bool isNonSQLStatus;
  double periodTime;
  bool showLoading;
  CompareViewModelObject(
      {required this.isNonSQLStatus,
      required this.periodTime,
      required this.showLoading});
}
