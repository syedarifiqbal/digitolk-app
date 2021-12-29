class User {
  late int _id;
  late String _name;
  late String _email;
  late String _password;
  late bool _isAdmin;
  late String? _createdAt;
  late String? _updatedAt;
  late String? _token;

  User(
      {required int id,
      required String name,
      required String email,
      required String password,
      required bool isAdmin,
      required String createdAt,
      required String updatedAt,
      required String token}) {
    this._id = id;
    this._name = name;
    this._email = email;
    this._password = password;
    this._isAdmin = isAdmin;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._token = token;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get email => _email;
  set email(String email) => _email = email;
  String get password => _password;
  set password(String password) => _password = password;
  bool get isAdmin => _isAdmin;
  set isAdmin(bool isAdmin) => _isAdmin = isAdmin;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get token => _token;
  set token(String? token) => _token = token;

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];

    if (json['user'] != null) {
      json = json['user'];
    }

    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _isAdmin = json['is_admin'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _token = token;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['is_trader'] = this._isAdmin;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
