import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservation_model.dart';

class FirebaseService {
  final CollectionReference _reservationsRef =
      FirebaseFirestore.instance.collection('reservaciones');

  // Guardar nueva reservación en Firestore
  Future<void> addReservation(Reservation reservation) async {
    await _reservationsRef.add(reservation.toMap());
  }

  // Leer registros en tiempo real mediante Stream
  Stream<List<Reservation>> getReservationsStream() {
    return _reservationsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromFirestore(doc))
            .toList());
  }
}