import 'package:flutter/material.dart';
import 'package:flutter_demo/presentation/resources/values_manager.dart';

import '../model/contact.dart';

// ignore: must_be_immutable
class ContactWidget extends StatelessWidget {
  Contact contact;
  Function updateAction;
  Function deleteAction;

  ContactWidget(
      {Key? key,
      required this.contact,
      required this.updateAction,
      required this.deleteAction})
      : super(key: key);

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
                  children: [Text(contact.name), Text("${contact.age}")]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => deleteAction(contact),
                      icon: const Icon(Icons.delete)),
                  IconButton(
                      onPressed: () => updateAction(contact),
                      icon: const Icon(Icons.edit))
                ],
              )
            ],
          )),
    );
  }
}
