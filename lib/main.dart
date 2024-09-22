import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Attendance'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Set<Marker> _markers = {}; // Stores member location markers

// Replace these with your actual member data (latitude & longitude)
  final List<LatLng> _memberLocations = [
    LatLng(37.7749, -122.4194), // Example location in San Francisco
    LatLng(40.7128, -74.0059), // Example location in New York City
  ];

  void _addMarkers() {
    setState(() {
      for (LatLng location in _memberLocations) {
        _markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: location,
            icon: BitmapDescriptor.defaultMarker, // Or a custom icon
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _addMarkers(); // Add markers on app launch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
// Handle navigation drawer or side menu toggle
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
// Handle "All Members" link
            },
            child: const Text('All Members'),
          ),
          TextButton(
            onPressed: () {
// Handle "Change" button
            },
            child: const Text('Change'),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.43296265336819, -122.18956098066438), // Adjust center coordinates
          zoom: 12.0,
        ),
        markers: _markers,
      ),
    );
  }
}

