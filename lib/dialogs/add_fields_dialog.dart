import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/constant_data.dart';
import '../textfield_validator.dart';

class AddFieldsDialogWidget extends StatefulWidget {
  const AddFieldsDialogWidget({Key key, this.message, @required this.forsicial})
      : super(key: key);

  final String message;
  final bool forsicial;
  @override
  State<AddFieldsDialogWidget> createState() => _AddFieldsDialogWidgetState();
}

class _AddFieldsDialogWidgetState extends State<AddFieldsDialogWidget> {
  final formKey = GlobalKey<FormState>();
  final FieldValidator fieldValidator = FieldValidator();
  final emailController = TextEditingController();
  bool visibleBloc = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add Field',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              icon: Icon(Icons.close))
        ],
      ),
      insetPadding: const EdgeInsets.only(left: 20, right: 20),
      content: Container(
        width: double.infinity,
        child: widget.forsicial == false
            ? Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 0; i < ConstantData.addFieldsList.length; i++)
                    InkWell(
                      onTap: () => Navigator.of(context).pop(i),
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: IntrinsicWidth(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  ConstantData.addFieldsList[i]['icon'],
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  ConstantData.addFieldsList[i]['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                          // fontSize: 14
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              )
            : Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 0; i < ConstantData.addsocialList.length; i++)
                    InkWell(
                      onTap: () => Navigator.of(context).pop(i),
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: IntrinsicWidth(
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  ConstantData.addsocialList[i]['icon'],
                                  height: 40,
                                  width: 40,
                                ),
                                Text(
                                  ConstantData.addsocialList[i]['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                          // fontSize: 14
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
