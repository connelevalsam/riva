import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'provider.dart';

class PlacesHelper {
  final apiKey = "";
  void onError(PlacesAutocompleteResponse response) {
    print("*********Error - ");
    print(response.errorMessage);
  }

  Future handlePressButton(BuildContext context, int i) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "ng",
      language: "en",
      context: context,
      apiKey: apiKey,
      types: [],
      hint: "Search City",
      onError: onError,
      mode: Mode.overlay,
      logo: const Text(""),
      components: [Component(Component.country, "ng")],
    );

    displayPrediction(p, i, context);
  }

  Future displayPrediction(Prediction? p, int i, BuildContext context) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      var appData = Provider.of<AppData>(context, listen: false);

      if (i == 0) {
        print('---------------Place id - {${p.placeId} -----------------');
        PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(p.placeId!);
        final lat = detail.result.geometry!.location.lat;
        final lng = detail.result.geometry!.location.lng;
        // set latitude and longitude of current location
        appData.setCurrentLocation(lat, lng);
        // get address of current location
        appData.setAddress(p.description!, p.placeId!, 0);
        // return p.description;
      } else if (i == 1) {
        print(
            '---------------destination id - {${p.placeId} -----------------');
        PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(p.placeId!);
        final lat = detail.result.geometry!.location.lat;
        final lng = detail.result.geometry!.location.lng;

        // set latitude and longitude of destination location
        appData.setDestinationLocation(lat, lng);
        // get address of destination location
        appData.setAddress(p.description!, p.placeId!, 1);
        // return p.description;
      }
    }
  }

  Future getSetAdr(BuildContext context, int id) async {
    var appData = Provider.of<AppData>(context, listen: false);
    if (id == 0) {
      print("============= current adr - ${appData.currentAddress}\n===");
      return await appData.currentAddress;
    } else {
      print(
          "============= destination adr - ${appData.destinationAddress}\n===");
      return await appData.destinationAddress;
    }
  }

  static Future<dynamic> getRequest(String url) async {
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  initAddress(BuildContext context) async {
    var appData = Provider.of<AppData>(context, listen: false);
    double lat = appData.currentLatitude;
    double lng = appData.currentLongitude;

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    var response = await getRequest(url);
    if (response != 'failed') {
      print("======Response\n ${response['results']} ======\n");
      var placeAddress = response['results'][0]['formatted_address'];
      List<Placemark> addresses = await placemarkFromCoordinates(lat, lng);
      print("======Response 2\n ${addresses.first.street} ======\n");
      appData.setAddress(
          addresses.first.street!, addresses.first.isoCountryCode!, 0);
    }
  }
}
