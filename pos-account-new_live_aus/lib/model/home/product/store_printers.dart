class StorePrintersRes {
  String? id;
  String? value;
  String? additionalValue;
  bool? isSelected;
  String? name;

  StorePrintersRes(
      {this.id, this.value, this.additionalValue, this.isSelected, this.name});

  StorePrintersRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    additionalValue = json['additionalValue'];
    isSelected = json['isSelected'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['additionalValue'] = additionalValue;
    data['isSelected'] = isSelected;
    data['name'] = name;
    return data;
  }
}
