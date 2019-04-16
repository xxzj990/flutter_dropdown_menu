import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter/material.dart';

typedef CustomDropdownMenuOnSelected(
    {int menuIndex, int index, int subIndex, dynamic data});

class CustomDropdownMenu extends StatefulWidget {
  List<List<Object>> meuns;
  Widget content;
  CustomDropdownMenuOnSelected callback;
  int menu0Index;
  int menu1Index;
  int menu2Index;
  int menu2SubIndex;

  CustomDropdownMenu({
    Key key,
    @required this.meuns,
    @required this.content,
    this.callback = null,
    this.menu0Index = 0,
    this.menu1Index = 0,
    this.menu2Index = 0,
    this.menu2SubIndex = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomDropdownMenuState();
  }
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultDropdownMenuController(
      onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
        print("menuIndex:$menuIndex index:$index subIndex:$subIndex data:$data");

        setState(() {
          switch (menuIndex) {
            case 0:
              widget.menu0Index = index;
              widget.menu1Index = 0; // 第一个菜单重置第二个菜单
              break;
            case 1:
              widget.menu1Index = index;
              break;
            case 2:
              widget.menu2Index = index;
              widget.menu2SubIndex = subIndex;
              break;
          }
        });

        if(widget.callback != null) {
          widget.callback(menuIndex: menuIndex, index: index, subIndex: subIndex, data: data);
        }
      },
      child: new Column(
        children: <Widget>[
          buildDropdownHeader(),
          new Expanded(
              child: new Stack(
            children: <Widget>[
              widget.content,
              buildDropdownMenu(),
            ],
          ))
        ],
      ),
    );
  }

  DropdownHeader buildDropdownHeader() {
    Map menu2 = widget.meuns[2][widget.menu0Index];

    return new DropdownHeader(
      backgroundColor: Colors.yellow,
      textColor: Colors.white,
      hasBorder: false,
      itemWidth: 60.0,
      titles: [widget.meuns[0][widget.menu0Index], widget.meuns[1][widget.menu1Index], menu2['children'][widget.menu2SubIndex]],
    );
  }

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(maxMenuHeight: kDropdownMenuItemHeight * 10, backgroundColor: Colors.white,
        //  activeIndex: activeIndex,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  data: widget.meuns[0],
                  itemBuilder: buildMenu0Item,
                );
              },
              height: kDropdownMenuItemHeight * widget.meuns[0].length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  data: widget.meuns[1],
                  itemBuilder: buildMenu1Item,
                );
              },
              height: kDropdownMenuItemHeight * widget.meuns[1].length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownTreeMenu(
                  selectedIndex: 0,
                  subSelectedIndex: 0,
                  itemExtent: 45.0,
                  background: Colors.red,
                  subBackground: Colors.blueAccent,
                  itemBuilder: buildMenu2Item,
                  subItemBuilder: buildMenu2SubItem,
                  getSubData: (dynamic data) {
                    return data['children'];
                  },
                  data: widget.meuns[2],
                );
              },
              height: 450.0)
        ]);
  }

  Widget buildMenu0Item(BuildContext context, dynamic data, int index) {
    bool selected = index == widget.menu0Index;
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Text(
              defaultGetItemLabel(data),
              style: selected
                  ? new TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400)
                  : new TextStyle(fontSize: 14.0),
            ),
            new Expanded(
                child: new Align(
              alignment: Alignment.centerRight,
              child: selected
                  ? new Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            )),
          ],
        ));
  }

  Widget buildMenu1Item(BuildContext context, dynamic data, int index) {
    bool selected = index == widget.menu1Index;
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Text(
              defaultGetItemLabel(data),
              style: selected
                  ? new TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400)
                  : new TextStyle(fontSize: 14.0),
            ),
            new Expanded(
                child: new Align(
              alignment: Alignment.centerRight,
              child: selected
                  ? new Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            )),
          ],
        ));
  }

  Widget buildMenu2Item(BuildContext context, dynamic data, int index) {
    if (index != widget.menu2Index) {
      return new DecoratedBox(
          decoration: new BoxDecoration(border: new Border(right: Divider.createBorderSide(context))),
          child: new Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: new Row(
                children: <Widget>[
                  new Text(data['title']),
                ],
              )));
    } else {
      return new DecoratedBox(
          decoration: new BoxDecoration(border: new Border(top: Divider.createBorderSide(context), bottom: Divider.createBorderSide(context))),
          child: new Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: new Row(
                children: <Widget>[
                  new Container(color: Theme.of(context).primaryColor, width: 3.0, height: 20.0),
                  new Padding(padding: new EdgeInsets.only(left: 12.0), child: new Text(data['title'])),
                ],
              )));
    }
  }

  Widget buildMenu2SubItem(BuildContext context, dynamic data, int index) {
    Color color = index == widget.menu2SubIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.body1.color;

    return new SizedBox(
      height: 45.0,
      child: new Row(
        children: <Widget>[
          new Text(
            data['title'],
            style: new TextStyle(color: color),
          ),
          new Expanded(child: new Align(alignment: Alignment.centerRight, child: new Text(data['count'].toString())))
        ],
      ),
    );
  }
}
