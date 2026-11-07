import 'package:flutter/material.dart';
import '../models/reservation_model.dart';
import '../services/firebase_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return StreamBuilder<List<Reservation>>(
      stream: firebaseService.getReservationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar datos: ${snapshot.error}'));
        }

        final reservations = snapshot.data ?? [];

        double totalEst = 0;
        int totalGuests = 0;
        final Map<String, int> dishCounts = {};

        for (var r in reservations) {
          totalEst += r.estimatedSpend;
          totalGuests += r.people;
          dishCounts[r.favoriteDish] = (dishCounts[r.favoriteDish] ?? 0) + 1;
        }

        String topDish = 'N/A';
        int maxCount = 0;
        dishCounts.forEach((dish, count) {
          if (count > maxCount) {
            maxCount = count;
            topDish = dish;
          }
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumen Operativo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildMetricCard('Reservas', '${reservations.length}', Icons.event_seat, Colors.blue),
                  const SizedBox(width: 8),
                  _buildMetricCard('Ingreso Est.', '\$${totalEst.toStringAsFixed(0)}', Icons.attach_money, Colors.green),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMetricCard('Comensales', '$totalGuests pers.', Icons.groups, Colors.orange),
                  const SizedBox(width: 8),
                  _buildMetricCard('Platillo Top', topDish, Icons.star, Colors.amber),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Listado de Reservaciones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text('${reservations.length} activas'),
                    backgroundColor: Colors.deepOrange.shade50,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (reservations.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('No hay reservaciones registradas en Firestore.'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final r = reservations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  r.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '\$${r.estimatedSpend.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(r.phone),
                                const SizedBox(width: 16),
                                const Icon(Icons.people, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('${r.people} personas'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('${r.date} a las ${r.time}'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.restaurant, size: 16, color: Colors.deepOrange),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Platillo: ${r.favoriteDish}',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 18,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  Text(
                    value,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}