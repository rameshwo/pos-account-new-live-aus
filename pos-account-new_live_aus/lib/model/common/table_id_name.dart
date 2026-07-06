import 'package:equatable/equatable.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';

// ignore: must_be_immutable
class TableIdName extends Equatable {
  final String? id;
  final String? name;
  FloorTblStatus floorTblStatus;
  String? orderId;
  String? mergeId;
  String? imageUrl;
  bool selected;

  TableIdName({
    this.id,
    this.name,
    this.floorTblStatus = FloorTblStatus.Available,
    this.orderId,
    this.mergeId,
    this.imageUrl,
    this.selected = true,
  });

  factory TableIdName.fromJson(Map<String, dynamic> json) => TableIdName(
        id: json["id"],
        name: json["name"],
        mergeId: json["mergeId"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        if (imageUrl != null) "imageUrl": imageUrl,
      };

  @override
  List<Object?> get props => [id, name];
}
