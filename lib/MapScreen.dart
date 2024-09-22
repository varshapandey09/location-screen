import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class User {
  String name;
  String id;
  String logInTime;
  String logOutTime;
  bool isLoggedIn;

  User({required this.name, required this.id, this.logInTime = '', this.logOutTime = '', this.isLoggedIn = false});
}

class _MapScreenState extends State<MapScreen> {
  List<User> users = [
    User(name: 'Wade Warren', id: 'WSL0003', logInTime: '09:30 am', isLoggedIn: true),
    User(name: 'Esther Howard', id: 'WSL0034', logInTime: '09:30 am', logOutTime: '06:40 pm', isLoggedIn: false),
    User(name: 'Wade Warren', id: 'WSL0003', logInTime: '09:30 am', isLoggedIn: true),
    User(name: 'Esther Howard', id: 'WSL0034', logInTime: '09:30 am', logOutTime: '06:40 pm', isLoggedIn: false),
    User(name: 'Wade Warren', id: 'WSL0003', logInTime: '09:30 am', isLoggedIn: true),
    User(name: 'Esther Howard', id: 'WSL0034', logInTime: '09:30 am', logOutTime: '06:40 pm', isLoggedIn: false),
    User(name: 'Wade Warren', id: 'WSL0003', logInTime: '09:30 am', isLoggedIn: true),
    User(name: 'Esther Howard', id: 'WSL0034', logInTime: '09:30 am', logOutTime: '06:40 pm', isLoggedIn: false),
    // Add more users here
  ];

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // The Google Map Widget
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          // DraggableScrollableSheet for the Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.2, // Initial size of the bottom sheet when opened
            minChildSize: 0.2,     // Minimum size of the bottom sheet (collapsed)
            maxChildSize: 1.0,     // Maximum size (fully expanded to cover the screen)
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: ListView.builder(
              controller: scrollController,
              itemCount: users.length,
              itemBuilder: (context, index) {
              return ListTile(
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
              );
              },
              ));

            },
          ),
        ],
      ),
    );
  }
}