import 'dart:async';
import 'dart:ui';

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
  final List<LatLng> _memberLocations = [
    LatLng(28.6139, 77.2090), // Delhi
    LatLng(19.0760, 72.8777), // Mumbai
    LatLng(13.0827, 80.2707), // Chennai
    LatLng(12.9716, 77.5946), // Bengaluru
    LatLng(22.5726, 88.3639), // Kolkata
    LatLng(28.6129, 77.2295),
    LatLng(21.1458,79.0882)
  ];


  final List<LatLng> _groupedLocations = [
    LatLng(37.7749, -122.4194), // Cluster example location 1
    LatLng(37.7750, -122.4184), // Cluster example location 2
    LatLng(37.7752, -122.4185), // Cluster example location 3
  ];

  Future<BitmapDescriptor> createCustomMarker(bool isLoggedIn) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw the circular part of the marker
    Paint paint = Paint()..color = Colors.purple;
    canvas.drawCircle(Offset(30, 30), 20, paint); // Circle with radius 20

    // Draw the pointed corner
    Path path = Path();
    path.moveTo(30, 60); // Bottom point of the triangle
    path.lineTo(20, 30); // Left point of the triangle
    path.lineTo(40, 30); // Right point of the triangle
    path.close(); // Close the path

    canvas.drawPath(path, paint); // Draw the triangle

    // Draw a green dot if logged in
    if (isLoggedIn) {
      Paint dotPaint = Paint()..color = Colors.green; // Green color
      canvas.drawCircle(Offset(38, 22), 6, dotPaint); // Dot positioned at bottom right
    }

    final img = await pictureRecorder.endRecording().toImage(60, 60);
    final byteData = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }



  void _addMarkers() async {
    setState(() {
      for (int index = 0; index < _memberLocations.length; index++) {
        LatLng location = _memberLocations[index];
        bool isLoggedIn = users[index].isLoggedIn; // Get the login status

        createCustomMarker(isLoggedIn).then((markerIcon) {
          _markers.add(
            Marker(
              markerId: MarkerId(location.toString()),
              position: location,
              icon: markerIcon,
              infoWindow: InfoWindow(
                title: 'Marker at ${location.toString()}',
                snippet: 'Tap here for details',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
              ),
            ),
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  int _selectedIndex = 0;
  bool _isMapVisible = true;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );
  }


  List<User> users = [
    User(name: 'Wade Warren', id: 'WSL0003', logInTime: '09:30 am', isLoggedIn: true),
    User(name: 'Esther Howard', id: 'WSL0034', logInTime: '09:30 am', logOutTime: '06:40 pm', isLoggedIn: false),
    User(name: 'Michael Brown', id: 'WSL0012', logInTime: '08:45 am', logOutTime: '05:15 pm', isLoggedIn: false),
    User(name: 'Emma Wilson', id: 'WSL0025', logInTime: '09:00 am', isLoggedIn: true),
    User(name: 'James Smith', id: 'WSL0046', logInTime: '09:15 am', logOutTime: '06:00 pm', isLoggedIn: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // No extra padding
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF5E4B8C), // Dark purple color
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 40, // Adjusted size for better proportion
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'workstatus',
                          style: TextStyle(color: Colors.white, fontSize: 14), // Adjusted font size
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30), // Adjusted space between workstatus and profile info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24, // Reduced radius for the profile image
                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cameron Williamson',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), // Reduced font size
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'cameronwilliamson@gmail.com',
                              style: TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

              ),
            ),
            // Menu items should now scroll
            ...List.generate(10, (index) {
              List<String> menuItems = [
                'Timer',
                'Attendance',
                'Activity',
                'Timesheet',
                'Report',
                'Jobsite',
                'Team',
                'Time off',
                'Schedules',
                'Request to join Organisation',
                'Change Password',
                'Logout',
              ];

              List<IconData> icons = [
                Icons.timer,                 // Timer
                Icons.calendar_today,         // Attendance
                Icons.show_chart,             // Activity (line chart)
                Icons.access_time,            // Timesheet (you can use a different icon if needed)
                Icons.bar_chart,              // Report
                Icons.business,               // Jobsite (building)
                Icons.people,                 // Team
                Icons.airplanemode_active,    // Time off (plane)
                Icons.calendar_today,         // Schedules (calendar)
                Icons.supervised_user_circle, // Request to join Organisation (hierarchy sign)
                Icons.lock,                   // Change Password (lock)
                Icons.exit_to_app,            // Logout (out arrow)
              ];

              return ListTile(
                leading: Icon(icons[index], color: Colors.purple), // Icon for each menu item
                title: Text(menuItems[index]),
                selected: _selectedIndex == index,
                tileColor: _selectedIndex == index ? Colors.purple.shade200 : null, // Purple shade on selection
                onTap: () {
                  _onItemTapped(index);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),

      body: Column(
          children: [
          Container(
          color: Color(0xFFEDE7F6), // Very light purple
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
              children: [
                Icon(Icons.people, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'All Members',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Text(
              'Change',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ],
        ),
      ),
      Expanded(
        child: Stack(
        children: [
        if (_isMapVisible)
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
          initialCameraPosition: CameraPosition(
          target: LatLng(21.1458, 79.0882),
          zoom: 5.0,
        ),
        markers: _markers,
        onTap: (position) {
        _navigateToMapScreen();
        },
      ),
    )
    else
      ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
              Navigator.push(
                context,
                  MaterialPageRoute(
                  builder: (context) => MapScreen(),
                ),
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png',
              ),
            ),
            title: Text(
              '${users[index].name} (${users[index].id})',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${users[index].logInTime}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 8),
                  if (users[index].isLoggedIn)
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.yellow,
                      size: 20,
                    ),
                  if (!users[index].isLoggedIn)
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                      size: 20,
                    ),
                  SizedBox(width: 4),
                  if (users[index].isLoggedIn)
                    Text(
                      'Working',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(width: 8),
                    Text(
                      '${users[index].logOutTime}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
    Icon(Icons.calendar_today, color: Colors.purple, size: 24),
    SizedBox(width: 8),
    Icon(Icons.location_on, color: Colors.purple, size: 24),
    ],
    ),
    ),
    ),
    if (index < users.length - 1)
    Divider(
    color: Colors.grey.shade300,
    thickness: 1,
    indent: 16,
    endIndent: 16,
    ),
    ],
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
    ),
    ],
      ),
    );
  }
}
