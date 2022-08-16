import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user.dart';
import 'package:flutter_demo/presentation/resources/strings_manager.dart';
import 'package:flutter_demo/presentation/resources/values_manager.dart';
import 'package:flutter_demo/widgets/user_widget.dart';

class SQLScreen extends StatefulWidget {
  const SQLScreen({Key? key}) : super(key: key);

  @override
  State<SQLScreen> createState() => _SQLScreenState();
}

class _SQLScreenState extends State<SQLScreen> {
  @override
  Widget build(BuildContext context) {
    return _getContentViews();
  }

  Widget _getContentViews() {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.sqlDemo)),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: _getInputDecoration(AppStrings.userName),
              ),
              const SizedBox(
                height: AppSize.s10,
              ),
              TextField(
                decoration: _getInputDecoration(AppStrings.age),
              ),
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
                    user: User(username: "Minh", age: 20),
                  );
                },
                itemCount: 1000,
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

  void _insert() {}

  void _update() {}

  void _delete() {}
}
