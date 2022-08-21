import 'package:flutter/material.dart';
import 'package:flutter_demo/model/contact.dart';
import 'package:flutter_demo/widgets/contact_widget.dart';
import 'package:isar/isar.dart';
import '../../viewmodel/non_sql_viewmodel.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

// ignore: must_be_immutable
class NonSQLScreen extends StatefulWidget {
  Isar isar;
  NonSQLScreen({Key? key, required this.isar}) : super(key: key);

  @override
  State<NonSQLScreen> createState() => _NonSQLScreenState();
}

class _NonSQLScreenState extends State<NonSQLScreen> {
  late NonSQLViewModel _viewModel;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _ageEditingController = TextEditingController();

  @override
  void initState() {
    _viewModel = NonSQLViewModel(isar: widget.isar);
    _viewModel.onStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NonSQLViewModelObject>(
        stream: _viewModel.viewModelOutputs,
        builder: ((context, snapshot) {
          return _getContentViews(snapshot.data);
        }));
  }

  @override
  void dispose() {
    _viewModel.onDisposed();
    super.dispose();
  }

  Widget _getContentViews(NonSQLViewModelObject? data) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.nonSqlDemo)),
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
                            child: const Text(AppStrings.update)),
                        ElevatedButton(
                            onPressed: () => _filter(),
                            child: const Text(AppStrings.filter))
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ContactWidget(
                          contact: data.contacts[index],
                          updateAction: _updateAction,
                          deleteAction: _deleteAction,
                        );
                      },
                      itemCount: data.contacts.length,
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
    _viewModel.insertContact(name, int.parse(age));

    _clearTexts();
  }

  void _update() {
    final name = _nameEditingController.text;
    final age = _ageEditingController.text;
    if (name.isEmpty || age.isEmpty) {
      return;
    }
    _viewModel.updateContact(name, int.parse(age));
    _clearTexts();
  }

  void _filter() {
    final name = _nameEditingController.text;
    final ageText = _ageEditingController.text;
    // there is no value on textfields, refresh data
    if (name.isEmpty && ageText.isEmpty) {
      _viewModel.refresh();
      return;
    }
    final age = ageText.isEmpty ? -1 : int.parse(ageText);
    _viewModel.queryContact(name, age);
  }

  void _deleteAction(Contact contact) {
    _viewModel.selectedContact = contact;
    _showConfirmDeleteDialog();
  }

  void _updateAction(Contact contact) {
    _nameEditingController.text = contact.name;
    _ageEditingController.text = "${contact.age}";
    _viewModel.selectedContact = contact;
  }

  void _clearTexts() {
    _nameEditingController.text = "";
    _ageEditingController.text = "";
  }

  void _deleteSelectedUser() {
    _viewModel.deleteSelectedContact();
  }

  void _showConfirmDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(AppStrings.deleteConfirmation),
            content: const Text(AppStrings.deleteConfirmationMsg),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _deleteSelectedUser();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: const Text(AppStrings.delete),
              ),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppStrings.cancel))
            ],
          );
        });
  }
}
