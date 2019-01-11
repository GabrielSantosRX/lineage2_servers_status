import 'package:flutter/material.dart';
import 'package:lineage2_servers_status/detailPage.dart';
import 'package:lineage2_servers_status/aboutPage.dart';
import 'package:lineage2_servers_status/models/server.dart';
import 'package:lineage2_servers_status/dataUtil.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:async';

class ListPage extends StatefulWidget {
  final String title;

  ListPage({Key key, this.title}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Timer _timer;
  List<Server> _servers;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _servers = new List<Server>();
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

    const fiveSeconds = const Duration(seconds: 5);
    _timer = new Timer.periodic(
      fiveSeconds,
      (Timer t) => _refresh(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      title: Text(
        "Lineage 2 Servers Status",
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );

    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.import_export, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              },
            ),
            IconButton(
              icon: Icon(Icons.copyright, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    ListTile makeListTile(Server server) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24),
              ),
            ),
            child: server.getStatusIcon(),
          ),
          title: Text(
            server.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: LinearProgressIndicator(
                    backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                    value: server.getTrafficIndicator(),
                    valueColor:
                        AlwaysStoppedAnimation(server.getTrafficColor()),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(server.country + " " + server.type,
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
          trailing: Column(
            children: <Widget>[
              Text(server.playersCount.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text(server.getTrafficStatus(),
                  style: TextStyle(color: server.getTrafficColor())),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new DetailPage(server: server),
              ),
            );
          },
        );

    Card makeCard(Server server) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(16, 10, 6, .9)),
            child: makeListTile(server),
          ),
        );

    final makeBody = Container(
        child: (_servers.length > 0)
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _servers.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(_servers[index]);
                },
              )
            : Center(
                child: CircularProgressIndicator(backgroundColor: Colors.red),
              ));

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: topAppBar,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: makeBody,
      ),
      bottomNavigationBar: makeBottom,
    );
  }

  Future<Null> _refresh() {
    if (Navigator.of(context).canPop()) return null;

    return _fetchData().then((serversResult) {
      setState(() => _servers = serversResult);
    });
  }

  Future<List<Server>> _fetchData() async {
    final response = await http.get(util.URL_L2_LABY_FR);
    if (response.statusCode == 200) {
      return util.refreshDataServers(response.body);
    }
    return null;
  }
}
