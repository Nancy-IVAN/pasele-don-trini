import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String? id;
  final String name;
  final String phone;
  final String date;
  final String time;
  final int people;
  final String favoriteDish;
  final double estimatedSpend;
  final String status;

  Reservation({
    this.id,
    required this.name,
    required this.phone,
    required this.date,
    required this.time,
    required this.people,
    required this.favoriteDish,
    required this.estimatedSpend,
    this.status = 'Confirmada',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'date': date,
      'time': time,
      'people': people,
      'favoriteDish': favoriteDish,
      'estimatedSpend': estimatedSpend,
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Reservation(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      people: (data['people'] is num) ? (data['people'] as num).toInt() : 1,
      favoriteDish: data['favoriteDish'] ?? '',
      estimatedSpend: (data['estimatedSpend'] is num) ? (data['estimatedSpend'] as num).toDouble() : 0.0,
      status: data['status'] ?? 'Confirmada',
    );
  }
}