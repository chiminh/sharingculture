import 'dart:async';

import 'package:flutter_demo/helper/db_helper.dart';
import 'package:flutter_demo/viewmodel/base_viewmodel.dart';

import '../model/user.dart';

class SQLViewModel extends BaseViewModel
    implements SQLViewModelInputs, SQLViewModelOutputs {
  final StreamController _streamController =
      StreamController<SQLViewModelObject>();
  List<User> _users = [];
  User? selectedUser;

  @override
  void onDisposed() {
    _streamController.close();
  }

  @override
  void onStart() {
    _getUsers();
  }

  @override
  void deleteSelectedUser() async {
    if (selectedUser == null) return;
    await DBHelper.getInstance().deleteUser(selectedUser!.id);
    _getUsers();
  }

  @override
  void insertUser(String name, int age) async {
    await DBHelper.getInstance().insertUser(name, age);
    _getUsers();
  }

  @override
  void updateUser(String name, int age) async {
    if (selectedUser == null) return;
    await DBHelper.getInstance()
        .updateUser(User(id: selectedUser!.id, username: name, age: age));
    _getUsers();
  }

  @override
  void filterUsers(int age) async {
    _users = await DBHelper.getInstance().filterUsers(age);
    _postDataToViews();
  }

  @override
  Sink get sqlViewModelInputs => _streamController.sink;

  @override
  Stream<SQLViewModelObject> get sqlViewModelOutputs =>
      _streamController.stream.map((viewModelObject) => viewModelObject);

  void _getUsers() async {
    _users = await DBHelper.getInstance().getUsers();
    _postDataToViews();
  }

  void _postDataToViews() {
    _streamController
        .add(SQLViewModelObject(users: _users, lenght: _users.length));
  }
}

abstract class SQLViewModelInputs {
  void insertUser(String name, int age);
  void updateUser(String name, int age);
  void filterUsers(int age);
  void deleteSelectedUser();
  Sink get sqlViewModelInputs;
}

abstract class SQLViewModelOutputs {
  Stream<SQLViewModelObject> get sqlViewModelOutputs;
}

class SQLViewModelObject {
  List<User> users;
  int lenght;
  SQLViewModelObject({required this.users, required this.lenght});
}
