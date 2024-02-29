import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class WriteScreenTopPart extends StatefulWidget {
  final dataSize;

  WriteScreenTopPart({this.dataSize});
  @override
  _WriteScreenTopPartState createState() => _WriteScreenTopPartState();
}

class _WriteScreenTopPartState extends State<WriteScreenTopPart> {
  var _tag;
  String tagSize = "0";

  Future<void> tagPoll() async {
    _tag = await FlutterNfcKit.poll(
        timeout: Duration(minutes: 30),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag");
    // var _result = await FlutterNfcKit.transceive(Duration(minutes:30));
    if (_tag != null) {
      var size =
          "ID: ${_tag?.id}\nStandard: ${_tag?.standard}\nType: ${_tag?.type}\nATQA: ${_tag?.atqa}\nSAK: ${_tag?.sak}\nHistorical Bytes: ${_tag?.historicalBytes}\nProtocol Info: ${_tag?.protocolInfo}\nApplication Data: ${_tag?.applicationData}\nHigher Layer Response: ${_tag?.hiLayerResponse}\nManufacturer: ${_tag?.manufacturer}\nSystem Code: ${_tag?.systemCode}\nDSF ID: ${_tag?.dsfId}\nNDEF Available: ${_tag?.ndefAvailable}\nNDEF Type: ${_tag?.ndefType}\nNDEF Writable: ${_tag?.ndefWritable}\nNDEF Can Make Read Only: ${_tag?.ndefCanMakeReadOnly}\nNDEF Capacity: ${_tag?.ndefCapacity}\n'),";
      print("Tag size: $size");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("NFC tag Detected"),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() {
        tagSize = _tag?.ndefCapacity.toString();
      });
      tagPoll();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) tagPoll();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height:constraints.maxHeight*0.1,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Existing Profiles',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Write', style: Theme.of(context).textTheme.headline2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Data Size:',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          Text('${widget.dataSize} Bytes',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Total available size:',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          Text('$tagSize Bytes',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontSize: 12)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 20, bottom: 10),
          child: Text(
            'Digital Business Card',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
