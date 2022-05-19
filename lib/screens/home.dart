import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../navigation.dart';
import '../provider/provider.dart';
import '../responsive/responsive.dart';
import '../themes/riva_theme.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initMaps();
  }

  initMaps() async {
    await LocationHelper().fetchCurrentLocation(context);
    var lat = Provider.of<AppData>(context, listen: false).currentLatitude;
    var lng = Provider.of<AppData>(context, listen: false).currentLongitude;

    if (mounted) {
      getSize(context);
      Future.delayed(const Duration(seconds: 20), () {});

      setState(() {
        _center = LatLng(lat, lng);
      });
      PlacesHelper().initAddress(context);

      Future.delayed(const Duration(seconds: 20), () {});

      if (_center != null) {
        var pointA = LocationHelper().getRandomLocation(_center, 65);
        var pointB = LocationHelper().getRandomLocation(_center, 90);
        var pointC = LocationHelper().getRandomLocation(_center, 150);
        var pointD = LocationHelper().getRandomLocation(_center, 300);

        setState(() {
          _addMarker(
              LatLng(pointA.latitude, pointA.longitude), "PointA", -50.0);
          _addMarker(
              LatLng(pointB.latitude, pointB.longitude), "PointB", 140.40);
          _addMarker(LatLng(pointC.latitude, pointC.longitude), "PointC", 90.0);
          _addMarker(
              LatLng(pointD.latitude, pointD.longitude), "PointD", 210.20);
        });
      }
    }
  }

  Completer<GoogleMapController> _controller = Completer();
  var _center;
  late LatLng _lastMapPosition;
  var smallScreen = true;

  Color btnActiveColor = Colors.indigo;
  Color? btnColor = Colors.blue[50];
  Color txtActiveColor = Colors.white;
  Color txtColor = Colors.black;
  List cardViews = [true, false];
  String txtActive = "Where do you want to go to?";
  Map<MarkerId, Marker> _markers = {};
  final txtCurrent = TextEditingController();
  final txtDestination = TextEditingController();

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  // add marker to map
  _addMarker(
    LatLng position,
    String id,
    double rotation,
  ) async {
    Uint8List imageData = await LocationHelper().getMarker(context);
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(imageData),
      position: position,
      rotation: rotation,
    );
    _markers[markerId] = marker;
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMoved(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _handleGetLocation(int ch) async {
    var appData = Provider.of<AppData>(context, listen: false);
    if (ch == 0) {
      PlacesHelper().handlePressButton(context, 0);
      print("The selected address ${appData.currentAddress}");
      setState(() {
        txtCurrent.text = appData.currentAddress;
        print("2nd selected address ${appData.currentAddress}");
      });
    } else if (ch == 1) {
      await PlacesHelper().handlePressButton(context, 1);
      var result = await PlacesHelper().getSetAdr(context, 1);
      print("======= first result - $result=====");
      setState(() {
        txtDestination.text = result;
      });
    }
  }

  void _handleShowModal(int ch) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        var appData = Provider.of<AppData>(context, listen: false);
        switch (ch) {
          // taxi modal
          case 1:
            final txtCurrentController = TextEditingController();
            txtCurrentController.text = appData.currentAddress;
            return Container(
              height: MediaQuery.of(context).size.height * .7,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Icon(Icons.location_on),
                    ),
                    title: txtField(
                      context,
                      "10, Aroma",
                      txtCurrentController,
                      isPassword: true,
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Icon(
                        Icons.location_searching,
                        color: Colors.indigo[200],
                      ),
                    ),
                    title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          primary: Colors.white,
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width * .9)),
                      onPressed: () => _handleShowModal(3),
                      child: Text(
                        "Where to?",
                        style: RivaTheme.blueText.headline5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.home),
                    ),
                    title: const Text('Home'),
                    trailing: const Icon(Icons.edit),
                  ),
                  const SizedBox(
                    height: 10,
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.1,
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.star),
                    ),
                    title: const Text('Saved places'),
                  ),
                  const SizedBox(
                    height: 10,
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.1,
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.location_history),
                    ),
                    title: const Text('Amawbia Bypass'),
                  ),
                ],
              ),
            );
            break;
          case 2:
            // logistics modal
            var size = MediaQuery.of(context).size;
            return Container(
              height: size.height * .9,
              color: Colors.transparent,
              child: Column(
                children: [
                  Container(
                    height: size.height * .1,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Request Progress',
                          style: RivaTheme.whiteText.headline4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          bottom: 0,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('text'),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            );
          case 3:
            txtCurrent.text = appData.currentAddress;
            if (appData.destinationAddress != null) {
              txtDestination.text = appData.destinationAddress;
            }
            return Container(
              height: MediaQuery.of(context).size.height * .7,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Icon(Icons.location_on),
                    ),
                    title: txtField(
                      context,
                      "Current address",
                      txtCurrent,
                      isPassword: true,
                      hasOnTap: true,
                      onTap: () => _handleGetLocation(0),
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Icon(
                        Icons.location_searching,
                        color: Colors.indigo[200],
                      ),
                    ),
                    title: txtField(
                      context,
                      "Destination",
                      txtDestination,
                      isPassword: true,
                      hasOnTap: true,
                      onTap: () {
                        _handleGetLocation(1);
                        if (txtDestination.text.isEmpty) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        fixedSize: Size.fromWidth(
                            MediaQuery.of(context).size.width * .5)),
                    onPressed: () => _handleTaxi(
                      txtCurrent.text,
                      txtDestination.text,
                    ),
                    child: Text(
                      "Done",
                      style: RivaTheme.whiteText.headline5,
                    ),
                  ),
                ],
              ),
            );
        }
        return Container();
      },
    );
  }

  void _handleCardSwitchTaxi() {
    setState(() {
      cardViews = [true, false];
      txtActive = "Where do you want to go to?";
    });
  }

  void _handleTaxi(String fromAdr, String toAdr) {
    if (fromAdr.isEmpty || toAdr.isEmpty) {
      print("No empty fields");
    } else {
      Navigator.of(context).pushNamed(confirmRequest);
    }
  }

  void _handleCardSwitchLogistics() {
    setState(() {
      cardViews = [false, true];
      txtActive = "Where is your package going to?";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: RivaAppBar(),
      body: Stack(
        children: [
          // ignore: unnecessary_null_comparison
          (_center != null)
              ? GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _center, zoom: 15),
                  tiltGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  markers: Set<Marker>.of(_markers.values),
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  // markers: markers,
                  onCameraMove: _onCameraMoved,
                )
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/maps.PNG"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ],
      ),
      bottomSheet: BottomSheet(
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * vh,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      primary: Colors.white,
                      fixedSize: Size.fromWidth(
                          MediaQuery.of(context).size.width * .9)),
                  onPressed: () => cardViews[0]
                      ? _handleShowModal(1)
                      : Navigator.pushNamed(context, logistics),
                  child: Text(
                    txtActive,
                    style: RivaTheme.blueText.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.home,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Home',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: cardViews[0] ? btnActiveColor : btnColor,
                            onPrimary: cardViews[0] ? txtActiveColor : txtColor,
                            padding: const EdgeInsets.all(20),
                            fixedSize: Size.fromWidth(
                                MediaQuery.of(context).size.width * .9)),
                        onPressed: _handleCardSwitchTaxi,
                        child: Row(
                          children: [
                            const Icon(Icons.car_rental),
                            Text(
                              'Car Ride',
                              style: cardViews[0]
                                  ? RivaTheme.whiteText.headline5
                                  : RivaTheme.blackText.headline5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: cardViews[1] ? btnActiveColor : btnColor,
                            onPrimary: cardViews[1] ? txtActiveColor : txtColor,
                            padding: const EdgeInsets.all(20),
                            fixedSize: Size.fromWidth(
                                MediaQuery.of(context).size.width * .9)),
                        onPressed: _handleCardSwitchLogistics,
                        child: Row(
                          children: [
                            const Icon(Icons.markunread_mailbox),
                            Text(
                              'Logistics',
                              style: cardViews[1]
                                  ? RivaTheme.whiteText.headline5
                                  : RivaTheme.blackText.headline5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        onClosing: () {},
      ),
    );
  }
}
