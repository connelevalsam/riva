class Driver {
  int id;
  List profile;
  List car_details;

  Driver({
    required this.id,
    required this.profile,
    required this.car_details,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json["id"] ?? "",
      profile: json["profile"] ?? [],
      car_details: json["profile"] ?? [],
    );
  }
}
