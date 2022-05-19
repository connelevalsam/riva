import 'package:flutter/material.dart';

import '../../themes/riva_theme.dart';

class ErrandView1 extends StatefulWidget {
  const ErrandView1({Key? key}) : super(key: key);

  @override
  _ErrandView1State createState() => _ErrandView1State();
}

class _ErrandView1State extends State<ErrandView1> {
  List<String> _imageList = [];
  List _itemsList = [];
  List<int> _selectedIndexList = [];
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();

    _imageList.add('https://picsum.photos/800/600/?image=280');
    _imageList.add('https://picsum.photos/800/600/?image=281');
    _imageList.add('https://picsum.photos/800/600/?image=282');
    _imageList.add('https://picsum.photos/800/600/?image=283');
    _imageList.add('https://picsum.photos/800/600/?image=284');

    _itemsList = [
      {"icon": Icons.set_meal, "items": "Fast food"},
      {"icon": Icons.local_drink_sharp, "items": "Wines"},
      {"icon": Icons.emoji_food_beverage, "items": "Beverages"},
      {"icon": Icons.menu_book, "items": "Fruits"},
      {"icon": Icons.set_meal, "items": "Fast food"},
    ];
  }

  void _changeSelection(bool enable, int index) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  GridTile getGridTile(int index) {
    if (_selectionMode) {
      return GridTile(
          header: ListTile(
            leading: Icon(
              _selectedIndexList.contains(index)
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: _selectedIndexList.contains(index)
                  ? Colors.green
                  : Colors.black,
              size: 20,
            ),
          ),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.blue[100] ?? Colors.blue, width: 10.0)),
              // child: Image.network(
              //   _imageList[index],
              //   fit: BoxFit.cover,
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    _itemsList[index]["icon"],
                    size: 80,
                    color: Colors.green,
                  ),
                  Text(
                    _itemsList[index]["items"],
                    style: RivaTheme.indigoText.headline4,
                  ),
                ],
              ),
            ),
            onLongPress: () {
              setState(() {
                _changeSelection(false, -1);
              });
            },
            onTap: () {
              setState(() {
                if (_selectedIndexList.contains(index)) {
                  _selectedIndexList.remove(index);
                } else {
                  _selectedIndexList.add(index);
                }
              });
            },
          ));
    } else {
      return GridTile(
        child: InkResponse(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  _itemsList[index]["icon"],
                  size: 80,
                  color: Colors.green,
                ),
                Text(
                  _itemsList[index]["items"],
                  style: RivaTheme.indigoText.headline4,
                ),
              ],
            ),
          ),
          onLongPress: () {
            setState(() {
              _changeSelection(true, index);
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Tap and hold to start selection',
            style: RivaTheme.blueText.headline3,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                primary: false,
                itemCount: _imageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return getGridTile(index);
                },
                padding: const EdgeInsets.all(4.0),
              ),
              Positioned(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        primary: Theme.of(context).primaryColor,
                        fixedSize: Size.fromWidth(
                            MediaQuery.of(context).size.width * .9)),
                    onPressed: () {},
                    child: Text(
                      "Next",
                      style: RivaTheme.whiteText.headline5,
                    ),
                  ),
                ),
                bottom: 5,
              )
            ],
          ),
        ),
      ],
    );
  }
}
