import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final makeBody = new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Column(children: [
              Text(
                '"Lineage 2" is a registered trademark of',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'NCSOFT Corporation.',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'All rights reserved.',
                style: TextStyle(color: Colors.white),
              ),
              Divider(color: Colors.white),
              Text(
                'All data displayed has a source on the website:',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'http://l2.laby.fr/status/',
                style: TextStyle(color: Colors.white),
              ),
              Divider(color: Colors.white),
              Text(
                'This app was developed using:',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Flutter',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'https://github.com/flutter/flutter',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'https://github.com/xqwzts/flutter_sparkline',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Dart',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'https://github.com/dart-lang',
                style: TextStyle(color: Colors.white),
              ),
              Divider(color: Colors.white),
              Text(
                'This app has open source:',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Developed by:',
                style: TextStyle(color: Colors.white),
              ),
              CircleAvatar(
                backgroundImage: AssetImage('assets/gabriel_santos.jpeg'),
              ),
              Divider(color: Colors.white),
              Text(
                'Thank you for using this app!',
                style: TextStyle(color: Colors.white),
              ),
            ]),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        title: Text(
          "About",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: makeBody,
    );
  }
}
