import 'package:flutter/material.dart';
import 'models/saved_route_model.dart';
import 'widgets/saved_route_tile_widget.dart';
import 'widgets/empty_saved_route_widget.dart';
import '../../presentation/create_route/create_route.dart'; // ⭐ ADD THIS
import '../../presentation/edit_route/edit_route.dart';

class SavedRouteScreen extends StatefulWidget {
  const SavedRouteScreen({super.key});

  @override
  State<SavedRouteScreen> createState() => _SavedRouteScreenState();
}

class _SavedRouteScreenState extends State<SavedRouteScreen> {
  List<SavedRouteModel> savedRoutes = [
    SavedRouteModel(
      origin: "Ulaanbaatar",
      destination: "Nalaikh",
      price: 5000,
      seats: 3,
      date: DateTime.now().add(const Duration(days: 1)),
    ),
    SavedRouteModel(
      origin: "Bayanzürkh",
      destination: "Zaisan",
      price: 2500,
      seats: 2,
      date: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  void deleteRoute(int index) {
    setState(() {
      savedRoutes.removeAt(index);
    });
  }

  void editRoute(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditRoute(route: savedRoutes[index]),
      ),
    );
  }

  void goToCreateRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateRoute(), // ⭐ REAL ROUTE PAGE
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Routes")),

      body: RefreshIndicator(
        onRefresh: refresh,
        child: savedRoutes.isEmpty
            ? const EmptySavedRouteWidget()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: savedRoutes.length,
          itemBuilder: (_, i) => SavedRouteTileWidget(
            route: savedRoutes[i],
            onDelete: () => deleteRoute(i),
            onEdit: () => editRoute(i),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToCreateRoute,
        icon: const Icon(Icons.add_road),
        label: const Text("Create Route"),
      ),
    );
  }
}