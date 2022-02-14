import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigation.dart';
import '../provider/provider.dart';
import '../themes/riva_theme.dart';
import '../widgets/widgets.dart';

class RequestPickup extends StatefulWidget {
  const RequestPickup({Key? key}) : super(key: key);

  @override
  _RequestPickupState createState() => _RequestPickupState();
}

class _RequestPickupState extends State<RequestPickup> {
  @override
  void initState() {
    super.initState();
    initMaps();
  }

  initMaps() async {
    var lat = Provider.of<AppData>(context, listen: false).currentLatitude;
    var lng = Provider.of<AppData>(context, listen: false).currentLongitude;

    var dLat = Provider.of<AppData>(context, listen: false).destinationLatitude;
    var dLng =
        Provider.of<AppData>(context, listen: false).destinationLongitude;
    setState(() {
      _center = LatLng(lat, lng);
      _originLatitude = lat;
      _originLongitude = lng;
      _destLatitude = dLat;
      _destLongitude = dLng;

      pointA = LocationHelper().getRandomLocation(_center, 65);
      _addDriver(LatLng(pointA.latitude, pointA.longitude), "PointA", -50.0);

      if (mounted) {
        setState(() {});
      }
    });

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();

    _onCameraMoved(CameraPosition(target: _center));
  }

  List<LatLng> polylineCoordinates = [];
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  var pointA;

  // add marker to map
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

  var _center, _originLatitude, _originLongitude, _destLatitude, _destLongitude;

  Completer<GoogleMapController> _controller = Completer();
  late LatLng _lastMapPosition;
  bool isDone = false;
  Widget child = SizedBox();

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

  PanelController _pc = PanelController();
  final String phoneNumber = "07034857296";
  int chatCounter = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NormalAppBar(
        title: "Request Pickup",
      ),
      body: SlidingUpPanel(
        controller: _pc,
        onPanelClosed: () {
          setState(() {});
        },
        onPanelOpened: () {
          Future.delayed(const Duration(seconds: 10), () {});
          print("Panel opened");
          setState(() {
            _pc.close();
            child = DriverArrived(
              sendMessage: _handleChat,
              phoneNumber: _callNumber,
              counter: chatCounter,
            );
            isDone = true;

            pointA = LocationHelper().getRandomLocation(_center, 0);
            _addDriver(
                LatLng(pointA.latitude, pointA.longitude), "PointA", 1.0);
          });
          Future.delayed(const Duration(seconds: 50), () {});
          Navigator.pushNamed(context, starTrip);
        },
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 17, bearing: 5.5),
              onMapCreated: _onMapCreated,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              markers: Set<Marker>.of(_markers.values),
              polylines: Set<Polyline>.of(_polylines.values),
              mapType: MapType.normal,
              myLocationEnabled: true,
              // markers: markers,
              onCameraMove: _onCameraMoved,
            ),
          ],
        ),
        panel: _waitingDetails(),
        minHeight: 300,
        collapsed: _driverDetails(),
        borderRadius: radius,
      ),
      bottomSheet: isDone == false
          ? const SizedBox(
              height: 1,
            )
          : BottomSheet(onClosing: () {}, builder: (_) => child),
    );
  }

  _driverDetails() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .3,
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
                            width: size.width * .3,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                //**********actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PhoneNumber(
                      callback: _callNumber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SendMessage(
                      counter: chatCounter,
                      callback: _handleChat,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    "Arrives in 5 mins",
                    style: RivaTheme.blackText.headline4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 1.0),
                    child: Divider(
                      color: Colors.grey[200],
                      thickness: 0.1,
                    ),
                  ),
                  BtnWidget(
                    bgColor: Colors.grey[300],
                    txtColor: Colors.black,
                    title: "Cancel Request",
                    btnSize: .9,
                    callback: () {},
                    theme: RivaTheme.blackText.headline5,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _waitingDetails() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: radius,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height: 3.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    color: Colors.grey[300],
                  ),
                  width: size.width * .3, //size.width / 3,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Arrives in 5 mins",
              style: RivaTheme.blueText.headline4,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 1.0),
            child: Divider(
              color: Colors.grey[400],
              thickness: 0.3,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To Aroma junction",
                  style: RivaTheme.blackText.headline4,
                ),
                Text(
                  "From Temp site at 1:35pm",
                  style: RivaTheme.blackText.bodyText2,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 1.0),
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 0.3,
                  ),
                ),
                Text(
                  "\u{20A6}700.00",
                  style: RivaTheme.blackText.headline4,
                ),
                Text(
                  "Estimated price",
                  style: RivaTheme.blackText.bodyText2,
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Change Destination",
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
          )
        ],
      ),
    );
  }

  void _callNumber() async {
    String phoneNumber = "tel://" + this.phoneNumber;
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  void _handleChat() async {
    setState(() {
      chatCounter = 0;
    });
  }
}
