import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lupita_ft/pages/detail_page.dart';

class NotificationItem {
  NotificationItem({this.itemId});
  final String itemId;

  StreamController<NotificationItem> _controller = StreamController<NotificationItem>.broadcast();
  Stream<NotificationItem> get onChanged => _controller.stream;

  String _matchteam;
  String get matchteam => _matchteam;

  set matchteam(String value) {
    _matchteam = value;
    _controller.add(this);
  }

  String _score;
  String get score => _score;
  set score(String value) {
    _score = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
          () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(itemId),
      ),
    );
  }
}