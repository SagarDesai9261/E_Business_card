import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandableListTileWidget extends StatefulWidget{
  @override
  State<ExpandableListTileWidget> createState() => _ExpandableListTileWidgetState();
  final String title;
  final icon;
  final iconColor;
  final children;
  final bool readonlyFlag;
  ExpandableListTileWidget({this.title,this.icon,this.iconColor,this.children,
    this.readonlyFlag=false,
  });
}

class _ExpandableListTileWidgetState extends State<ExpandableListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.title),
      tilePadding: EdgeInsets.zero,
      leading: widget.icon.runtimeType==IconData?
      Icon(widget.icon,color: widget.iconColor,)
          : SvgPicture.asset(
        widget.icon,
        color:widget.iconColor,
        width: 25,
        height: 25,
      ),
      childrenPadding: EdgeInsets.all(10),
      children: [
        AbsorbPointer(
          absorbing: widget.readonlyFlag,
          child: Column(
            children: [
              ...widget.children
            ],
          ),
        )
        // ...widget.children.map((item) {
        //   return ListTile(
        //     // onTap:()=>listTileOnTap(currentTitle:item['currentEditTitle'],currentWidget: item['currentEditWidget'] ),
        //     // leading: Container(
        //     //   height: 100,
        //     //   width: 5,
        //     //   child: Column(
        //     //     children: [
        //     //       Expanded(child: VerticalDivider(color: Color(0xFFe3e3e3),)),
        //     //     ],
        //     //   ),
        //     // ),
        //     title: Text(item['title']),
        //   );
        // }).toList(),
      ],
    );
  }
}