import 'package:flutter/material.dart';

class ReadWriteCard extends StatelessWidget {
  final BoxConstraints constraints;
  final imagePath;
  final textOnCard;
  final cardTapHandler;
  final readCardHandler;
  final QRCodeScanner;
  const ReadWriteCard(
      {Key key,
      this.constraints,
      this.imagePath,
      this.textOnCard,
      this.cardTapHandler,
      this.readCardHandler,
      this.QRCodeScanner})
      : super(key: key);

  Future readCardTap(BuildContext ctx) {
    print('show dialog called');
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: ctx,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Container(
                height: 400,
                width: 350,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child:
                                    Icon(Icons.close, color: Colors.indigo)))),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/tap_and_hold.png',
                          height: 200,
                          width: 200,
                        ),
                        Text(
                          'Tap & Hold\nNFC Card',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: readCardHandler,
                        child: Text('Read',
                            style: Theme.of(context).textTheme.headline1),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'OR',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 10, color: Color(0xFF006ade)),
                    ),
                    TextButton(
                        onPressed: () => QRCodeScanner(context),
                        child: Text('Scan QR code',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14,
                                      color: Color(0xFF006ade),
                                    )))
                  ],
                ),
              ),
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap:
            textOnCard == 'Read' ? () => readCardTap(context) : cardTapHandler,
        splashColor: Colors.blueGrey,
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Container(
              height: 120,
              width: constraints.maxWidth * 0.45,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Positioned(
                top: 60,
                left: 35,
                // bottom:(constraints.maxHeight*0.45)*0.25,
                child: Text(
                  textOnCard,
                  style: Theme.of(context).textTheme.headline4,
                ))
          ],
        ));
  }
}
