import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../navigation.dart';
import '../../provider/provider.dart';
import '../../responsive/responsive.dart';
import '../../themes/riva_theme.dart';
import '../../widgets/widgets.dart';

class ConfirmPickup extends StatefulWidget {
  const ConfirmPickup({Key? key}) : super(key: key);

  @override
  State<ConfirmPickup> createState() => _ConfirmPickupState();
}

class _ConfirmPickupState extends State<ConfirmPickup> {
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

  var newVH = vh;

  // add marker to map
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

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMoved(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NoMemuAppBar(
        title: "Estimate Screen",
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 15),
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
      bottomSheet: BottomSheet(
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * newVH,
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
                Text(
                  'Destination Location',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Estimated price',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        '\u{20A6}700.00',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Estimated time',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        '10 mins',
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
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.all(20),
                            fixedSize: Size.fromWidth(
                                MediaQuery.of(context).size.width * .9)),
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: RivaTheme.whiteText.headline5),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.all(20),
                            fixedSize: Size.fromWidth(
                                MediaQuery.of(context).size.width * .9)),
                        onPressed: () async {
                          Loader(
                            context,
                            "Waiting for Drivers",
                          );
                          await Future.delayed(
                              const Duration(seconds: 10), () {});
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(requestPickup);
                        },
                        child: Text(
                          'Continue',
                          style: RivaTheme.whiteText.headline5,
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
