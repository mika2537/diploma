class SavedRouteModel {
  final String origin;
  final String destination;
  final DateTime date;
  final int seats;
  final int price;

  SavedRouteModel({
    required this.origin,
    required this.destination,
    required this.date,
    required this.seats,
    required this.price,
  });
}