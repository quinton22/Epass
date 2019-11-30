import 'package:flutter/material.dart';

class Account {
  int id;
  String site;
  String login;

  Account({
    @required this.site,
    @required this.login,
  });

  // TODO: convert to and from stored data
  Account.fromMap(Map<String, dynamic> map) {
    this.id = map["id"] as int;
    this.site = map["site"];
    this.login = map["login"];
  }

  Map<String, dynamic> asMap() {
    return {
      'id': id,
      'site': site,
      'login': login,
    };
  }
}
