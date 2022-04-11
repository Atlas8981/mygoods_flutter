import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheetWithSearch extends StatefulWidget {
  const CustomBottomSheetWithSearch({
    Key? key,
    this.scrollController,
    this.bottomSheetOffset,
    required this.onTapItem,
    required this.items,
  }) : super(key: key);

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
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchFieldCon,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _tempList = _buildSearchList(value);
                        });
                      },
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(
                      Icons.close,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        searchFieldCon.clear();
                        _tempList.clear();
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: (_tempList.isNotEmpty)
                      ? _tempList.length
                      : _listOfItems.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: (_tempList.isNotEmpty)
                          ? _showBottomSheetWithSearch(index, _tempList)
                          : _showBottomSheetWithSearch(index, _listOfItems),
                      onTap: () {
                        widget.onTapItem(
                          (_tempList.isNotEmpty)
                              ? _tempList[index]
                              : _listOfItems[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //8
  Widget _showBottomSheetWithSearch(int index, List<String> listOfCities) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        listOfCities[index],
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'KhmerOSBattambang',
        ),
        textAlign: TextAlign.start,
      ),
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
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.onItemClick(index);
              Get.back();
            },
            child: ListTile(

              title: Text(widget.items[index]),
            ),
          );
        },
      ),
    );
  }
}
