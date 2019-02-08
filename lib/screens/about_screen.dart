import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final makeBody = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(children: [
              SizedBox(width: 30),
              Text(
                'This app has open source.',
                style: TextStyle(color: Colors.amberAccent),
              ),
              Text(
                'Developed by:',
                style: TextStyle(color: Colors.amberAccent),
              ),
              SizedBox(width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/gabriel_santos.jpeg'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Gabriel Santos',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/github_logo.png'),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    child: Text('/Gabriel-Araujo/lineage2_servers_status',
                        style: TextStyle(color: Colors.amberAccent[100])),
                    onTap: () => url_launcher.launch(
                        'https://github.com/Gabriel-Araujo/lineage2_servers_status'),
                  ),
                ],
              ),
              Text(
                'All data displayed has a source on the website:',
                style: TextStyle(color: Colors.white),
              ),
              InkWell(
                child: Text('http://l2.laby.fr/status/',
                    style: TextStyle(color: Colors.amberAccent[100])),
                onTap: () => url_launcher.launch('http://l2.laby.fr/status/'),
              ),
              SizedBox(height: 10.0),
              Divider(color: Colors.amber),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.all(30),
                child: Image.asset('assets/l2_logo.png'),
              ),
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
              SizedBox(height: 10.0),
              Divider(color: Colors.amber),
              SizedBox(height: 10.0),
              Text(
                'This app was developed using:',
                style: TextStyle(color: Colors.amberAccent),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.fromLTRB(60, 30, 60, 20),
                child: Image.asset('assets/flutter_logo.png'),
              ),
              InkWell(
                child: Text('https://github.com/flutter/flutter',
                    style: TextStyle(color: Colors.amberAccent[100])),
                onTap: () =>
                    url_launcher.launch('https://github.com/flutter/flutter'),
              ),
              InkWell(
                child: Text('https://github.com/xqwzts/flutter_sparkline',
                    style: TextStyle(color: Colors.amberAccent[100])),
                onTap: () => url_launcher
                    .launch('https://github.com/xqwzts/flutter_sparkline'),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.fromLTRB(60, 30, 60, 20),
                child: Image.asset('assets/dart_logo.png'),
              ),
              InkWell(
                child: Text('https://github.com/dart-lang',
                    style: TextStyle(color: Colors.amberAccent[100])),
                onTap: () =>
                    url_launcher.launch('https://github.com/dart-lang'),
              ),
              SizedBox(height: 10.0),
              Divider(color: Colors.amber),
              SizedBox(height: 10.0),
              Text(
                'Thank you for using this app!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(width: 30)
            ]),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(16, 10, 6, 1),
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Colors.black,
      ),
      body: makeBody,
    );
  }
}
