import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/model/contact.dart';
import 'package:isar/isar.dart';
import 'base_viewmodel.dart';

class NonSQLViewModel extends BaseViewModel
    implements NonSQLViewModelInputs, NonSqlViewModelOutputs {
  final StreamController _streamController =
      StreamController<NonSQLViewModelObject>();
  List<Contact> _contacts = [];
  Contact? selectedContact;
  Isar isar;
  NonSQLViewModel({required this.isar});

  @override
  void onStart() {
    _getContacts();
  }

  @override
  void onDisposed() {
    _streamController.close();
  }

  @override
  void deleteSelectedContact() async {
    if (selectedContact == null) return;

    await isar.writeTxn((isar) async {
      await isar.contacts.delete(selectedContact!.id!);
      selectedContact = null;
    });

    _getContacts();
  }

  @override
  void insertContact(String name, int age) async {
    final contact = Contact();
    contact.name = name;
    contact.age = age;
    await isar.writeTxn((isar) async {
      contact.id = await isar.contacts.put(contact);
      _contacts.add(contact);
      _postDataToViews();
    });
  }

  @override
  void updateContact(String name, int age) async {
    // update user
    if (selectedContact == null) return;
    final contact = Contact();
    contact.name = name;
    contact.age = age;
    contact.id = selectedContact!.id;
    await isar.writeTxn((isar) async {
      await isar.contacts.put(contact);
      selectedContact = null;
    });
    _getContacts();
  }

  @override
  void queryContact(String name, int age) async {
    if (age >= 0) {
      debugPrint("queryContact: $age");
      _contacts = await isar.contacts
          .filter()
          .nameContains(name)
          .and()
          .ageEqualTo(age)
          .findAll();
    } else {
      _contacts = await isar.contacts.filter().nameContains(name).findAll();
    }
    _postDataToViews();
  }

  @override
  void refresh() {
    _getContacts();
  }

  @override
  Sink get viewModelInputs => _streamController.sink;

  @override
  Stream<NonSQLViewModelObject> get viewModelOutputs =>
      _streamController.stream.map((event) => event);

  void _getContacts() async {
    _contacts = await isar.contacts.where().findAll();
    _postDataToViews();
  }

  void _postDataToViews() {
    _streamController.add(
        NonSQLViewModelObject(contacts: _contacts, lenght: _contacts.length));
  }
}

abstract class NonSQLViewModelInputs {
  void insertContact(String name, int age);
  void updateContact(String name, int age);
  void queryContact(String name, int age);
  void deleteSelectedContact();
  void refresh();
  Sink get viewModelInputs;
}

abstract class NonSqlViewModelOutputs {
  Stream<NonSQLViewModelObject> get viewModelOutputs;
}

class NonSQLViewModelObject {
  List<Contact> contacts;
  int lenght;
  NonSQLViewModelObject({required this.contacts, required this.lenght});
}
