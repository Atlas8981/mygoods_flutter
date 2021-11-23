import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/user.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    // required this.user,
    this.user,
  }) : super(key: key);

  final User? user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
