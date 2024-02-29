import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WriteUserProfileCard extends StatefulWidget {
  final writeSpacialCardOnTap;
  final constraints;
  final singleContact;
  final listImageFlag;
  WriteUserProfileCard(
      {this.writeSpacialCardOnTap,
      this.constraints,
      this.singleContact,
      this.listImageFlag});

  @override
  _WriteUserProfileCardState createState() => _WriteUserProfileCardState();
}

class _WriteUserProfileCardState extends State<WriteUserProfileCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.singleContact['banner'].toString());
    return Container(
      width: double.infinity,
      height: 180,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      // decoration: BoxDecoration(color: Colors.black),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                  )
                ], borderRadius: BorderRadius.circular(15)),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 4,
                        )
                      ],
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Container(
                  height: 160,
                  child: VerticalDivider(
                    width: 2,
                    color: Colors.grey,
                    thickness: 2,
                    endIndent: 10,
                    indent: 5,
                  )),
            ],
          ),
          Container(
            width: widget.constraints.maxWidth - 40,
            child: InkWell(
              onTap: widget.writeSpacialCardOnTap,
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    elevation: 0,
                    // color:const Color(0xFFeef2fb),
                    // color: Colors.grey.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        // child: Image.asset(widget.listImageFlag?'assets/images/read_bg1.png':'assets/images/write_bg1.png',width: widget.constraints.maxWidth-35,fit:BoxFit.cover)
                        child: ColorFiltered(
                          colorFilter: new ColorFilter.mode(
                              Colors.transparent, BlendMode.srcOver),
                          child: CachedNetworkImage(
                            imageUrl: widget.singleContact['banner'].toString(),
                            placeholder: (ctx, obj) {
                              return Image.asset(
                                  widget.listImageFlag
                                      ? 'assets/images/read_bg1.png'
                                      : 'assets/images/write_bg1.png',
                                  width: widget.constraints.maxWidth - 35,
                                  fit: BoxFit.cover);
                            },
                            width: widget.constraints.maxWidth - 35,
                            fit: BoxFit.fill,
                            height: 180,
                            errorWidget: (ctx, obj, trak) {
                              return Image.asset(
                                  widget.listImageFlag
                                      ? 'assets/images/read_bg1.png'
                                      : 'assets/images/write_bg1.png',
                                  width: widget.constraints.maxWidth - 35,
                                  fit: BoxFit.cover);
                            },
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: ListTile(
                      title: Text(
                        "${widget.singleContact['title']}",
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      subtitle: Text(
                        widget.singleContact['designation'],
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 12),
                      ),
                      dense: true,
                      minVerticalPadding: 20,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 35,
                    child: Text(
                      widget.singleContact['sub_title'],
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontSize: 12, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
