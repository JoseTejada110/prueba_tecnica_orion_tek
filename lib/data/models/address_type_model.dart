List<AddressType> addressTypeModelFromJson(dynamic json) => json == null
    ? <AddressType>[]
    : List<AddressType>.from(json.map((x) => AddressType.fromJson(x)));

class AddressType {
  AddressType({
    required this.id,
    required this.type,
  });

  final int id;
  final String type;

  factory AddressType.fromJson(Map<String, dynamic> json) => AddressType(
        id: json["id"] ?? 0,
        type: json["type"] ?? "",
      );
}
