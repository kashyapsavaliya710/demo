import 'dart:async';
import 'package:demo/screens/email_auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(22.6708, 71.5724),
    zoom: 5,
  );

  List<Marker> _marker = [];
  final List<Marker> _list =  [
  Marker(
    markerId: MarkerId('1'),
    position: LatLng(51.1657, 104515),
    infoWindow: InfoWindow(
      title: 'My Current Location'
    )
  ),

    Marker(
        markerId: MarkerId('2'),
        position: LatLng(51.1657, 104515),
        infoWindow: InfoWindow(
            title: 'My Collage'
        )
    )
  ];

  void logOut() async {
    await _auth.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace) {
      print("error"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState(){
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: TextStyle(color: Colors.white), // Set the text color here
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                SizedBox(width: 5), // Add some space between the icon and text
                Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )

        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_marker),
        mapType: MapType.normal,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getUserCurrentLocation().then((value)async{
            print("my Current location");
            print(value.latitude.toString()+"  "+value.longitude.toString());

            _marker.add(
              Marker(
                  markerId: MarkerId('2'),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(
                  title: 'My Current Location'
                )
              )
            );
            CameraPosition cameraPosition = CameraPosition(
              zoom: 14,
                target: LatLng(value.latitude, value.longitude));

            final GoogleMapController controller =await _controller.future;

            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {

            });
          });
        },
        child: Icon(Icons.my_location_outlined),
      ),
    );
  }
}
