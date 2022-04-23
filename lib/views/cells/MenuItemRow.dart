import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItemRow extends StatelessWidget {
  const MenuItemRow({
    Key? key,
    required this.name,
    required this.assetImage,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String assetImage;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(0),
      leading: Image.asset(
        assetImage,
        width: 25,
        height: 25,
        fit: BoxFit.cover,
      ),
      title: Text(name.tr),
      trailing: const Icon(Icons.arrow_forward_ios),
      horizontalTitleGap: 0,
    );
  }
}
