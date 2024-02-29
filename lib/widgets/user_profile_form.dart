import 'dart:core';
import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_business_card/dialogs/add_fields_dialog.dart';
import 'package:e_business_card/screens/widgets/appointment_widget.dart';
import 'package:e_business_card/screens/widgets/business_hours_widget.dart';
import 'package:e_business_card/screens/widgets/expandable_list_tile_widget.dart';
import 'package:e_business_card/screens/widgets/services_widget.dart';
import 'package:e_business_card/screens/widgets/testimonials_widget.dart';
import 'package:e_business_card/textfield_validator.dart';
import 'package:e_business_card/util/constant_data.dart';
import 'package:e_business_card/widgets/Cover_Image_Picker.dart';
import 'package:e_business_card/widgets/image_picker.dart';
import 'package:e_business_card/widgets/leading_icon_textfield_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';


import '../src/repositories/repositories.dart';
import '../src/bloc/blocs.dart';
import '../globals.dart' as globals;

class UserProfileForm extends StatefulWidget {
  final formKey;

  final TextEditingController titleController;
  final TextEditingController subTitleController;
  final TextEditingController designationController;
  final TextEditingController metaKeywordsController;
  final TextEditingController metaDescriptionController;
  final TextEditingController descriptionController;
  final TextEditingController googleAnalyticController;
  final TextEditingController facebookPixelController;
  final TextEditingController customJSController;
  final TextEditingController slugController;
  final bool editable;

  final websiteController;
  final cityController;
  final countryController;
  final stateController;
  final postalCodeController;
  final linkedInController;
  final twitterController;
  final facebookController;
  final instagramController;
  final youtubeController;
  final compnayNameController;
  final cardPopUpMenuString;
  final businessId;
  int mobileVisibleCounter;
  int emailVisibleCounter;
  final List<TextEditingController> mobileNumberGroup;
  final List<dynamic> multipleDynamicFieldList;
  final List<dynamic> contactInfoWidgetList;
  final List<dynamic> socialLinksWidgetList;
  final List<dynamic> businessHourWidgetList;
  final List<dynamic> appointmentWidgetList;
  final List<dynamic> servicesWidgetList;
  final List<dynamic> testimonialsWidgetList;
  final List switchFlags;

  // List<TextEditingController> emailAddressGroup;
  bool textFieldReadOnlyFlag;

  UserProfileForm(
      {this.formKey,
      this.customJSController,
      this.facebookPixelController,
      this.googleAnalyticController,
      this.metaDescriptionController,
      this.editable,
      this.metaKeywordsController,
      this.websiteController,
      this.mobileNumberGroup,
      this.subTitleController,
      this.cityController,
      this.countryController,
      this.descriptionController,
      this.designationController,
      this.titleController,
      this.postalCodeController,
      this.facebookController,
      this.instagramController,
      this.linkedInController,
      this.twitterController,
      this.youtubeController,
      this.compnayNameController,
      this.mobileVisibleCounter,
      this.emailVisibleCounter,
      this.cardPopUpMenuString,
      this.businessId,
      this.textFieldReadOnlyFlag,
      @required this.stateController,
      this.multipleDynamicFieldList = const [],
      this.contactInfoWidgetList = const [],
      this.socialLinksWidgetList = const [],
      this.businessHourWidgetList = const [],
      this.appointmentWidgetList = const [],
      this.servicesWidgetList = const [],
      this.testimonialsWidgetList = const [],
      this.switchFlags,
      this.slugController
      // this.emailAddressGroup
      });

  UserProfileFormState createState() => UserProfileFormState();
}

class UserProfileFormState extends State<UserProfileForm> {
  final fieldValidator = FieldValidator();
  String mobileEmailLeadingString = 'Work';
   Map<String, Object> singleCard;
  bool visibleBloc = false;
   DataBloc _dataBloc;
   File selectedAvatarImage;
   File selectCoverImage;
   String editTimeAvatarImage, editTimeCoverImage;
  // final stateController=TextEditingController();
  bool contactInfoSwitchFlag = false,
      mediaSwitchFlag = false,
      appointmentSwitchFlag = false,
      servicesSwitchFlag = false,
      testimonialsSwitchFlag = false,
      socialLinksSwitchFlag = false;

  List dynamicSectionList = [];

  String filePath = 'No file selected';
  String fileName = "";
  String errorMessage = ''; // Declare this in your class or widget
  Future<void> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(

    );

