import 'package:flutter/material.dart';
import 'package:flutter_demo/presentation/resources/strings_manager.dart';
import 'package:flutter_demo/presentation/resources/values_manager.dart';
import 'package:flutter_demo/viewmodel/sql_viewmodel.dart';
import 'package:flutter_demo/widgets/user_widget.dart';

import '../../model/user.dart';

class SQLScreen extends StatefulWidget {
  const SQLScreen({Key? key}) : super(key: key);

  @override
  State<SQLScreen> createState() => _SQLScreenState();
}

class _SQLScreenState extends State<SQLScreen> {
  final SQLViewModel _viewModel = SQLViewModel();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _ageEditingController = TextEditingController();

  @override
  void initState() {
    _viewModel.onStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SQLViewModelObject>(
        stream: _viewModel.sqlViewModelOutputs,
        builder: ((context, snapshot) {
          return _getContentViews(snapshot.data);
        }));
  }

  @override
  void dispose() {
    _viewModel.onDisposed();
    super.dispose();
  }

  Widget _getContentViews(SQLViewModelObject? data) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.sqlDemo)),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: data == null
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    TextField(
                      controller: _nameEditingController,
                      decoration: _getInputDecoration(AppStrings.userName),
                    ),
                    const SizedBox(
                      height: AppSize.s10,
                    ),
                    TextField(
                        controller: _ageEditingController,
                        decoration: _getInputDecoration(AppStrings.age),
                        keyboardType: TextInputType.number),
                    const SizedBox(
                      height: AppSize.s10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => _insert(),
                          child: const Text(AppStrings.insert),
                        ),
                        ElevatedButton(
                            onPressed: () => _update(),
                            child: const Text(AppStrings.update))
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        return UserWidget(
                          user: data.users[index],
                          updateAction: _updateAction,
                          deleteAction: _deleteAction,
                        );
                      },
                      itemCount: data.users.length,
                    ))
                  ]),
      ),
    );
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

  void _insert() {
    final name = _nameEditingController.text;
    final age = _ageEditingController.text;
    if (name.isEmpty || age.isEmpty) {
      return;
    }
    _viewModel.insertUser(name, int.parse(age));

    _clearTexts();
  }

  void _update() {
    final name = _nameEditingController.text;
    final age = _ageEditingController.text;
    if (name.isEmpty || age.isEmpty) {
      return;
    }
    _viewModel.updateUser(name, int.parse(age));
    _clearTexts();
  }

  void _deleteAction(User user) {
    _showConfirmDeleteDialog();
  }

  void _updateAction(User user) {
    _nameEditingController.text = user.username;
    _ageEditingController.text = "${user.age}";
    _viewModel.selectedUser = user;
  }

  void _clearTexts() {
    _nameEditingController.text = "";
    _ageEditingController.text = "";
  }

  void _showConfirmDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Confirmation"),
            content: const Text("Do you want to delete this user?"),
            actions: [
              ElevatedButton(
                onPressed: () => {},
                child: const Text("Delete"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
              ),
              ElevatedButton(onPressed: () => {}, child: const Text("Cancel"))
            ],
          );
        });
  }
}
