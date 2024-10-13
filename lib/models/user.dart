class User {
  final String name;
  final String email;
  final String password;
  final String telephone;
  List<String> invoicesIds;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.telephone,
    this.invoicesIds = const [],
  });
}