    if (result != null) {
      // Get the selected file
      PlatformFile file = result.files.single;

      // Validate file type (allow only PDF)
      if (!file.name.toLowerCase().endsWith('.pdf')) {
        // File type is not PDF, handle accordingly (show an error message, etc.)
        print('Only PDF files are allowed');
        setState(() {
          errorMessage = 'Only PDF files are allowed';
        });
        return;
      }

      // Validate file size
      if (file.size > 2 * 1024 * 1024) {
        // File size exceeds 2MB, handle accordingly (show an error message, etc.)
        print('File size exceeds 2MB');
        setState(() {
          errorMessage = 'File size exceeds 2MB';
        });
        return;
      }

      // Set state with file path and filename
      setState(() {
        filePath = file.path ?? 'No file path';
        fileName = file.name ?? 'No file name';
      });
      setState(() {
        errorMessage = '';
      });
      // Print file details
      print('File path: $filePath');
      print('File name: $fileName');
    }
  }
  media_dialog_box()async{
  /*  var result = await
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(20),
                dashPattern: [10, 10],
                color: Colors.grey,
                strokeWidth: 2,
                child: Center(
                  child: InkWell(
                    onTap: (){
                      pickFile();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Browse file from device',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Column(
              children: [
                SizedBox(height: 20,),
                errorMessage != ""?

                Text(
                  errorMessage.isNotEmpty ? errorMessage : '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ): Text(
                  filePath.isEmpty ? '' : 'File: $fileName',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20,),
            Text("OR"),
            SizedBox(height: 20,),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Enter link or Url",
                  border: OutlineInputBorder(
                  )
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 50.0,
              child: MaterialButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Add the media",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

        ),
      ),
    );*/
    var result = await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    dashPattern: [10, 10],
                    color: Colors.grey,
                    strokeWidth: 2,
                    child: Center(
                      child: InkWell(
                        onTap: (){
                          pickFile();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Browse file from device',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    SizedBox(height: 20,),
                    errorMessage != ""?

                    Text(
                      errorMessage.isNotEmpty ? errorMessage : '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ): Text(
                      filePath.isEmpty ? '' : 'File: $fileName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20,),
                Text("OR"),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Enter link or Url",
                      border: OutlineInputBorder(
                      )
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50.0,
                  child: MaterialButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Add the media",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

            ),
          );
        });
    print('selected field:${ConstantData.addsocialList[result]}');
    var selectedField = ConstantData.addsocialList[result];
    setState(() {
      widget.socialLinksWidgetList.add({
        'type': '${selectedField['title'].toString().toLowerCase()}',
        'icon': "${selectedField['icon']}",
        'controller': TextEditingController(),
      });
    });

  }
  void mobileNumberSuffixIconOnTapIncrease() {
    print('mobile number filed ++');
    setState(() {
      if (widget.mobileNumberGroup.length < 2) {
        widget.mobileNumberGroup.add(TextEditingController());
        // print(widget.mobileNumberGroup[0]);
        // widget.mobileVisibleCounter++;
      } else {
        Fluttertoast.showToast(
            msg: "You can not add more then 3 mobile Numbers!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void emailSuffixIconOnTapIncrease() {
    print('email filed ++');
    setState(() {
      if (widget.emailVisibleCounter < 1) {
        // widget.emailAddressGroup.add(TextEditingController());
        widget.emailVisibleCounter = widget.emailVisibleCounter + 1;
      } else {
        Fluttertoast.showToast(
            msg: "You can not add more then 2 email address!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void mobileSuffixIconOnTapDecrease(i) {
    setState(() {
      if (widget.mobileNumberGroup.length > 0) {
        // widget.mobileVisibleCounter--;
        widget.mobileNumberGroup.removeAt(i);
      }
    });
  }

  void emailSuffixIconOnTapDecrease() {
    setState(() {
      if (widget.emailVisibleCounter > 0) {
        // widget.emailController2.text="";
        widget.emailVisibleCounter = widget.emailVisibleCounter - 1;
        // widget.emailAddressGroup.removeAt(emailVisibleCounter);
      }
    });
    // print('email group Controller length ${widget.emailAddressGroup.length}');
  }

  void addMultipleDynamicField() {
    setState(() {
      widget.multipleDynamicFieldList
          .add({'type': 'Select Type', 'controller': TextEditingController()});
    });
  }

  void removeMultipleDynamicField(index) {
    setState(() {
      widget.multipleDynamicFieldList.removeAt(index);
    });
  }

  void onTextFieldTypeChange({index, type}) {
    setState(() {
      widget.multipleDynamicFieldList[index]['type'] = type;
    });
    print('multi dynamic field:${widget.multipleDynamicFieldList}');
  }

  Widget getContactInfoWidgetList(type) {
    // This method is used to get Contact info and Social Link Widget list
    List widgetDataList = type == 'Contact Info'
        ? widget.contactInfoWidgetList
        : widget.socialLinksWidgetList;

    print('get Contact info called');
    return Column(children: [
      for (int i = 0; i < widgetDataList.length; i++)
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            children: [
              LeadingIconTextFieldWidget(
                controller: widgetDataList[i]['controller'],
                prefixIcon: widgetDataList[i]['icon'],
                index: i,
                keyBoardType: TextInputType.text,
                suffixIcon: Icon(Icons.remove_circle),
                suffixIconOnTap: () => type == 'Contact Info'
                    ? removeContactInfoField(i)
                    : removeSocialLinkField(i),
                textFieldReadOnlyFlag: widget.textFieldReadOnlyFlag,
                validator: (String value) {
                  if (value.trim().isEmpty) {
                    return 'Please enter value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              // Add an additional text field if the type is 'Address'
              if (type == 'Contact Info' &&
                  widgetDataList[i]['type'] == 'Address')
                LeadingIconTextFieldWidget(
                  controller:widgetDataList[i]['extra_controller'], // You can use a separate controller
                  prefixIcon:  widgetDataList[i]['icon'], // Or any other icon for the address
                  index: i,
                  keyBoardType: TextInputType.text,
                  suffixIcon: Icon(Icons.blind, color: Colors.transparent),
                  suffixIconOnTap: () => removeContactInfoField(i),
                  textFieldReadOnlyFlag: widget.textFieldReadOnlyFlag,
                  validator: (String value) {
                    // Add validation logic if needed
                    return null;
                  },
                ),
            ],
          ),
        ),
    ]);
  }


  Widget getSocialLinkWidgetList(type) {
    //this method is used to get Contact info and Social Link Widget list
    List widgetDataList = widget.socialLinksWidgetList;

    print('get Social Lisk callled');
    return Column(children: [
      for (int i = 0; i < widgetDataList.length; i++)
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: LeadingIconTextFieldWidget(
            validator: (value) {
              if (!isURL(value)) {
                return "Please Enter Valid URL";
              }
              return null;
            },
            controller: widgetDataList[i]['controller'],
            prefixIcon: widgetDataList[i]['icon'],
            index: i,
            // textFieldHint:widget.contactInfoWidgetList[i]['type'] ,
            keyBoardType: TextInputType.text,
            suffixIcon: Icon(Icons.remove_circle),
            suffixIconOnTap: () => removeSocialLinkField(i),
            textFieldReadOnlyFlag: widget.textFieldReadOnlyFlag,
            //  validator:
          ),
        ),
    ]);
  }
  Widget getMediaWidgetList(type) {
    //this method is used to get Contact info and Social Link Widget list
    List widgetDataList = widget.socialLinksWidgetList;

    print('get Social Lisk callled');
    return Column(children: [
      for (int i = 0; i < widgetDataList.length; i++)
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: LeadingIconTextFieldWidget(
            validator: (value) {
              if (!isURL(value)) {
                return "Please Enter Valid URL";
              }
              return null;
            },
            controller: widgetDataList[i]['controller'],
            prefixIcon: widgetDataList[i]['icon'],
            index: i,
            // textFieldHint:widget.contactInfoWidgetList[i]['type'] ,
            keyBoardType: TextInputType.text,
            suffixIcon: Icon(Icons.remove_circle),
            suffixIconOnTap: () => removeSocialLinkField(i),
            textFieldReadOnlyFlag: widget.textFieldReadOnlyFlag,
            //  validator:
          ),
        ),
    ]);
  }

  Widget getBusinessHourWidget(type) {
    print('getBusinessHour call:${widget.businessHourWidgetList}');
    return BusinessHourWidget(
      businessHourWidgetList: widget.businessHourWidgetList,
    );
  }

  Widget getAppointmentWidget(type) {
    return AppointmentWidget(
        appointmentWidgetList: widget.appointmentWidgetList);
  }

  Widget getServicesWidget(type) {
    return ServicesWidget(servicesWidgetList: widget.servicesWidgetList);
  }

  Widget getTestimonialsWidget(type) {
    return TestimonialsWidget(
        testimonialsWidgetList: widget.testimonialsWidgetList);
  }

  void addContactInfoMethod() async {
    var result = await showDialog(
        context: context,
        builder: (ctx) {
          return AddFieldsDialogWidget(
            forsicial: false,
          );
        });

    if (result == false) return;

    print('selected field:${ConstantData.addFieldsList[result]}');
    var selectedField = ConstantData.addFieldsList[result];
    setState(() {
      widget.contactInfoWidgetList.add({
        'type': '${selectedField['title']}',
        'icon': "${selectedField['icon']}",
        'controller': TextEditingController(),
        'extra_controller':TextEditingController(text:"#")
      });
    });
  }

  void removeContactInfoField(index) {
    setState(() {
      widget.contactInfoWidgetList.removeAt(index);
    });
  }

  void addSocialLinkMethod() async {
    var result = await showDialog(
        context: context,
        builder: (ctx) {
          return AddFieldsDialogWidget(
            forsicial: true,
          );
        });
    print('selected field:${ConstantData.addsocialList[result]}');
    var selectedField = ConstantData.addsocialList[result];
    setState(() {
      widget.socialLinksWidgetList.add({
        'type': '${selectedField['title'].toString()}',
        'icon': "${selectedField['icon']}",
        'controller': TextEditingController(),
      });
    });
  }

  void removeSocialLinkField(index) {
    setState(() {
      widget.socialLinksWidgetList.removeAt(index);
    });
  }

  void addAppointmentMethod() async {
    setState(() {
      widget.appointmentWidgetList.add({
        'start_hour': TextEditingController(),
        'end_hour': TextEditingController(),
      });
    });
  }

  void addServicesMethod() async {
    setState(() {
      widget.servicesWidgetList.add({
        'imageNetworkPath': null,
        'image_file': File(''),
        'title': TextEditingController(),
        'description': TextEditingController(),
        'purchase_link': TextEditingController(),
      });
    });
  }

  void addTestimonialsMethod() async {
    setState(() {
      widget.testimonialsWidgetList.add({
        'imageNetworkPath': null,
        'image_file': File(''),
        'rating': TextEditingController(text: '0'),
        'description': TextEditingController(),
      });
    });
  }

  @override
  void initState() {
    super.initState();
    widget.emailVisibleCounter = 0;
    widget.mobileVisibleCounter = 0;
    widget.mobileNumberGroup.clear();
    widget.multipleDynamicFieldList.clear();
    if (widget.businessId != null) {
      globals.selectedAvatarImage = null;
      globals.selectedCoverImage = null;
    }
    if (widget.cardPopUpMenuString == "Edit" ||
        widget.cardPopUpMenuString == "View") {
      setState(() {
        getSingleContactCardInfo();
      });
    }

    dynamicSectionList = [
      {
        'title': 'Contact Info',
        'switch_title': 'Enable Contact Info',
        'switch_flag': contactInfoSwitchFlag,
        'show_add_button': true,
        'add_click': addContactInfoMethod,
        'dynamic_widget': getContactInfoWidgetList
      },
     /* {
        'title': 'Business Hours',
        'switch_title': 'Enable Business Hours',
        'switch_flag': mediaSwitchFlag,
        'show_add_button': false,
        'add_click': () {},
        'dynamic_widget': getBusinessHourWidget
      },*/
     /* {
        'title': 'Appointment',
        'switch_title': 'Enable Appointment',
        'switch_flag': appointmentSwitchFlag,
        'show_add_button': true,
        'add_click': addAppointmentMethod,
        'dynamic_widget': getAppointmentWidget
      },
      {
        'title': 'Services',
        'switch_title': 'Enable Services',
        'switch_flag': servicesSwitchFlag,
        'show_add_button': true,
        'add_click': addServicesMethod,
        'dynamic_widget': getServicesWidget
      },
      {
        'title': 'Testimonials',
        'switch_title': 'Enable Testimonials',
        'switch_flag': testimonialsSwitchFlag,
        'show_add_button': true,
        'add_click': addTestimonialsMethod,
        'dynamic_widget': getTestimonialsWidget
      },*/
      {
        'title': 'Social Links',
        'switch_title': 'Enable Social Links',
        'switch_flag': socialLinksSwitchFlag,
        'show_add_button': true,
        'add_click': addSocialLinkMethod,
        'dynamic_widget': getSocialLinkWidgetList
      },
      /* {
        'title': "Media's",
        'switch_title': 'Enable Medias',
        'switch_flag': mediaSwitchFlag,
        'show_add_button': true,
        'add_click': media_dialog_box,
        'dynamic_widget': getMediaWidgetList
      },*/
    ];
  }

  void getSingleContactCardInfo() {
    visibleBloc = true;
    print(widget.businessId);

    var url = '${globals.API_URL}/api/show_business_card_details';
    var data = {
      "business_id": widget.businessId,
    };
    print("Business id is ${widget.businessId}");

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  Future apiResponse(List<Object> responseData) async {
    // print('single Card responce: $responseData');

    Map<String, Object> responseMap = responseData[0];


    if (responseMap['status'].toString() == '1') {
      List<dynamic> result = responseMap['result'];

      print(result[0]);
      var businessCardData = result[0]['business_card'][0];

      print('businesscard result ${businessCardData}');
      print(result[0]);

      widget.titleController.text = businessCardData['title'] ?? '';
      widget.designationController.text = businessCardData['designation'] ?? '';
      widget.subTitleController.text = businessCardData['sub_title'] ?? '';
      widget.descriptionController.text = businessCardData['description'] ?? '';
      widget.slugController.text = businessCardData['slug'] ?? '';
      widget.metaKeywordsController.text =
          businessCardData['meta_keyword'] ?? '';
      widget.metaDescriptionController.text =
          businessCardData['meta_description'] ?? '';
      widget.googleAnalyticController.text =
          businessCardData['google_analytic'] ?? '';
      widget.facebookPixelController.text =
          businessCardData['fbpixel_code'] ?? '';
      widget.customJSController.text = businessCardData['customjs'] ?? '';
      widget.metaDescriptionController.text =
          businessCardData['meta_description'] ?? '';
      widget.metaDescriptionController.text =
          businessCardData['meta_description'] ?? '';
      editTimeAvatarImage = businessCardData['logo'] ?? '';
      editTimeCoverImage = businessCardData['banner'] ?? '';

      //contact info section
      // if((result[0]['contact_info'] as List).isNotEmpty) {
      //   Map<dynamic,
      //       dynamic> contactInfoContent = result[0]['contact_info'][0]['content'] ??
      //       {};
      //   widget.switchFlags[0] =
      //   result[0]['contact_info'][0]['is_enabled'] == '1' ? true : false;
      //   print('contact info content${contactInfoContent}');
      //   widget.contactInfoWidgetList.clear();

      //   contactInfoContent.forEach((key, value) {
      //     print('single contact info content$value');
      //     List<dynamic> contactInfoList = [];

      //     value.entries.map((entry) {
      //       if (entry.key != 'id') {
      //         contactInfoList.add({'type': entry.key, 'value': entry.value});
      //       }
      //     }).toList();
      //     print('contact info content list:$contactInfoList');
      //     contactInfoList.forEach((element) {
      //       int iconIndex = ConstantData.addFieldsList.indexWhere((item) =>
      //       element['type'].toString().toLowerCase() ==
      //           item['title'].toString().toLowerCase());
      //       // iconIndex==-1?iconIndex=0
      //       print('contact info content list icon index:$iconIndex');
      //       if (element['value'].runtimeType == String) {
      //         widget.contactInfoWidgetList.add({
      //           'type': element['type'],
      //           'controller': TextEditingController(text: element['value']),
      //           'icon': ConstantData.addFieldsList[iconIndex]['icon']
      //         });
      //       }
      //       else {
      //         widget.contactInfoWidgetList.add({
      //           'type': element['type'],
      //           'controller': TextEditingController(
      //               text: element['value']['Address']),
      //           'icon': ConstantData.addFieldsList[iconIndex]['icon']
      //         });
      //       }
      //     });
      //   });
      // }

      // Contact info sections
      if ((result[0]['contact_info'] as List).isNotEmpty) {
        Map<dynamic, dynamic> contactInfoContent =
            result[0]['contact_info'][0]['content'] ?? {};
        print(contactInfoContent);
        setState(() {
          widget.switchFlags[0] =
          result[0]['contact_info'][0]['is_enabled'] == "1" ? true : false;
        });
        if(contactInfoContent == null){
          print("Contact Info is  empty");
        }
        else{
          widget.contactInfoWidgetList.clear();

          contactInfoContent.forEach((key, value) {
            List<dynamic> contactInfoList = [];

            value.entries.map((entry) {
              if (entry.key != 'id') {
                contactInfoList.add({'type': entry.key, 'value': entry.value});
              }
            }).toList();

            contactInfoList.forEach((element) {
              int iconIndex = ConstantData.addFieldsLists.indexWhere((item) =>
              element['type'].toString().toLowerCase() ==
                  item['title'].toString().toLowerCase());

              if (element['type'] == 'Address') {
                // Handle the case where the type is 'Address'
                Map<String, dynamic> addressData = element['value'];
                widget.contactInfoWidgetList.add({
                  'type': 'Address', // You can use a unique identifier for address
                  'controller': TextEditingController(text: addressData['Address']),
                  'icon': ConstantData.addFieldsLists[iconIndex]['icon'],
                  'extra_controller':TextEditingController(text: addressData['Address_url'])
                });
                // Handle other address-related fields if needed
              } else {
                // Handle other types
                if (iconIndex >= 0 && element['value'].toString().runtimeType == String) {
                  widget.contactInfoWidgetList.add({
                    'type': element['type'],
                    'controller': TextEditingController(text: element['value'].toString()),
                    'icon': ConstantData.addFieldsLists[iconIndex]['icon']
                  });
                }
              }
            });
          });
        }

      }


      /*   //business hour section
      if ((result[0]['business_hours'] as List).isNotEmpty) {
        Map<String, dynamic> businessHourContent =
            result[0]['business_hours'][0]['content'] ?? {};
        widget.switchFlags[1] =
            result[0]['business_hours'][0]['is_enabled'] == '1' ? true : false;
        int i = 0;
        businessHourContent.forEach((key, value) {
          widget.businessHourWidgetList[i]['status'] =
              value['days'].toString().toLowerCase() == 'on' ? true : false;
          widget.businessHourWidgetList[i]['start_time'] =
              TextEditingController(text: value['start_time'].toString());
          widget.businessHourWidgetList[i]['end_time'] =
              TextEditingController(text: value['end_time'].toString());
          i++;
        });
      }*/

      //appointment section
      if ((result[0]['appointment'] as List).isNotEmpty) {
        List<dynamic> appointmentContent =
            result[0]['appointment'][0]['content'] ?? [];
        setState(() {
          widget.switchFlags[2] =
          result[0]['appointment'][0]['is_enabled'] == 1 ? true : false;
        });

        widget.appointmentWidgetList.clear();
        appointmentContent.forEach((element) {
          widget.appointmentWidgetList.add({
            'start_hour': TextEditingController(text: element['start']),
            'end_hour': TextEditingController(text: element['end']),
          });
        });
      }

      //services section
      if ((result[0]['services'] as List).isNotEmpty) {
        List<dynamic> servicesContent =
            result[0]['services'][0]['content'] ?? [];
       setState(() {
         widget.switchFlags[3] =
         result[0]['services'][0]['is_enabled'] == 1 ? true : false;
       });

        widget.servicesWidgetList.clear();
        servicesContent.forEach((element) {
          widget.servicesWidgetList.add({
            'imageNetworkPath': element['image'],
            'image_file': File(''),
            'title': TextEditingController(text: element['title']),
            'description': TextEditingController(text: element['description']),
            'purchase_link':
                TextEditingController(text: element['purchase_link']),
          });
        });
      }

      //testimonials

      if ((result[0]['testimonials'] as List).isNotEmpty) {
        List<dynamic> testimonialsContent =
            result[0]['testimonials'][0]['content'] ?? [];
      setState(() {
        widget.switchFlags[4] =
        result[0]['testimonials'][0]['is_enabled'] == 1 ? true : false;
      });

        widget.testimonialsWidgetList.clear();
        testimonialsContent.forEach((element) {
          widget.testimonialsWidgetList.add({
            'imageNetworkPath': element['image'] ?? '',
            'image_file': File(''),
            'rating': TextEditingController(text: element['rating'] ?? '0'),
            'description':
                TextEditingController(text: element['description'] ?? ''),
          });
        });
      }

      print(result[0]['social_link']);
      // social links sectionsr
      if ((result[0]['social_link'] as List).isNotEmpty) {

        print(result[0]['social_link'][0]['content']);
        if (result[0]['social_link'][0]['content'] != []) {
          Map<dynamic, dynamic> socialContent =
              result[0]['social_link'][0]['content'];
        setState(() {
          widget.switchFlags[1] =
          result[0]['social_link'][0]['is_enabled'] == "1" ? true : false;
        });

          print(widget.switchFlags[1]);
          widget.socialLinksWidgetList.clear();
          print(result[0]['social_link'][0]['content']);
          print(socialContent);
          if(socialContent == null){
            print("Social is not empty");
          }
          else{
            socialContent.forEach((key, value) {
              List<dynamic> socialLinkList = [];

              value.entries.map((entry) {

                if (entry.key != 'id') {
                  socialLinkList.add({'type': entry.key, 'value': entry.value});
                }
              }).toList();
              print('social link data list:$socialLinkList');
              socialLinkList.forEach((element) {
                int iconIndex = ConstantData.addsocialList.indexWhere((item) =>
                element['type'].toString().toLowerCase() ==
                    item['title'].toString().toLowerCase());
                print(element['value'].runtimeType);
                if (element['value'].runtimeType == String) {
                  widget.socialLinksWidgetList.add({
                    'type': element['type'],
                    'controller': TextEditingController(text: element['value']),
                    'icon': ConstantData.addsocialList[iconIndex]['icon']
                  });
                } else {
                  widget.socialLinksWidgetList.add({
                    'type': element['type'],
                    'controller':
                    TextEditingController(text: element['value']['Address']),
                    'icon': ConstantData.addsocialList[iconIndex]['icon']
                  });
                }
              });
            });
          }

        }
      }







      // //get multiple field
      // widget.multipleDynamicFieldList.clear();
      // if(data['phones_count']!=null && data['phones_count']!='0'){
      //   for(int i=1;i<=int.parse(data['phones_count']);i++){
      //       widget.multipleDynamicFieldList.add({'type':'Phone','controller':TextEditingController(text:data['phones_$i'] )});
      //   }
      // }
      // if(data['mobiles_count']!=null && data['mobiles_count']!='0'){
      //   for(int i=1;i<=int.parse(data['mobiles_count']);i++){
      //       widget.multipleDynamicFieldList.add({'type':'Mobile','controller':TextEditingController(text:data['mobiles_$i'] )});
      //   }
      // }if(data['emails_count']!=null && data['emails_count']!='0'){
      //   for(int i=1;i<=int.parse(data['emails_count']);i++){
      //       widget.multipleDynamicFieldList.add({'type':'Email','controller':TextEditingController(text:data['emails_$i'] )});
      //   }
      // }if(data['websites_count']!=null && data['websites_count']!='0'){
      //   for(int i=1;i<=int.parse(data['websites_count']);i++){
      //       widget.multipleDynamicFieldList.add({'type':'Website','controller':TextEditingController(text:data['websites_$i'] )});
      //   }
      // }
      //
      // //get multiple fields over
      //
      // if(data['mobile1'].toString().trim()!=""){
      //   widget.mobileNumberGroup.add(TextEditingController(text:data['mobile1']));
      // }
      // if(data['mobile2'].toString().trim()!=""){
      //   widget.mobileNumberGroup.add(TextEditingController(text:data['mobile2']));
      // }
      //
      // if(widget.emailVisibleCounter<1) {
      //   data['email2'] != "" ? widget.emailVisibleCounter++ : print("");
      // }
      // singleCard= data;
      // print("whole data:${data}");
      //
      // print("data['profilename']:${data['profile_name']}");
      // print("global current profile:${globals.current_profile}");
      // print("Single Card Data:$singleCard");
      setState(() {
        visibleBloc = false;
      });
      //
      print("Edit time avtar image:$editTimeAvatarImage");
    }
  }

  coverImageCacheClear() async {
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.removeFile(editTimeCoverImage);
  }

  avatarImageCacheClear() async {
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.removeFile(editTimeAvatarImage);
  }

  @override
  Widget build(BuildContext context) {
    print("dynamic section list Counter: ${dynamicSectionList}");

    // print("Country controller: ${widget.countryController.text}");
    // print("Country controller: ${widget.countryController.text.runtimeType}");
    return visibleBloc == true
        ? BlocBuilder<DataBloc, UsersState>(
            bloc: _dataBloc,
            builder: (context, state) {
              if (state is UsersLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                );
              }
              if (state is UsersLoaded) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => apiResponse(state.responseData));
              }
              if (state is UsersError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Something went Wrong, Lets Try Again..',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            visibleBloc = false;
                          });
                        },
                        child: Text(
                          "Retry",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            })
        : ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your Digital Card',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      widget.businessId != null ? 'Profile' : 'Add Profile',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 10,
                      blurRadius: 5,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    children: [
                      AbsorbPointer(
                        absorbing: widget.textFieldReadOnlyFlag,
                        child: Column(
                          children: [
                            Container(
                              height: 3,
                              width: 30,
                              decoration:
                                  BoxDecoration(color: Color(0xFFeef2fb)),
                              alignment: Alignment.center,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CoverImagePickerWidget(
                                    imageNetworkPath: editTimeCoverImage,
                                    onSelectedImageChanged: (selectedImage) {
                                      selectCoverImage = selectedImage;
                                      globals.selectedCoverImage =
                                          selectedImage;
                                      setState(() {
                                        globals.selectedCoverImage =
                                            selectedImage;
                                        coverImageCacheClear();
                                      });
                                      print(selectedImage);
                                    },
                                    noCache: false,
                                  ),
                                  Positioned(
                                    // alignment: Alignment.center,
                                    //   top:115,
                                    // left: MediaQuery.of(context).size.width/3,
                                    bottom: 10,
                                    child: ImagePickerWidget(
                                      imageNetworkPath: editTimeAvatarImage,
                                      selectedImage:
                                          globals.selectedAvatarImage,
                                      onSelectedImageChanged: (selectedImage) {
                                        print('onselectedImagechanges');
                                        selectedAvatarImage = selectedImage;
                                        globals.selectedAvatarImage =
                                            selectedImage;
                                        setState(() {
                                          avatarImageCacheClear();
                                        });
                                      },
                                      noCache: true,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autofocus: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return fieldValidator.titleValidator(value);
                              },
                              onSaved: (value) {
                                return fieldValidator.titleValidator(value);
                              },
                              controller: widget.titleController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),

                                /// labelText: 'First Name',
                                hintText: widget.editable != true
                                    ? 'Title'
                                    : "Full Name",
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autofocus: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return fieldValidator
                                    .designationValidator(value);
                              },
                              controller: widget.designationController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: 'Full Name',
                                hintText: 'Designation',
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autofocus: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return fieldValidator.subTitleValidator(value);
                              },
                              controller: widget.subTitleController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText:'Designation',
                                hintText: 'Sub title',
                              ),
                            ),
                            /*Padding(padding: const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autofocus: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return fieldValidator.pageUrlValidator(value);
                              },
                              controller: widget.slugController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText:'Designation',
                                hintText: 'Profile url(slug)',
                              ),
                            ),*/
                          /*  Padding(padding: const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autofocus: false,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // validator: (value){
                              //   if(value.isEmpty)
                              //     return 'Company Name cant\'t  be  Empty.';
                              //   return null;
                              //
                              // },
                              controller: widget.descriptionController,
                              minLines: 3,
                              maxLines: 10,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText:'Designation',
                                hintText: 'Description',
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(8)),
                            // TextFormField(
                            //   autofocus: false,
                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //   validator: (value){
                            //     return fieldValidator.businessValidator(value);
                            //   },
                            //   controller: widget.businessController,
                            //   keyboardType: TextInputType.text,
                            //   style: Theme.of(context).textTheme.bodyText1,
                            //   decoration: InputDecoration(
                            //     border: OutlineInputBorder(),
                            //     // labelText:'Designation',
                            //     hintText: 'Business Or Organisation',
                            //   ),
                            // ),
                            // Padding(padding:const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autofocus: false,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // validator: (value){
                              //   return fieldValidator.roleValidator(value);
                              // },
                              controller: widget.metaKeywordsController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText:'Designation',
                                hintText: 'Meta keywords',
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // validator: (value){
                              //   return fieldValidator.websiteValidator(value);
                              // },
                              controller: widget.metaDescriptionController,
                              minLines: 3,
                              maxLines: 10,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: 'Website',
                                hintText: 'Meta description',
                              ),
                            ),*/
                            /*Padding(padding: const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // validator: (value){
                              //   return fieldValidator.addressValidator(value);
                              // },
                              controller: widget.googleAnalyticController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: 'Address',
                                hintText: 'Google analytic',
                              ),
                            ),*/
                            /*Padding(padding: const EdgeInsets.all(8)),
                            TextFormField(
                              readOnly: widget.textFieldReadOnlyFlag,
                              controller: widget.facebookPixelController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Facebook pixel',
                                // prefixIcon:Container(
                                //   padding: EdgeInsets.all(5),
                                //   child: SvgPicture.asset('assets/images/svg/facebook.svg',
                                //     // height: 35,width: 35,fit: BoxFit.contain,
                                //   ),
                                // ),
                              ),
                            ),*/
                            Padding(padding: const EdgeInsets.all(8)),
                            //  TextFormField(
                            //    readOnly: widget.textFieldReadOnlyFlag,
                            //    controller: widget.customJSController,
                            //    keyboardType: TextInputType.text,
                            //    style: Theme.of(context).textTheme.bodyText1,
                            //    minLines: 3,
                            //    maxLines: 10,
                            //    decoration: InputDecoration(
                            //      border: OutlineInputBorder(),
                            //      hintText: 'Custom JS',
                            //    ),
                            //  ),
                            //  Padding(padding:const EdgeInsets.all(8)),
                          ],
                        ),
                      ),
                      for (int i = 0; i < dynamicSectionList.length; i++)
                        ExpandableListTileWidget(
                          title: dynamicSectionList[i]['title'],
                          icon: Icons.credit_card,
                          iconColor: Colors.black,
                          readonlyFlag: widget.textFieldReadOnlyFlag,
                          children: [
                            Row(
                              children: [
                                CupertinoSwitch(
                                    value: widget.switchFlags[i],
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    onChanged: (value) {
                                      setState(() {
                                        dynamicSectionList[i]['switch_flag'] =
                                            value;
                                        widget.switchFlags[i] = value;
                                        print(widget.switchFlags[i]);
                                      });
                                    }),
                                InkWell(
                                  onTap: () {

                                   /* setState(() {
                                      widget.switchFlags[i] =
                                          !dynamicSectionList[i]['switch_flag'];
                                      dynamicSectionList[i]['switch_flag'] =
                                      !dynamicSectionList[i]['switch_flag'];
                                    });*/
                                  },
                                  child: Text(
                                    dynamicSectionList[i]['switch_title'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(fontSize: 14),
                                  ),
                                ),
                                Visibility(
                                  visible: dynamicSectionList[i]
                                      ['show_add_button'],
                                  child: Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: dynamicSectionList[i]
                                            ['add_click'],
                                        // icon: Icon(Icons.add),
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Visibility(
                              // visible:dynamicSectionList[i]['switch_flag'],
                              visible: widget.switchFlags[i],
                              child: dynamicSectionList[i]['dynamic_widget'](
                                  dynamicSectionList[i]['title']),
                            ),
                            // getContactInfoWidgetList()
                            // Column(
                            //   children: [
                            //     for(int i=0;i<widget.contactInfoWidgetList.length;i++)
                            //       LeadingIconTextFieldWidget(
                            //         controller: widget.contactInfoWidgetList[i]['controller'],
                            //         prefixIcon:widget.contactInfoWidgetList[i]['icon'],
                            //         index: i,
                            //         keyBoardType: TextInputType.text,
                            //         suffixIcon:Icon(Icons.remove_circle),
                            //         suffixIconOnTap: ()=>removeContactInfoField(i),
                            //         textFieldReadOnlyFlag:widget.textFieldReadOnlyFlag,
                            //       )
                            //   ],
                            // )
                          ],
                        ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Text('Add more contact information',style: Theme.of(context).textTheme.headline2.copyWith(
                      //       fontSize: 16
                      //     ),),
                      //     InkWell(
                      //        onTap: addMultipleDynamicField,
                      //        child: Icon(Icons.add_circle,color: Theme.of(context).inputDecorationTheme.labelStyle.color)
                      //     ),
                      //   ],
                      // ),
                      // Padding(padding:const EdgeInsets.all(8)),
                      // for(int i=0;i<widget.multipleDynamicFieldList.length;i++)
                      //   Column(
                      //     children: [
                      //       LeadingDropDownMultipleFields(
                      //         index:i,
                      //         leadingDropDownItems:['Select Type','Phone','Mobile','Email','Website'],
                      //         textFieldReadOnlyFlag: widget.textFieldReadOnlyFlag ,
                      //         controller: widget.multipleDynamicFieldList[i]['controller'],
                      //         selectedDropDownValue:widget.multipleDynamicFieldList[i]['type'],
                      //         keyBoardType:TextInputType.text,
                      //         // textFieldLabel:'Mobile Number',
                      //         // textFieldHint:'Email Address',
                      //         suffixIcon: Icon(Icons.remove_circle),
                      //         validator: (value){
                      //           if(widget.multipleDynamicFieldList[i]['type']=='Select Type')
                      //             return 'Please select field type';
                      //           if(widget.multipleDynamicFieldList[i]['type']=='Phone')
                      //             return fieldValidator.phoneNumberValidator(value);
                      //           if(widget.multipleDynamicFieldList[i]['type']=='Mobile')
                      //             return fieldValidator.mobileNumberValidator(value);
                      //           if(widget.multipleDynamicFieldList[i]['type']=='Email')
                      //               return fieldValidator.emailValidator(value);
                      //           if(widget.multipleDynamicFieldList[i]['type']=='Website')
                      //             return fieldValidator.websiteValidator(value);
                      //         },
                      //         suffixIconOnTap:()=>removeMultipleDynamicField(i),
                      //         onTextFieldTypeChange:onTextFieldTypeChange
                      //       ),
                      //       Padding(padding:const EdgeInsets.all(8)),
                      //     ],
                      //   ),
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
