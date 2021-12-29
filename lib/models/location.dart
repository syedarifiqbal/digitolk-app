class Location {
  late int _id;
  late String _location;
  late String _lat;
  late String _lng;
  late String? _ownerId;
  late String? _date;
  late String? _createdAt;
  late String? _updatedAt;
  late String? _time;

  Location({
    required int id,
    required String location,
    required String lat,
    required String lng,
    required String ownerId,
    required String date,
    required String createdAt,
    required String updatedAt,
    required String time,
  }) {
    this._id = id;
    this._location = location;
    this._lat = lat;
    this._lng = lng;
    this._ownerId = ownerId;
    this._date = date;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._time = time;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get location => _location;
  set location(String location) => _location = location;
  String get lat => _lat;
  set lat(String lat) => _lat = lat;
  String get lng => _lng;
  set lng(String lng) => _lng = lng;
  String? get ownerId => _ownerId;
  set ownerId(String? ownerId) => _ownerId = ownerId;
  String? get date => _date;
  set date(String? date) => _date = date;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get time => _time;
  set time(String? time) => _time = time;

  Location.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _location = json['location'];
    _lat = json['lat'];
    _lng = json['lng'];
    _ownerId = json['owner_id'];
    _date = json['due_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['location'] = this._location;
    data['lat'] = this._lat;
    data['lng'] = this._lng;
    data['owner_id'] = this._ownerId;
    data['due_at'] = this._date;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['_time'] = this._time;
    return data;
  }
}
