import 'package:flutter/material.dart';

class Account {
  int id;
  String site;
  String login;
  int lastChanged;

  Account({
    @required this.site,
    @required this.login,
  }) : lastChanged = 0;

  // TODO: convert to and from stored data
  Account.fromMap(Map<String, dynamic> map) {
    this.id = map["id"] as int;
    this.site = map["site"];
    this.login = map["login"];
    this.lastChanged = map["lastChanged"];
  }

  Map<String, dynamic> asMap() {
    return {
      'id': id,
      'site': site,
      'login': login,
      'lastChanged': lastChanged,
    };
  }
}
