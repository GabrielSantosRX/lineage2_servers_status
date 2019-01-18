import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lineage2_servers_status/screens/list_screen.dart';

void main() => runApp(L2ssApp());

class L2ssApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lineage 2 Servers Status',
      theme: ThemeData(primaryColor: Color.fromRGBO(0, 0, 0, 1.0)),
      home: ListScreen(title: 'Lineage 2 Servers Status'),
    );
  }
}
