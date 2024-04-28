class Address {

  int _aid;
  String _country;
  String _city;
  int _zipcode;
  String _detail;

  Address(this._aid, this. _country, this._city, this._zipcode, this._detail);

  String get detail => _detail;

  set detail(String value) {
    _detail = value;
  }

  int get zipcode => _zipcode;

  set zipcode(int value) {
    _zipcode = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get country =>  _country;

  set country(String value) {
     _country = value;
  }

  int get aid => _aid;

  set aid(int value) {
    _aid = value;
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
  Map<String,dynamic> toJson() {
    return {
      'aid': _aid,
      'country':  _country,
      'city':  _city,
      'zipcode':  _zipcode,
      'detail':  _detail
    };
  }
  @override
  String toString() {
    return 'Address{_aid: $_aid,  _country: $_country, _city: $_city, _zipcode: $_zipcode, _detail: $_detail}';
  }
}