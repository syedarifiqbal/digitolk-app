class Task {
  late int _id;
  late String _summary;
  late String _description;
  late bool _completed;
  late String _notified;
  late String _ownerId;
  late String _dueAt;
  late String _createdAt;
  late String _updatedAt;
  late Null _nextNotificationAt;

  Task(
      {required int id,
      required String summary,
      required String description,
      required bool completed,
      required String notified,
      required String ownerId,
      required String dueAt,
      required String createdAt,
      required String updatedAt,
      Null nextNotificationAt}) {
    this._id = id;
    this._summary = summary;
    this._description = description;
    this._completed = completed;
    this._notified = notified;
    this._ownerId = ownerId;
    this._dueAt = dueAt;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._nextNotificationAt = nextNotificationAt;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get summary => _summary;
  set summary(String summary) => _summary = summary;
  String get description => _description;
  set description(String description) => _description = description;
  bool get completed => _completed;
  set completed(bool completed) => _completed = completed;
  String get notified => _notified;
  set notified(String notified) => _notified = notified;
  String get ownerId => _ownerId;
  set ownerId(String ownerId) => _ownerId = ownerId;
  String get dueAt => _dueAt;
  set dueAt(String dueAt) => _dueAt = dueAt;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  Null get nextNotificationAt => _nextNotificationAt;
  set nextNotificationAt(Null nextNotificationAt) =>
      _nextNotificationAt = nextNotificationAt;

  Task.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _summary = json['summary'];
    _description = json['description'];
    _completed = json['completed'];
    _notified = json['notified'].toString();
    _ownerId = json['owner_id'].toString();
    _dueAt = json['due_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _nextNotificationAt = json['next_notification_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['summary'] = this._summary;
    data['description'] = this._description;
    data['completed'] = this._completed;
    data['notified'] = this._notified;
    data['owner_id'] = this._ownerId;
    data['due_at'] = this._dueAt;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['next_notification_at'] = this._nextNotificationAt;
    return data;
  }
}
