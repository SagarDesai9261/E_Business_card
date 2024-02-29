import 'package:e_business_card/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import '../../globals.dart' as globals;

class ServicesWidget extends StatefulWidget{

  final List<dynamic> servicesWidgetList;

  const ServicesWidget({Key key, this.servicesWidgetList=const[]}) : super(key: key);
  @override
  State<ServicesWidget> createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<ServicesWidget> {

  void removeServiceWidget(index){
    print('delete service index:$index');
    setState(() {
      widget.servicesWidgetList.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {

    return
      ListView.builder(
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 1,
        //   mainAxisExtent: 400,
        //   crossAxisSpacing: 10,
        //   mainAxisSpacing: 5
        // ),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: widget.servicesWidgetList.length,
        itemBuilder: (context, index) {
         // for(int index=0;index<widget.servicesWidgetList.length;index++)
          return Card(
          elevation: 5,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: ()=>removeServiceWidget(index),
                    icon: Icon(Icons.close)
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: Column(
                  children: [
                    ImagePickerWidget(
                      key: UniqueKey(),
                      noCache: true,
                      imageNetworkPath: '${globals.API_URL}/storage/service_images/${
                          widget.servicesWidgetList[index]['imageNetworkPath']
                        }',
                      defaultIcon: Icons.photo,
                      iconSize: 35,
                      selectedImage: widget.servicesWidgetList[index]['image_file'],
                      onSelectedImageChanged: (selectedImage){
                        setState(() {
                          widget.servicesWidgetList[index]['image_file']=selectedImage;
                        });
                      },
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      // readOnly: widget.textFieldReadOnlyFlag,
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        // return fieldValidator.titleValidator(value);
                        if(value.isEmpty)
                          return 'title can not be empty';
                        return null;
                      },
                      controller: widget.servicesWidgetList[index]['title'],
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        // labelText: 'First Name',
                        hintText: 'Enter title',
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      // readOnly: widget.textFieldReadOnlyFlag,
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: (value){
                      //   return fieldValidator.titleValidator(value);
                      // },
                      controller: widget.servicesWidgetList[index]['description'],
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
                    TextFormField(
                      // readOnly: widget.textFieldReadOnlyFlag,
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: (value){
                      //   return fieldValidator.titleValidator(value);
                      // },
                      controller: widget.servicesWidgetList[index]['purchase_link'],
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        // labelText: 'First Name',
                        hintText: 'Purchase link',
                      ),
                    ),
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