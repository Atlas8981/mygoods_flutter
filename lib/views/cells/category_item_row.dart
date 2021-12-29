import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryItemRow extends StatelessWidget {
  const CategoryItemRow({
    Key? key,
    required this.name,
    required this.assetImage,
  }) : super(key: key);

  // final Category category;
  final String name;
  final String assetImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                assetImage,
                width: 25,
                height: 25,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                name,
                style: TextStyle(fontSize: 13),
              )),
              Icon(Icons.arrow_forward_ios),
              SizedBox(
                width: 10,
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
