class AccountModel {
  String site;
  String login;
  String password;
  List<String> authTypes; // TODO: maybe make each auth type a class

  AccountModel({
    this.site,
    this.login,
    this.password,
    this.authTypes,
  });

  // TODO: convert to and from stored data
}
