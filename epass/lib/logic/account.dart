import 'package:epass/logic/authType.dart';
import 'package:flutter/material.dart';

class Account {
  int id;
  String site;
  String login;
  List<AuthType> authTypes; // TODO: maybe make each auth type a class

  Account({
    @required this.site,
    @required this.login,
    @required this.authTypes,
  });

  // TODO: convert to and from stored data
  Account.fromMap(Map<String, dynamic> map) {
    this.id = map["id"] as int;
    this.site = map["site"];
    this.login = map["login"];
    this.authTypes = (map["authTypes"] as String)
        .split(",")
        .map((s) => AuthType.values.firstWhere(
            (e) => e.toString() == 'AuthType.$s',
            orElse: () => AuthType.none))
        .toList();
  }

  Map<String, dynamic> asMap() {
    return {
      'id': id,
      'site': site,
      'login': login,
      'authTypes': authTypes
          .map((authType) => authType.toString().split('.')[1])
          .join(','),
    };
  }
}
