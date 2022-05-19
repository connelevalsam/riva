import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../navigation.dart';
import '../../provider/provider.dart';
import '../../responsive/responsive.dart';
import '../../themes/riva_theme.dart';
import '../../widgets/widgets.dart';

class StarTrip extends StatefulWidget {
  const StarTrip({Key? key}) : super(key: key);

  @override
  _StarTripState createState() => _StarTripState();
}

class _StarTripState extends State<StarTrip> {
  @override
  void initState() {
    super.initState();

    initMaps();
  }

  _loadEnd() async {
    Provider.of<AppData>(context, listen: false).showNotifications(
      "001",
      "End trip",
      "Trip End",
      "Trip Ended",
      "Trip has ended.",
    );
    await Future.delayed(const Duration(seconds: 20), () {});
    setState(() {
      _center = LatLng(_destLatitude, _destLongitude);

      pointA = LocationHelper().getRandomLocation(_center, 0);
      _addDriver(LatLng(pointA.latitude, pointA.longitude), "PointA", 1.0);
    });
    await Future.delayed(const Duration(seconds: 10), () {});
    Navigator.pushNamed(context, endTrip);
  }

  initMaps() async {
    var lat = Provider.of<AppData>(context, listen: false).currentLatitude;
    var lng = Provider.of<AppData>(context, listen: false).currentLongitude;

    var dLat = Provider.of<AppData>(context, listen: false).destinationLatitude;
    var dLng =
        Provider.of<AppData>(context, listen: false).destinationLongitude;
    Provider.of<AppData>(context, listen: false).showNotifications(
      "001",
      "Trip",
      "Start trip",
      "Start trip",
      "Trip has started.",
    );
    setState(() {
      _center = LatLng(lat, lng);
      _originLatitude = lat;
      _originLongitude = lng;
      _destLatitude = dLat;
      _destLongitude = dLng;
      pointA = LocationHelper().getRandomLocation(_center, 0);
      _addDriver(LatLng(pointA.latitude, pointA.longitude), "PointA", 1.0);
    });

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();

    _onCameraMoved(CameraPosition(target: _center));

    _loadEnd();
  }

  // add markers
  _addDriver(
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

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    _markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    _polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      PlacesHelper().apiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  Completer<GoogleMapController> _controller = Completer();
  var _center,
      _originLatitude,
      _originLongitude,
      _destLatitude,
      _destLongitude,
      pointA;
  late LatLng _lastMapPosition;
  bool isDone = false;
  Widget child = const SizedBox();

  List<LatLng> polylineCoordinates = [];
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMoved(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: const NormalAppBar(
        title: "Trip",
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 15),
            tiltGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            polylines: Set<Polyline>.of(_polylines.values),
            myLocationEnabled: true,
            // markers: markers,
            onCameraMove: _onCameraMoved,
          ),
        ],
      ),
      bottomSheet: BottomSheet(
        builder: (BuildContext context) {
          var size = MediaQuery.of(context).size;
          return Container(
            height: size.height * vh,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      height: 3.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          color: Colors.white,
                        ),
                        width: size.width * .5, //size.width / 3,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      //************details
                      Expanded(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //************picture
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/person_joe.jpeg"),
                              radius: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            //***********details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * .4,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Sheyi Kaido',
                                          style: RivaTheme.whiteText.headline5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Toyota Camry',
                                  style: RivaTheme.whiteText.headline5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '4.6',
                                      style: RivaTheme.whiteText.headline5,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "1,007 Pickups",
                                      style: RivaTheme.whiteText.headline5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.near_me_sharp),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 150.0,
                                  child: Text(
                                    "Heading to Aroma junction",
                                    softWrap: true,
                                    style: RivaTheme.blackText.headline5,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                // txtPlace = await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ChangeDestination(
                                //           type: 1,
                                //         )));
                              },
                              child: Container(
                                // color: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "35 mins",
                                  style: RivaTheme.indigoText.headline5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0, bottom: 1.0),
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 0.3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.near_me_sharp),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 150.0,
                                  child: Text(
                                    "Aroma junction",
                                    softWrap: true,
                                    style: RivaTheme.blackText.headline5,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // txtPlace = await Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => ChangeDestination(
                                  //           type: 1,
                                  //         )));
                                },
                                child: Container(
                                  // color: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    "Change Destination",
                                    style: RivaTheme.indigoText.headline5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0, bottom: 1.0),
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 0.3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person_add_alt),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 150.0,
                                  child: Text(
                                    "Share trip",
                                    softWrap: true,
                                    style: RivaTheme.blackText.headline5,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                // txtPlace = await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ChangeDestination(
                                //           type: 1,
                                //         )));
                              },
                              child: Container(
                                // color: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "Share",
                                  style: RivaTheme.indigoText.headline5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0, bottom: 1.0),
                          child: Divider(
                            color: Colors.grey[400],
                            thickness: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        onClosing: () {},
      ),
    );
  }
}
