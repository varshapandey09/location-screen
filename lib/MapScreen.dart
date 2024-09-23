import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'RouteDisplayScreen.dart';

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

  // Optional image path
  String imagePath;

  // Optional location (LatLng)
  LatLng? location;

  User(
      {required this.name,
      required this.id,
      this.logInTime = '',
      this.logOutTime = '',
      this.isLoggedIn = false,
      this.imagePath = 'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png',
      this.location});
}

class TravelRoute {
  final String startLocationName;
  final LatLng startLocation;
  final String stopLocationName;
  final String startTime, endTime;
  final LatLng stopLocation;
  final double totalKilometers;
  final Duration totalDuration;
  final List<StopDetail> stopDetails;
  final List<LatLng> routePath;

  TravelRoute(
      {required this.startLocationName,
      required this.startLocation,
      required this.stopLocationName,
      required this.stopLocation,
      required this.totalKilometers,
      required this.totalDuration,
      required this.stopDetails,
      required this.routePath,
      required this.endTime,
      required this.startTime});
}

class StopDetail {
  final LatLng location;
  final Duration stopDuration;

  StopDetail({
    required this.location,
    required this.stopDuration,
  });
}

List<TravelRoute> travelRoutes = [
  TravelRoute(
    startLocationName: 'Hollywood Walk of Fame',
    startLocation: LatLng(34.1010, -118.3406), // Hollywood, LA
    stopLocationName: 'The Strip',
    startTime: "9:00 am",
    endTime: "10:30 am",
    stopLocation: LatLng(36.1147, -115.1728), // Las Vegas
    totalKilometers: 435.0,
    totalDuration: Duration(hours: 4, minutes: 15),
    stopDetails: [
      StopDetail(
        location: LatLng(35.2828, -116.8539), // Midway stop
        stopDuration: Duration(minutes: 15),
      ),
    ],
    routePath: [
      LatLng(34.1010, -118.3406), // Start in Hollywood
      LatLng(35.2828, -116.8539), // Midway stop
      LatLng(36.1147, -115.1728), // Stop in Las Vegas
    ],
  ),
  TravelRoute(
    startLocationName: 'Central Park',
    startLocation: LatLng(40.7851, -73.9683), // New York
    stopLocationName: 'Liberty Bell',
    startTime: "9:50 am",
    endTime: "11:00 am",
    stopLocation: LatLng(39.9496, -75.1503), // Philadelphia
    totalKilometers: 150.0,
    totalDuration: Duration(hours: 2, minutes: 5),
    stopDetails: [
      StopDetail(
        location: LatLng(40.2307, -74.0074), // Midway stop
        stopDuration: Duration(minutes: 12),
      ),
    ],
    routePath: [
      LatLng(40.7851, -73.9683), // Start in Central Park
      LatLng(40.2307, -74.0074), // Midway stop
      LatLng(39.9496, -75.1503), // Stop at Liberty Bell
    ],
  ),
  TravelRoute(
    startLocationName: 'Golden Gate Park',
    startLocation: LatLng(37.7694, -122.4862), // San Francisco
    stopLocationName: 'Santa Monica Pier',
    startTime: "9:00 am",
    endTime: "3:00 pm",
    stopLocation: LatLng(34.0101, -118.4965), // Santa Monica, LA
    totalKilometers: 610.0,
    totalDuration: Duration(hours: 6, minutes: 30),
    stopDetails: [
      StopDetail(
        location: LatLng(36.7783, -119.4179), // Midway stop
        stopDuration: Duration(minutes: 25),
      ),
    ],
    routePath: [
      LatLng(37.7694, -122.4862), // Start in Golden Gate Park
      LatLng(36.7783, -119.4179), // Midway stop
      LatLng(34.0101, -118.4965), // Stop at Santa Monica Pier
    ],
  ),
  TravelRoute(
    startLocationName: 'Tower Bridge',
    startLocation: LatLng(51.5055, -0.0754), // London
    stopLocationName: 'Birmingham City Centre',
    stopLocation: LatLng(52.4814, -1.8945), // Birmingham
    totalKilometers: 205.0,
    startTime: "9:50 am",
    endTime: "12:45 pm",
    totalDuration: Duration(hours: 2, minutes: 30),
    stopDetails: [
      StopDetail(
        location: LatLng(51.8696, -1.2547), // Midway stop
        stopDuration: Duration(minutes: 10),
      ),
    ],
    routePath: [
      LatLng(51.5055, -0.0754), // Start at Tower Bridge
      LatLng(51.8696, -1.2547), // Midway stop
      LatLng(52.4814, -1.8945), // Stop in Birmingham City Centre
    ],
  ),
  TravelRoute(
    startLocationName: 'Eiffel Tower',
    startLocation: LatLng(48.8584, 2.2945), // Paris
    stopLocationName: 'Place Bellecour',
    startTime: "9:50 am",
    endTime: "1:00 pm",
    stopLocation: LatLng(45.7485, 4.8357), // Lyon
    totalKilometers: 465.0,
    totalDuration: Duration(hours: 4, minutes: 45),
    stopDetails: [
      StopDetail(
        location: LatLng(46.7790, 3.1600), // Midway stop
        stopDuration: Duration(minutes: 20),
      ),
    ],
    routePath: [
      LatLng(48.8584, 2.2945), // Start at Eiffel Tower
      LatLng(46.7790, 3.1600), // Midway stop
      LatLng(45.7485, 4.8357), // Stop at Place Bellecour
    ],
  ),
];


