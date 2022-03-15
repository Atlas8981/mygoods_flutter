import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygoods_flutter/utils/constant.dart';
import 'package:mygoods_flutter/views/ListItems.dart';
import 'package:mygoods_flutter/views/cells/category_item_row.dart';

class SubCategoryPage extends StatelessWidget {
  const SubCategoryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => ListItem(),
                      );
                    },
                    child: CategoryItemRow(
                      name: "decideSubCategory()[index].name",
                      assetImage: "${imageDir}accessory.png",
                    ),
                  );
                },
              )
              //  Put Column
            ],
          ),
        ),
      ),
    );
  }
}
