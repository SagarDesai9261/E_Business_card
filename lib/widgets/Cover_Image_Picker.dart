import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoverImagePickerWidget extends StatefulWidget{
  final imageNetworkPath;
  final onSelectedImageChanged;
  final noCache;
  @override
  State<StatefulWidget> createState()=>CoverImagePickerWidgetState();

  CoverImagePickerWidget({this.imageNetworkPath,this.onSelectedImageChanged,this.noCache});
}

class CoverImagePickerWidgetState extends State<CoverImagePickerWidget>
{
  File _image;
  Future<File> profileImg;
  final  picker=ImagePicker();


  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
      widget.onSelectedImageChanged(_image);
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
      widget.onSelectedImageChanged(_image);

    });
  }
  @override
  void initState() {

    super.initState();
    print(_image);
    print(widget.imageNetworkPath);
    print(widget.noCache);
    if(widget.noCache!=null) {
      imageCache.clearLiveImages();
      imageCache.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: Container(
          // radius: 50,
          // backgroundColor: Theme.of(context).primaryColorLight,
          height: 220,
          padding: EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
          ),
          width: double.infinity,
          child: _image != null
              ? ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            child: Image.file(
              _image,
              width: 300,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
              : Container(
            // radius: 50,
            // backgroundColor: Theme.of(context).primaryColorLight,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xFFeef2fb),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              child: widget.imageNetworkPath!=null?
              // FadeInImage.assetNetwork(
              //   image:widget.imageNetworkPath,
              //   placeholder: "assets/images/placeholder-image.png",
              //   height:300,
              //   width: 100,
              //   fit: BoxFit.cover,)
              CachedNetworkImage(
                fit:BoxFit.cover,
                imageUrl: widget.imageNetworkPath,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.image),
              )
                  :
              Icon(
                Icons.camera_alt,
                color: Colors.grey[800],
              ),
            ),
          ),
        ),
      ),
    );
  }
}