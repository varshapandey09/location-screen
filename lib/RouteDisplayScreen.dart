import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteDisplayScreen extends StatefulWidget {
  final LatLng startPosition;
  final LatLng endPosition;

  RouteDisplayScreen({required this.startPosition, required this.endPosition});

  @override
  _RouteDisplayScreenState createState() => _RouteDisplayScreenState();
}

class _RouteDisplayScreenState extends State<RouteDisplayScreen> {
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final String apiKey = "AIzaSyDM80KzkiLqRMqHE4lEYl-2jGapbssxpBE"; // Replace with your Google API key
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.startPosition.latitude},${widget.startPosition.longitude}&destination=${widget.endPosition.latitude},${widget.endPosition.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _parseRoutePoints(data);
    } else {
      throw Exception('Failed to load route');
    }
  }

  void _parseRoutePoints(Map<String, dynamic> data) {
    final routes = data['routes'] as List;
    if (routes.isNotEmpty) {
      final points = routes[0]['legs'][0]['steps'] as List;
      setState(() {
        routePoints = points.map((step) {
          final startLocation = step['start_location'];
          return LatLng(startLocation['lat'], startLocation['lng']);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the background color to blue
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Redirect back to Home or previous page
          },
        ),
        title: Text('See Routes' , style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          // Route Information Box
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Start: ${widget.startPosition.latitude}, ${widget.startPosition.longitude}',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'End: ${widget.endPosition.latitude}, ${widget.endPosition.longitude}',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Total Kms',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '45 kms', // Replace with actual distance
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Total Duration',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1 hr 25 min', // Replace with actual duration
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Map Display
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.startPosition,
                zoom: 7,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('start'),
                  position: widget.startPosition,
                  infoWindow: InfoWindow(title: 'Start Location'),
                ),
                Marker(
                  markerId: MarkerId('end'),
                  position: widget.endPosition,
                  infoWindow: InfoWindow(title: 'End Location'),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: routePoints,
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
