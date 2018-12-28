import 'dart:ui' show Color;
import 'package:flutter/material.dart' show Colors, Icons;
import 'package:flutter/widgets.dart' show Icon;

class Server {
  String name;
  String nameRaw;
  String type;
  String country;
  int playersCount;

  Server(this.name, this.nameRaw, this.type, this.country,
      [this.playersCount = 0]);

  Icon getStatusIcon() {
    return (this.playersCount <= 0)
        ? Icon(Icons.cancel, color: Color.fromRGBO(232, 53, 83, 1.0))
        : Icon(Icons.beenhere, color: Colors.green[400]);
  }

  double getTrafficIndicator() {
    return (((this.playersCount * 100.00) / 6000.00) / 100.00);
  }

  String getTrafficStatus() {
    if (playersCount <= 0)
      return "Offline";
    else if (playersCount <= 5)
      return "Starting...";
    else if (playersCount >= 5000)
      return "Heavy";
    else if (playersCount >= 2500)
      return "Normal";
    else
      return "Light";
  }

  Color getTrafficColor() {
    if (playersCount <= 0)
      return Colors.grey[400];
    else if (playersCount <= 5)
      return Colors.white;
    else if (playersCount >= 5000)
      return Color.fromRGBO(232, 53, 83, 1.0); // #E83553
    else if (playersCount >= 2500)
      return Colors.amber;
    else
      return Colors.cyan;
  }

  @override
  String toString() {
    return this.name + ": " + this.playersCount.toString();
  }
}
