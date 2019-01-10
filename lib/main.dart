import 'package:flutter/material.dart';
import 'package:lineage2_servers_status/listPage.dart';

void main() => runApp(new L2ssApp());

class L2ssApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Lineage 2 Servers Status',
      theme: new ThemeData(primaryColor: Color.fromRGBO(16, 10, 6, 1.0)),
      home: new ListPage(title: 'Lineage 2 Servers Status'),
    );
  }
}
