import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:lineage2_servers_status/models/server.dart';
import 'package:lineage2_servers_status/utils/crawler.dart' as util;

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key, this.server}) : super(key: key);

  final Server server;

  @override
  _DetailScreen createState() => _DetailScreen(server: server);
}

class _DetailScreen extends State<DetailScreen> {
  _DetailScreen({this.server});

  Server server;
  Timer _timerDetail;
  List<double> _data;
  AlarmStatus _alarm = AlarmStatus.enabled;
  final AudioCache _audioCache = AudioCache();

  @override
  void initState() {
    _data = [server.playersCount - 1.0, server.playersCount + 0.0];
    if (server.playersCount > 0) {
      _alarm = AlarmStatus.disabled;
    }
    super.initState();

    const fiveSeconds = const Duration(seconds: 5);
    _timerDetail = Timer.periodic(
      fiveSeconds,
      (Timer t) => _refresh(),
    );
  }

  @override
  void dispose() {
    _timerDetail.cancel();
    super.dispose();
  }

  Future _refresh() {
    return _fetchData().then((_server) {
      setState(() => server = _server);

      final List<double> dataResult = List.from(_data)
        ..add(_server.playersCount + 0.0);
      setState(() => _data = dataResult);

      if(_alarm != AlarmStatus.playing){
        if(_alarm != AlarmStatus.activated){
          if (_server.playersCount > 0) {
            setState(() => _alarm = AlarmStatus.disabled);
          } else {
            setState(() => _alarm = AlarmStatus.enabled);
          }
        } else {
          if (_server.playersCount > 0) {
            setState(() => _alarm = AlarmStatus.playing);
            _audioCache.play('lineage_2_quest.mp3');
          }
        }
      } else {
        _audioCache.play('lineage_2_quest.mp3');
      }
    });
  }

  void alarmOnPressed() {
    print('alarm activated');
    setState(() => _alarm = AlarmStatus.activated);
  }

  void alarmRunningOnPressed() {
    print('alarm Stopped');
    setState(() => _alarm = AlarmStatus.disabled);
  }

  Future<Server> _fetchData({String serverNameRaw}) async {
    final response = await http.get(util.urlL2LabyFr);
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
          child: Divider(color: Colors.white),
        ),
        Text(
          "${server.country} ${server.type}",
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/${server.type.toLowerCase()}_paper.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              _timerDetail.cancel();
              Navigator.pop(context);
            },
            child: Icon(
              (Platform.isIOS) ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.white,
            ),
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
          onPressed: alarmOnPressed, //() => {},
          color: Color.fromRGBO(232, 53, 83, 1.0),
          child: Text("SET ALARM WHEN ONLINE",
              style: TextStyle(color: Colors.white)),
        ));

    final alarmRunningButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: alarmRunningOnPressed,
          color: Color.fromRGBO(232, 53, 83, 1.0),
          child: Text("CANCEL ALARM",
              style: TextStyle(color: Colors.white)),
        ));

    final alarmPlayingButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: alarmRunningOnPressed,
          color: Color.fromRGBO(232, 53, 83, 1.0),
          child: Text("STOP ALARM",
              style: TextStyle(color: Colors.white)),
        ));

    final sparklineContent = Sparkline(
      data: _data,
      lineGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.redAccent[400], Colors.amber],
      ),
      fillMode: FillMode.none,
      pointsMode: PointsMode.last,
      pointSize: 5.0,
      pointColor: Colors.yellow,
    );

    List<Widget> showBottomContent() {
      switch (_alarm) {
        case AlarmStatus.enabled:
          return <Widget>[
            SizedBox(height: 10.0),
            bottomContentText,
            alarmButton,
            Text('If you enable the alarm, when the server returns to the online state, the adventure call will sound.', textAlign: TextAlign.center,),
          ];
          break;
        case AlarmStatus.activated:
          return <Widget>[
            SizedBox(height: 10.0),
            CircularProgressIndicator(),
            alarmRunningButton,
            Text('...wait for it...', textAlign: TextAlign.center,),
          ];
          break;
        case AlarmStatus.playing:
          return <Widget>[
            sparklineContent,
            SizedBox(height: 10.0),
            bottomContentText,
            alarmPlayingButton,
            Text('Tap to stop the alarm', textAlign: TextAlign.center,),
          ];
          break;
        case AlarmStatus.disabled:
        default:
          return <Widget>[
            sparklineContent,
            SizedBox(height: 10.0),
            bottomContentText
          ];
          break;
      }
    }

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Center(
        child: Column(
          children: showBottomContent(),
        ),
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

enum AlarmStatus {
  disabled, // invisible
  enabled,  // visible
  activated,
  playing
}
