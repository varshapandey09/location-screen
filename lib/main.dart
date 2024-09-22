import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MapScreen.dart';

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

class User {
  String name;
  String id;
  String logInTime;
  String logOutTime;
  bool isLoggedIn;

  User({
    required this.name,
    required this.id,
    this.logInTime = '',
    this.logOutTime = '',
    this.isLoggedIn = false,
  });
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

  int _selectedIndex = 0;
  bool _isMapVisible = true;

  List<User> users = [
    User(name: 'Wade Warren', id: 'WSL0003', logInTime: '09:30 am', isLoggedIn: true),
    User(name: 'Esther Howard', id: 'WSL0034', logInTime: '09:30 am', logOutTime: '06:40 pm', isLoggedIn: false),
    // Add more users here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Job Site'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Team'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (_isMapVisible)
            SizedBox(
              height: MediaQuery.of(context).size.height , // Adjust map height
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.43296265336819, -122.18956098066438),
                  zoom: 12.0,
                ),
                markers: _markers,
              ),
            )
          else
            ListView.builder(

    itemCount: users.length,
    itemBuilder: (context, index) {
    return InkWell(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => MapScreen(),
    ),
    );
    },
    child: ListTile(
    leading: Icon(
    users[index].isLoggedIn
    ? Icons.check_circle_outline
        : Icons.error_outline,
    color: Colors.green,
    ),
    title: Text(users[index].name),
    subtitle: Text('ID: ${users[index].id}'),
    trailing: users[index].isLoggedIn
    ? Text('${users[index].logInTime} - Working')
        : Text('${users[index].logInTime} - ${users[index].logOutTime}'),
    ),
    );
    },
    ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isMapVisible = !_isMapVisible;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isMapVisible ? 'Show List View' : 'Show Map View',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(_isMapVisible ? Icons.arrow_upward : Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