class _MapScreenState extends State<MapScreen> {
  List<User> users = [
    User(
        name: 'Wade Warren',
        id: 'WSL0001',
        logInTime: '09:30 am',
        isLoggedIn: true,
        location: const LatLng(34.0522, -118.2437)), // Los Angeles
    User(
        name: 'Esther Howard',
        id: 'WSL0002',
        logInTime: '09:30 am',
        logOutTime: '06:40 pm',
        isLoggedIn: false,
        location: const LatLng(40.7128, -74.0060)), // New York
    User(
        name: 'John Doe',
        id: 'WSL0003',
        logInTime: '08:45 am',
        isLoggedIn: true,
        location: const LatLng(37.7749, -122.4194)), // San Francisco
    User(
        name: 'Alice Smith',
        id: 'WSL0004',
        logInTime: '10:15 am',
        logOutTime: '05:30 pm',
        isLoggedIn: false,
        location: const LatLng(51.5074, -0.1278)), // London
    User(
        name: 'Michael Brown',
        id: 'WSL0005',
        logInTime: '09:00 am',
        isLoggedIn: true,
        location: const LatLng(48.8566, 2.3522)), // Paris
    User(
        name: 'Jane Foster',
        id: 'WSL0006',
        logInTime: '08:30 am',
        logOutTime: '04:50 pm',
        isLoggedIn: false,
        location: const LatLng(35.6895, 139.6917)), // Tokyo
    User(
        name: 'David Lee',
        id: 'WSL0007',
        logInTime: '07:50 am',
        isLoggedIn: true,
        location: const LatLng(55.7558, 37.6173)), // Moscow
    User(
        name: 'Maria Garcia',
        id: 'WSL0008',
        logInTime: '09:20 am',
        logOutTime: '05:00 pm',
        isLoggedIn: false,
        location: const LatLng(19.4326, -99.1332)), // Mexico City
  ];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the current location.
    return await Geolocator.getCurrentPosition();
  }

  late GoogleMapController mapController;

  final BitmapDescriptor _blueMarker =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print(e);
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------------//

  void navigateToRouteDisplay(BuildContext context, LatLng start, LatLng end) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDisplayScreen(
          startPosition: start,
          endPosition: end,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Set the background color to blue
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Redirect back to Home or previous page
          },
        ),
        title: Text('Track Live Location' , style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        children: [
          // The Google Map Widget
          _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: _currentPosition!,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),

          // DraggableScrollableSheet for the Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            // Initial size of the bottom sheet when opened
            minChildSize: 0.2,
            // Minimum size of the bottom sheet (collapsed)
            maxChildSize: 1.0,
            // Maximum size (fully expanded to cover the screen)
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  // Pass the controller to the scroll view
                  child: Column(
                    children: [
                      // Row with total slides, date, and calendar icon
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.grey[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Slides: 5 | Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                // Add action for calendar icon if needed
                                navigateToRouteDisplay(
                                    context,
                                    LatLng(34.1184, -118.3004),
                                    // Griffith Observatory
                                    LatLng(
                                        34.0780, -118.4741) // The Getty Center
                                    );
                              },
                            ),
                          ],
                        ),
                      ),

                      // List of travel routes
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        // Disable scrolling for the ListView
                        shrinkWrap: true,
                        // Allow the ListView to take only the space it needs
                        itemCount: travelRoutes.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              // Call your route display function here, passing the start and stop locations
                              navigateToRouteDisplay(
                                  context,
                                  travelRoutes[index].startLocation,
                                  travelRoutes[index].stopLocation);
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              title: Text(travelRoutes[index].stopLocationName),
                              subtitle: Text(
                                  'Started from: ${travelRoutes[index].startLocationName} | Total Duration: ${travelRoutes[index].totalDuration.inHours} hrs'),
                              trailing: Text(
                                  '${travelRoutes[index].startTime} - ${travelRoutes[index].endTime}'),
                            ),
                          );
                        },
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
  }

  // Set<Marker> _createMarkers() {
  //   final markers = <Marker>{};
  //   for (final user in users) {
  //     final markerId = MarkerId(user.id);
  //     final marker = Marker(
  //       markerId: markerId,
  //       icon: _createMarkerIcon(user), // Use the custom icon creation function with user data
  //       position: user.location ?? _center, // Use user location if available, otherwise use center
  //     );
  //     markers.add(marker);
  //   }
  //   return markers;
  // }
  BitmapDescriptor _createMarkerIcon(User user) {
    //if (user.imagePath == null){
    return _blueMarker; // Return default blue marker if no image path
    //}

    /*return BitmapDescriptor.fromAsset(
      user.imagePath,
      width: 48,  // specify width in pixels
      height: 48, // specify height in pixels
    ).catchError((error) {
      // Handle potential errors during image loading (optional)
      print("Error loading user image: $error");
      return _blueMarker; // Return default blue marker on error
    });*/
  }
}
