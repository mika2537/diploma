import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/saved_route_model.dart';

class SavedRouteTileWidget extends StatelessWidget {
  final SavedRouteModel route;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SavedRouteTileWidget({
    super.key,
    required this.route,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat("MMM dd, yyyy – HH:mm").format(route.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Origin → Destination
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  "${route.origin} → ${route.destination}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 6),
                Text(dateString, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),

            const SizedBox(height: 10),

            // Seats & Price
            Row(
              children: [
                const Icon(Icons.event_seat, size: 18),
                const SizedBox(width: 4),
                Text("${route.seats} seats"),

                const SizedBox(width: 20),

                const Icon(Icons.attach_money, size: 18),
                const SizedBox(width: 4),
                Text("${route.price} ₮"),
              ],
            ),

            const SizedBox(height: 14),

            // ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onDelete,
                  child: const Text("Delete"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onEdit,
                  child: const Text("Edit"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}