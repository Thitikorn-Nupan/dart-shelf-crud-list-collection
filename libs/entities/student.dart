class Student {

  int _sid;
  String _fullname;
  int _age;
  List<String> _skills;

  Student(this._sid, this._fullname, this._age, this._skills);

  List<String> get skills => _skills;

  int get sid => _sid;

  set sid(int value) {
    _sid = value;
  }

  set skills(List<String> value) {
    _skills = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  String get fullname => _fullname;

  set fullname(String value) {
    _fullname = value;
  }

  /**
    ****************************************************************************
    In dart you have to know about response object to be json
    it can't response
    This package (import 'dart:convert') save data by JSON encoded,
    and The jsonEncode can't convert the object.
    We need to create the function in the class of an object for JSON conversion.
    ****************************************************************************
  */
  Map<String, dynamic> toJson() {
    return {
      'sid': _sid,
      'fullname': _fullname,
      'age': _age,
      'skills': _skills,
    };
  }

  @override
  String toString() {
    return 'Student{_sid: $_sid, _fullname: $_fullname, _age: $_age, _skills: $_skills}';
  }
}
