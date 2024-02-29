import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18,
            )),
        title: Text(
          'About Us',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 23, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WHO ARE WE?',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            Text('We are 360',
                style: Theme.of(context).textTheme.headline2.copyWith(
                      fontSize: 16,
                    )),
            SizedBox(height: 15),
            Text(
              '360 Inc. began as an idea founded in our minds in 2010, coming into '
              'fruition in 2015. We are a group of nine young, creative and quick minds'
              ' with similar interest in design and everything that goes with it. Together,'
              ' we formed an enterprise that specializes in the full spectrum of branding and marketing consultancy'
              ' with allied services. Now, 360 inc is a full service creative technology agency.',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
