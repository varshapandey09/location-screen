import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteDisplayScreen extends StatelessWidget {
  final LatLng startPosition;
  final LatLng endPosition;

  RouteDisplayScreen({required this.startPosition, required this.endPosition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set the background color to blue
        title: Text('Route Display'),
      ),
      body: Column(
        children: [
          // Route Information Box
          Container(
            color: Colors.white, // Background color
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(16), // Optional padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green), // Location icon
                    SizedBox(width: 8), // Space between icon and text
                    Text(
                      'Start: ${startPosition.latitude}, ${startPosition.longitude}',
                      style: TextStyle(fontSize: 16,color: Colors.blueGrey), // Increased font size
                    ),
                  ],
                ),
                SizedBox(height: 8), // Space between entries
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red), // Location icon
                    SizedBox(width: 8),
                    Text(
                      'End: ${endPosition.latitude}, ${endPosition.longitude}',
                      style: TextStyle(fontSize: 16,color: Colors.blueGrey), // Increased font size
                    ),
                  ],
                ),
                SizedBox(height: 16), // Space before totals
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Total Kms',
                            style: TextStyle(fontSize: 12 , fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '45 kms', // Replace with actual distance
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blueGrey),
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
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Increased font size
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1 hr 25 min', // Replace with actual duration
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , color: Colors.blueGrey),
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
                target: startPosition,
                zoom: 10.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('start'),
                  position: startPosition,
                  infoWindow: InfoWindow(title: 'Start Location'),
                ),
                Marker(
                  markerId: MarkerId('end'),
                  position: endPosition,
                  infoWindow: InfoWindow(title: 'End Location'),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: [startPosition, endPosition],
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
