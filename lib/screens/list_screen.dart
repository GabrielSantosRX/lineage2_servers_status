import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lineage2_servers_status/models/server.dart';
import 'package:lineage2_servers_status/screens/about_screen.dart';
import 'package:lineage2_servers_status/screens/detail_screen.dart';
import 'package:lineage2_servers_status/utils/crawler.dart' as util;

class ListScreen extends StatefulWidget {
  const ListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Timer _timer;
  List<Server> _servers;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _servers = List<Server>();
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

    const fiveSeconds = const Duration(seconds: 5);
    _timer = Timer.periodic(
      fiveSeconds,
      (Timer t) => _refresh(),
    );
  }

  Future _refresh() {
    if (Navigator.of(context).canPop()) return null;

    return _fetchData().then((serversResult) {
      setState(() => _servers = serversResult);
    });
  }

  Future<List<Server>> _fetchData() async {
    final response = await http.get(util.urlL2LabyFr);
    if (response.statusCode == 200) {
      return util.refreshDataServers(response.body);
    }
    return null;
  }

  void showAboutScreen(String _) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutScreen(),
      ),
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
        //elevation: 0.1,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Lineage 2 Servers Status"),
        leading: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 10, 10),
            child: Image.asset('assets/icon_appbar.png', fit: BoxFit.cover)),
        actions: <Widget>[
          PopupMenuButton<String>(
            key: Key('AboutButton'),
            onSelected: showAboutScreen,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  const PopupMenuItem<String>(
                      value: 'About', child: Text('About')),
                ],
          ),
        ]);

    ListTile makeListTile(Server server) => ListTile(
          key: Key('ListTileServers'),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 1.0, color: Colors.white24),
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
                  child: Text("${server.country} ${server.type}",
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
                builder: (context) => DetailScreen(server: server),
              ),
            );
          },
        );

    Card makeCard(Server server) => Card(
          elevation: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(16, 10, 6, .9)),
            child: makeListTile(server),
          ),
        );

    final makeBody = Container(
        child: (_servers.isNotEmpty)
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _servers.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(_servers[index]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: topAppBar,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: SafeArea(child: makeBody),
      ),
    );
  }
}
