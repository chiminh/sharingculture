import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_demo/viewmodel/compare_viewmodel.dart';
import 'package:isar/isar.dart';

import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

// ignore: must_be_immutable
class CompareScreen extends StatefulWidget {
  Isar isar;
  CompareScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  late CompareViewModel _viewModel;
  final TextEditingController _ageEditingController = TextEditingController();

  @override
  void initState() {
    _viewModel = CompareViewModel(isar: widget.isar);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompareViewModelObject>(
        stream: _viewModel.viewModelOuput,
        builder: ((context, snapshot) {
          return _getContentViews(snapshot.data);
        }));
  }

  Widget _getContentViews(CompareViewModelObject? data) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.compareSqlAndNoSqlDemo)),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(AppStrings.isNoSQL),
                  Switch(
                      value: data?.isNoSQLStatus ?? false,
                      onChanged: _switchStatusChanged)
                ],
              ),
              const Text("${AppStrings.times} ${CompareViewModel.count}"),
              TextField(
                  controller: _ageEditingController,
                  decoration: _getInputDecoration(AppStrings.ageForFilter),
                  keyboardType: TextInputType.number),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _insert(),
                    child: const Text(AppStrings.insert),
                  ),
                  ElevatedButton(
                      onPressed: () => _deleteAll(),
                      child: const Text(AppStrings.deleteAll)),
                  ElevatedButton(
                      onPressed: () => _filter(),
                      child: const Text(AppStrings.filter))
                ],
              ),
              Text("${AppStrings.periodTime}: ${data?.periodTime ?? ""} "),
              Visibility(
                  visible: data?.showLoading ?? false,
                  child: Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: const Text(AppStrings.loading))))
            ]),
      ),
    );
  }

  void _insert() {
    _viewModel.insert();
  }

  void _filter() {
    final ageStr = _ageEditingController.text.trim();
    if (ageStr.isEmpty) return;
    _viewModel.filter(int.parse(ageStr));
  }

  void _deleteAll() {
    _viewModel.deleteAll();
  }

  void _switchStatusChanged(bool status) {
    _viewModel.setSwitStatus(status);
  }

  InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
        contentPadding: const EdgeInsets.all(AppPadding.p10),
        hintText: hintText,
        border: const OutlineInputBorder(
            borderSide: BorderSide(
                width: AppSize.s1,
                color: Colors.black87,
                style: BorderStyle.solid)));
  }
}
