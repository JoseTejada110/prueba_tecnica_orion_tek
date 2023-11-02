List<ClientModel> clientModelFromJson(dynamic json) => json == null
    ? <ClientModel>[]
    : List<ClientModel>.from(json.map((x) => ClientModel.fromJson(x)));

class ClientModel {
  ClientModel({
    required this.id,
    required this.name,
    required this.addresses,
  });

  final int id;
  final String name;
  final List<ClientAddress> addresses;

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        addresses: clientAddressesFromJson(json['addresses']),
      );
}

List<ClientAddress> clientAddressesFromJson(dynamic json) => json == null
    ? <ClientAddress>[]
    : List<ClientAddress>.from(json.map((x) => ClientAddress.fromJson(x)));

class ClientAddress {
  const ClientAddress({
    required this.id,
    required this.formattedAddress,
    required this.lat,
    required this.lng,
    required this.typeId,
    required this.type,
  });

  final int id;
  final String formattedAddress;
  final double lat;
  final double lng;
  final int typeId;
  final String type;

  factory ClientAddress.fromJson(Map<String, dynamic> json) => ClientAddress(
        id: json["id"] ?? 0,
        formattedAddress: json["formatted_address"] ?? "",
        lat: json["lat"] ?? 0,
        lng: json["lng"] ?? 0,
        typeId: json["type_id"] ?? 0,
        type: json["type"] ?? "",
      );
}
