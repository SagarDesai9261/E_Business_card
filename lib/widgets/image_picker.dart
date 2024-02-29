import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../globals.dart' as globals;
class ImagePickerWidget extends StatefulWidget{
  final imageNetworkPath;
  final onSelectedImageChanged;
  final noCache;
  final IconData defaultIcon;
  final double iconSize;
  final File selectedImage;
  @override
  State<StatefulWidget> createState()=>ImagePickerWidgetState();

  ImagePickerWidget({Key key,this.imageNetworkPath,this.onSelectedImageChanged,
    this.noCache,this.defaultIcon= Icons.camera_alt,this.iconSize=30.0,
    this.selectedImage
  }):super(key: key);
}

class ImagePickerWidgetState extends State<ImagePickerWidget>
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
      print("image network path ${widget.imageNetworkPath}");
      print("image file path ${widget.selectedImage}");
      print("image file path(globals) ${globals.selectedAvatarImage}");
      print(widget.noCache);
      if(widget.noCache!=null) {
        imageCache.clearLiveImages();
        imageCache.clear();
      }

      setState(() {
        if(widget.selectedImage!=null){
          if(widget.selectedImage.path.isNotEmpty) {
            _image = widget.selectedImage;
          }
        }
      });
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
        child: CircleAvatar(
          radius: 50,
          backgroundColor:Color(0xFF006ade),
          child: _image != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.file(
              _image,
              width: 300,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
              : CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: widget.imageNetworkPath!=null?
            // FadeInImage.assetNetwork(
            //   image:widget.imageNetworkPath,
            //   placeholder: "assets/images/avatar_place_holder.png",
            //   height:300,
            //   width: 100,
            //   fit: BoxFit.cover,)
            CachedNetworkImage(
              height: 300,
              width: 100,
              fit:BoxFit.cover,
              imageUrl:widget.imageNetworkPath,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.image),
            )
            :
            Icon(
              widget.defaultIcon,
              color: Colors.black,
              size: widget.iconSize,
            ),
          ),
        ),
        ),
      ),
    );
  }
}