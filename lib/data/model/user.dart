class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String imageURL;
  final String token;
  final List<String> roles;

  User(this.id, this.name, this.username, this.email, this.imageURL, this.token,
      this.roles);

  User.fromJson(Map<String, dynamic> json)
      : this(
          json["id"],
          json["nome"],
          json["login"],
          json["email"],
          json["urlFoto"],
          json["token"],
          json["roles"]?.map<String>((role) => role.toString())?.toList() ?? List<String>(),
        );

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username, email: $email, imageURL: $imageURL, token: $token, roles: $roles}';
  }
}
