import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CommonRepository {
  static Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } else {
      // ignore: deprecated_member_use
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position =
            // ignore: deprecated_member_use
            await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
        return position;
      } else {
        return Future.error('Location permissions are denied');
      }
    }
  }

  static Future<Position> getStoragePermission() async {
    // ignore: deprecated_member_use
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position =
          // ignore: deprecated_member_use
          await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
      return position;
    } else {
      // ignore: deprecated_member_use
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position =
            // ignore: deprecated_member_use
            await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
        return position;
      } else {
        return Future.error('Location permissions are denied');
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future getAddressFromLatLong(latitude, longitude) async {
    if (latitude != null && longitude != null) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];

log('===place=== ${place}');
        return '${place.locality}, ${place.administrativeArea},${place.country}';
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  Future getCountyCodeFromLatLong(latitude, longitude) async {
    if (latitude != null && longitude != null) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks[0];
        log('===getCountyCodeFromLatLong=== ${place.isoCountryCode}');
        return '${place.isoCountryCode}';
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }
}
