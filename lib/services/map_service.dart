import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static Set<Marker> createMarkers({
    required LatLng start,
    required LatLng end,
    LatLng? current,
  }) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId("start"),
        position: start,
        infoWindow: const InfoWindow(title: "Эхлэх цэг"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId("end"),
        position: end,
        infoWindow: const InfoWindow(title: "Очих цэг"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    if (current != null) {
      markers.add(Marker(
        markerId: const MarkerId("current"),
        position: current,
        infoWindow: const InfoWindow(title: "Таны байршил"),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    }

    return markers;
  }
}