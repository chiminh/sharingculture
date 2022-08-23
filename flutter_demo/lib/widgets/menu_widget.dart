import 'package:flutter/material.dart';
import 'package:flutter_demo/presentation/resources/values_manager.dart';

class MenuWidget extends StatelessWidget {
  final String text;
  final Function onClick;

  const MenuWidget({Key? key, required this.text, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GestureDetector(
        onTap: () => onClick.call(),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: AppSize.s20, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
