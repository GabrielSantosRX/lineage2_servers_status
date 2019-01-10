import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:lineage2_servers_status/models/server.dart';
import 'package:lineage2_servers_status/dataUtil.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:async';

class DetailPage extends StatefulWidget {
  final Server server;

  DetailPage({Key key, this.server}) : super(key: key);

  @override
  _DetailPage createState() => _DetailPage(server: server);
}

class _DetailPage extends State<DetailPage> {
  Server server;
  Timer _timerDetail;
  List<double> _data;

  _DetailPage({this.server});

  @override
  void initState() {
    _data = [this.server.playersCount - 1.0, this.server.playersCount + 0.0];
    super.initState();

    const fiveSeconds = const Duration(seconds: 5);
    _timerDetail = new Timer.periodic(fiveSeconds, (Timer t) => _refresh());
  }

  @override
  void dispose() {
    _timerDetail.cancel();
    super.dispose();
  }

  Future<Null> _refresh() {
    return _fetchData().then((_server) {
      setState(() => server = _server);
      List<double> dataResult = new List.from(_data)..add(_server.playersCount + 0.0);
      setState(() => _data = dataResult);
    });
  }

  Future<Server> _fetchData({String serverNameRaw}) async {
    final response = await http.get(util.URL_L2_LABY_FR);
    if (response.statusCode == 200) {
      return util.refreshDataServer(response.body, server.nameRaw);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: server.getTrafficIndicator(),
            valueColor: AlwaysStoppedAnimation(server.getTrafficColor())),
      ),
    );

    final topContentText = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          server.name,
          style: TextStyle(color: Colors.white, fontSize: 40.0),
        ),
        Container(
          width: 156.0,
          child: new Divider(color: Colors.white),
        ),
        Text(
          server.country + " " + server.type,
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(server.getTrafficStatus(),
                        style: TextStyle(color: server.getTrafficColor())))),
            Expanded(flex: 1, child: server.getStatusIcon())
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(
                    "assets/" + server.type.toLowerCase() + "_paper.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(16, 10, 6, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            server.playersCount.toString(),
            style: TextStyle(fontSize: 54.0, color: Colors.white),
          ),
          Text(
            "PLAYERS",
            style: TextStyle(fontSize: 14.0, color: Colors.white),
          )
        ]);

    final alarmButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(232, 53, 83, 1.0),
          child: Text("SET ALARM WHEN ONLINE",
              style: TextStyle(color: Colors.white)),
        ));

    final sparklineContent = new Sparkline(
      data: _data,
      lineGradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.redAccent[400], Colors.amber],
      ),
      fillMode: FillMode.none,
      pointsMode: PointsMode.last,
      pointSize: 5.0,
      pointColor: Colors.yellow,
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      padding:
          EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Center(
        child: Column(
            children: (server.getTrafficStatus() == "Offline")
                ? <Widget>[
                    SizedBox(height: 10.0),
                    bottomContentText,
                    alarmButton
                  ]
                : <Widget>[
                    sparklineContent,
                    SizedBox(height: 10.0),
                    bottomContentText
                  ]),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }
}
