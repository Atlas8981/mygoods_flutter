import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

// import 'package:get/get.dart';
import 'package:mygoods_flutter/controllers/productController.dart';
import 'package:mygoods_flutter/views/cells/product_tile.dart';

class CategoryPage extends StatelessWidget {
  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: Colors.yellow,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Popular Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GridView.count(
                    scrollDirection: Axis.vertical,
                    //Very Important Line to make grid view scroll
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    crossAxisCount: 3,
                    //1.0
                    crossAxisSpacing: 4.0,
                    children: List.generate(
                      6, (index) {
                        return InkWell(
                          onTap: (){},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                width: 85,
                                height: 85,
                                // child: Column(
                                // mainAxis in column in top->bottom
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // children: [
                                //   ClipRRect(
                                //     borderRadius: BorderRadius.circular(10),
                                //     child: Image.network(
                                //       "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/images%2F05411168-1699-4119-a7af-b9017e2df1bd?alt=media&token=b4677321-c035-4cb4-9fc1-7cd869ebc017",
                                //       fit: BoxFit.fill,
                                //       height: 85,
                                //       width: 85,
                                //     ),
                                //
                                //   ),
                                // ],
                                // ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/mygoods-e042f.appspot.com/o/images%2F05411168-1699-4119-a7af-b9017e2df1bd?alt=media&token=b4677321-c035-4cb4-9fc1-7cd869ebc017",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                              Text(
                                "Parts & Accessories",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 10,
              color: Colors.black,
            ),
            Container(
              width: double.infinity,
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "More Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: double.infinity,
                    height: 20,
                  ),
                  ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){},
                        child: Container(
                          height: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                // color: Colors.red,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.camera),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        "asdsa",
                                        style: TextStyle(fontSize: 13),
                                      )),
                                      Icon(Icons.arrow_forward_ios),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ]),
                              ),
                              Container(
                                width: double.infinity,
                                height: 3,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                  //  Put Column
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
