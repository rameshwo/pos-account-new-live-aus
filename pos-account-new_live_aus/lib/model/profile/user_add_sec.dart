class UserAddSec {
  UserAddSec({
    this.countryCityStates,
    this.userTypes,
    this.roles,
    this.posTabDefaultScreens,
  });

  List<CountryCityState>? countryCityStates;
  List<UserAddSecData>? userTypes;
  List<UserAddSecData>? roles;
  List<UserAddSecData>? posTabDefaultScreens;

  factory UserAddSec.fromJson(Map<String, dynamic> json) => UserAddSec(
        countryCityStates: json["countryCityStates"] == null
            ? null
            : List<CountryCityState>.from(json["countryCityStates"]
                .map((x) => CountryCityState.fromJson(x))),
        userTypes: json["userTypes"] == null
            ? null
            : List<UserAddSecData>.from(
                json["userTypes"].map((x) => UserAddSecData.fromJson(x))),
        roles: json["roles"] == null
            ? null
            : List<UserAddSecData>.from(
                json["roles"].map((x) => UserAddSecData.fromJson(x))),
        posTabDefaultScreens: json["posTabDefaultScreens"] == null
            ? []
            : List<UserAddSecData>.from(json["posTabDefaultScreens"]!
                .map((x) => UserAddSecData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countryCityStates": countryCityStates == null
            ? null
            : List<dynamic>.from(countryCityStates!.map((x) => x.toJson())),
        "userTypes": userTypes == null
            ? null
            : List<dynamic>.from(userTypes!.map((x) => x.toJson())),
        "roles": roles == null
            ? null
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "posTabDefaultScreens": posTabDefaultScreens == null
            ? []
            : List<dynamic>.from(posTabDefaultScreens!.map((x) => x.toJson())),
      };
}

class CountryCityState {
  String? id;
  String? value;
  String? image;
  String? name;
  bool? isSelected;
  String? additionalValue;
  List<CountryState>? states;

  CountryCityState({
    this.id,
    this.value,
    this.image,
    this.name,
    this.isSelected,
    this.additionalValue,
    this.states,
  });

  factory CountryCityState.fromJson(Map<String, dynamic> json) =>
      CountryCityState(
        id: json["id"],
        value: json["value"],
        image: json["image"],
        name: json["name"],
        isSelected: json["isSelected"],
        additionalValue: json["additionalValue"],
        states: json["states"] == null
            ? []
            : List<CountryState>.from(
                json["states"]!.map((x) => CountryState.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "image": image,
        "name": name,
        "isSelected": isSelected,
        "additionalValue": additionalValue,
        "states": states == null
            ? []
            : List<dynamic>.from(states!.map((x) => x.toJson())),
      };
}

class CountryState {
  List<City>? cities;
  String? name;
  String? id;

  CountryState({
    this.cities,
    this.name,
    this.id,
  });

  factory CountryState.fromJson(Map<String, dynamic> json) => CountryState(
        cities: json["cities"] == null
            ? []
            : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cities": cities == null
            ? []
            : List<dynamic>.from(cities!.map((x) => x.toJson())),
        "name": name,
        "id": id,
      };
}

class City {
  String? name;
  String? id;
  List<Suburb>? suburbs;

  City({
    this.name,
    this.id,
    this.suburbs,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        id: json["id"],
        suburbs: json["suburbs"] == null
            ? []
            : List<Suburb>.from(
                json["suburbs"]!.map((x) => Suburb.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "suburbs": suburbs == null
            ? []
            : List<dynamic>.from(suburbs!.map((x) => x.toJson())),
      };
}

class Suburb {
  String? name;
  String? id;

  Suburb({
    this.name,
    this.id,
  });

  factory Suburb.fromJson(Map<String, dynamic> json) => Suburb(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class UserAddSecData {
  UserAddSecData({
    this.image,
    this.id,
    this.value,
    this.additionalValue,
    this.isSelected,
    this.name,
  });

  String? image;
  String? id;
  String? value;
  dynamic additionalValue;
  bool? isSelected;
  String? name;

  factory UserAddSecData.fromJson(Map<String, dynamic> json) => UserAddSecData(
        image: json["image"],
        id: json["id"],
        value: json["value"],
        additionalValue: json["additionalValue"],
        isSelected: json["isSelected"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
        "value": value,
        "additionalValue": additionalValue,
        "isSelected": isSelected,
        "name": name,
      };
}
