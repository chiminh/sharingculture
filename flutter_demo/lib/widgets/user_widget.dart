import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user.dart';
import 'package:flutter_demo/presentation/resources/values_manager.dart';

// ignore: must_be_immutable
class UserWidget extends StatelessWidget {
  User user;
  UserWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppPadding.p16, AppPadding.p10, AppPadding.p16, AppPadding.p10),
          child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(user.username), Text("${user.age}")]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                ],
              )
            ],
          )),
    );
  }
}
