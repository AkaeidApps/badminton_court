class Booking {
  final String id;
  final String courtId;
  final String courtName;
  final String image;
  final String date;
  final String time;
  final int price;
  final String status;

  const Booking({
    required this.id,
    required this.courtId,
    required this.courtName,
    required this.image,
    required this.date,
    required this.time,
    required this.price,
    this.status = 'Confirmed',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'courtId': courtId,
    'courtName': courtName,
    'image': image,
    'date': date,
    'time': time,
    'price': price,
    'status': status,
  };

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      courtId: json['courtId'] ?? '',
      courtName: json['courtName'] ?? '',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      status: json['status'] ?? 'Confirmed',
    );
  }
}
