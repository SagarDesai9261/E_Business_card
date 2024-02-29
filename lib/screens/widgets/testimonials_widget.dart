import 'package:e_business_card/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class TestimonialsWidget extends StatefulWidget{

  final List<dynamic> testimonialsWidgetList;

  const TestimonialsWidget({Key key, this.testimonialsWidgetList=const[]}) : super(key: key);
  @override
  State<TestimonialsWidget> createState() => _TestimonialsWidgetState();
}

class _TestimonialsWidgetState extends State<TestimonialsWidget> {

  void removeTestimonialsWidget(index){
    print('delete service index:$index');
    setState(() {
      widget.testimonialsWidgetList.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 1,
        //     mainAxisExtent: 400,
        //     crossAxisSpacing: 10,
        //     mainAxisSpacing: 5
        // ),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: widget.testimonialsWidgetList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: ()=>removeTestimonialsWidget(index),
                      icon: Icon(Icons.close)
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: Column(
                    children: [
                      ImagePickerWidget(
                        // noCache: true,
                        key: UniqueKey(),
                        imageNetworkPath: 'http://360smartbusinesscard.com/app/storage/testimonials_images/${
                          widget.testimonialsWidgetList[index]
                              ['imageNetworkPath']
                        }',
                        defaultIcon: Icons.photo,
                        iconSize: 35,
                        selectedImage: widget.testimonialsWidgetList[index]['image_file'],
                        onSelectedImageChanged: (selectedImage){
                          setState(() {
                            widget.testimonialsWidgetList[index]['image_file']=selectedImage;
                          });
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15),
                          child: Text('${double.parse(widget.testimonialsWidgetList[index]['rating'].text).round()}/5',style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Color(0xFF333333),fontSize: 19,fontWeight: FontWeight.bold
                          ),)
                      ),
                      RatingBar.builder(
                        initialRating: double.parse(widget.testimonialsWidgetList[index]['rating'].text),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                          setState(() {
                            widget.testimonialsWidgetList[index]['rating'].text=rating.toString();
                          });
                        },
                      ),
                      const SizedBox(height: 15,),
                      TextFormField(
                        // readOnly: widget.textFieldReadOnlyFlag,
                        autofocus: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (value){
                        //   return fieldValidator.titleValidator(value);
                        // },
                        controller:  widget.testimonialsWidgetList[index]['description'],
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          // labelText: 'First Name',
                          hintText: 'Enter description',
                        ),
                      ),
                      const SizedBox(height: 15,),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}