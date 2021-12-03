class AddresModel {
  String addressName;
  double latitude;
  double longitude;
  String key;
  String addressFormated;

  AddresModel({
    required this.key,
    required this.addressName,
    required this.addressFormated,
    required this.latitude,
    required this.longitude,
  });
}
