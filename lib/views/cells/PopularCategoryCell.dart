import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mygoods_flutter/models/category.dart';

class PopularCategoryCell extends StatelessWidget {
  const PopularCategoryCell(
    this.category, {
    Key? key,
    required this.destination,
  }) : super(key: key);
  final Category category;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      openBuilder: (context, action) {
        return destination;
      },
      closedBuilder: (context, action) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(category.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
