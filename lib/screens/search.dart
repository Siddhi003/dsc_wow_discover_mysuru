import 'package:dsc_wow_discover_mysuru/services/geolocator_services.dart';
import 'package:dsc_wow_discover_mysuru/services/marker_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dsc_wow_discover_mysuru/models/place.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        body: (currentPosition != null)
            ? Consumer<List<Place>>(
          builder: (_, places, __) {
            var markers = (places != null)
                ? markerService.getMarkers(places)
                : List<Marker>();
            return (places != null)
                ? Column(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height *2/ 3,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentPosition.latitude,
                            currentPosition.longitude),
                        zoom: 16.0),
                    zoomGesturesEnabled: true,
                    markers: Set<Marker>.of(markers),
                  ),
                ),
              ],
            )
                : Center(child: CircularProgressIndicator());
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
