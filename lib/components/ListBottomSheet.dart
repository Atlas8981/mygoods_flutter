
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheetWithSearch extends StatefulWidget {
  const CustomBottomSheetWithSearch(
      {Key? key,
        this.scrollController,
        this.bottomSheetOffset,
        required this.onTapItem,
        required this.items})
      : super(key: key);

  final ScrollController? scrollController;
  final double? bottomSheetOffset;
  final Function(String value) onTapItem;
  final List<String> items;

  @override
  _CustomBottomSheetWithSearchState createState() =>
      _CustomBottomSheetWithSearchState();
}

class _CustomBottomSheetWithSearchState
    extends State<CustomBottomSheetWithSearch> {
  List<String> _tempList = [];

  late final List<String> _listOfItems = widget.items;
  final TextEditingController searchFieldCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        // initialChildSize: 0.5,
        maxChildSize: 0.9,
        // minChildSize: 0.5,

        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    child: TextField(
                        controller: searchFieldCon,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          //4
                          setState(() {
                            _tempList = _buildSearchList(value);
                          });
                        })),
                IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.close,
                      size: 28,
                    ),
                    // color: Color(0xFF1F91E7),
                    onPressed: () {
                      setState(() {
                        searchFieldCon.clear();
                        _tempList.clear();
                      });
                    }),
              ]),
              Expanded(
                child: ListView.builder(
                    controller: scrollController,
                    // physics: const NeverScrollableScrollPhysics(),
                    //5
                    shrinkWrap: true,
                    itemCount: (_tempList.isNotEmpty)
                        ? _tempList.length
                        : _listOfItems.length,
                    // separatorBuilder: (context, int) {
                    //   return Divider();
                    // },
                    itemBuilder: (context, index) {
                      return InkWell(

                        //6
                          child: (_tempList.isNotEmpty)
                              ? _showBottomSheetWithSearch(index, _tempList)
                              : _showBottomSheetWithSearch(
                              index, _listOfItems),
                          onTap: () {
                            widget.onTapItem((_tempList.isNotEmpty)
                                ? _tempList[index]
                                : _listOfItems[index]);
                          });
                    }),
              ),
            ]),
          );
        });
  }

  //8
  Widget _showBottomSheetWithSearch(int index, List<String> listOfCities) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(listOfCities[index],
          style: TextStyle(fontSize: 16, fontFamily: 'KhmerOSBattambang'),
          // style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.start),
    );
  }

  //9
  List<String> _buildSearchList(String userSearchTerm) {
    List<String> _searchList = [];

    for (int i = 0; i < _listOfItems.length; i++) {
      String name = _listOfItems[i];
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(_listOfItems[i]);
      }
    }
    return _searchList;
  }
}

class ListButtonSheet extends StatefulWidget {
  const ListButtonSheet({
    Key? key,
    required this.items,
    required this.onItemClick,
  }) : super(key: key);

  final List<String> items;
  final Function(int index) onItemClick;

  @override
  _ListButtonSheetState createState() => _ListButtonSheetState();
}

class _ListButtonSheetState extends State<ListButtonSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.onItemClick(index);
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.items[index],
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          );
        },
      ),
    );
  }
}