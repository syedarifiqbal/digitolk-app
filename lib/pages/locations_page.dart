import 'dart:convert';

import 'package:digitolk_test/core/api_constants.dart';
import 'package:digitolk_test/core/helper.dart';
import 'package:digitolk_test/core/storage.dart';
import 'package:digitolk_test/core/toastr.dart';
import 'package:digitolk_test/models/location.dart';
import 'package:digitolk_test/models/user.dart';
import 'package:digitolk_test/services/auth_service.dart';
import 'package:digitolk_test/services/location_service.dart';
import 'package:digitolk_test/services/location_service.dart';
import 'package:digitolk_test/services/location_service.dart';
import 'package:digitolk_test/services/task_service.dart';
import 'package:digitolk_test/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pusher_client/pusher_client.dart';

class LocationsPage extends StatefulWidget {
  static const String name = "Location";

  const LocationsPage({Key? key}) : super(key: key);

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

enum _PositionItemType {
  log,
  position,
}

class _LocationsPageState extends State<LocationsPage>
    with TickerProviderStateMixin {
  late var responseData;
  bool allLoaded = false;
  bool more = false;
  ScrollController _scrollController = ScrollController();
  String location = "";
  String lat = "";
  String lng = "";

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    LocationService.fetch().then((locationData) {
      responseData = locationData;
      setLocation(locationData);
      _getCurrentPosition();
    });
  }

  List<Location> locations = <Location>[];
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Location",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await _getCurrentPosition();
                        await LocationService.create(
                            location: location, lat: lat, lng: lng);

                        setState(() => loading = true);
                        responseData = await LocationService.fetch();
                        setLocation(responseData);
                      } catch (e) {
                        setState(() => loading = false);
                        print(e.toString());
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        Text(
                          "Add Location",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Current Location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                locations.length > 1
                    ? locationRow(locations.first)
                    : Center(
                        child: Text(this.location != ""
                            ? this.location
                            : "fetching location..."),
                      ),
                SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Previous Locations",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: _build_locations_list(),
                ),
              ],
            ),
    );
  }

  Widget locationRow(Location location) {
    if (location.id == 0) {
      return const ListTile(
        title: Text('Loading...'),
      );
    }
    return Slidable(
      key: ValueKey(location.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async {
            setState(() => loading = true);
            String message = await LocationService.deleteLocation(location.id);
            locations.removeWhere((element) => element.id == location.id);
            setState(() => loading = false);
            Toastr(message: message).show();
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) async {
              setState(() => loading = true);
              String message =
                  await LocationService.deleteLocation(location.id);
              locations.removeWhere((element) => element.id == location.id);
              setState(() => loading = false);
              Toastr(message: message).show();
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              setState(() => loading = true);
              // await _getCurrentPosition();

              String message = await LocationService.editLocation(
                id: location.id,
                lat: lat,
                lng: lng,
                location: this.location,
              );
              locations[locations
                      .indexWhere((element) => element.id == location.id)]
                  .location = this.location;
              setState(() => loading = false);
              Toastr(message: message).show();
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Update Current Location',
            // icon: CupertinoIcons.delete,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 25),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 7,
            ),
            Icon(
              CupertinoIcons.map_pin,
              color: Colors.red,
            ),
          ],
        ),
        minLeadingWidth: 15,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location.location),
            const SizedBox(
              height: 3,
            ),
            Text(
              "${location.lat} N, ${location.lng} E",
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  ListView _build_locations_list() {
    return ListView(
      controller: _scrollController,
      children: locations.map(
        (task) {
          return locationRow(task);
        },
      ).toList(),
    );
  }

  void setLocation(locationData) {
    var data = locationData['data'] as List<dynamic>;

    if (locationData['current_page'] == locationData['last_page']) {
      allLoaded = true;
    }

    locations.removeWhere((element) => element.id == 0);

    data.forEach((element) {
      locations.add(
        Location(
          id: element['id'],
          location: element['location'],
          lat: element['lat'],
          lng: element['lng'],
          createdAt: element['created_at'],
          updatedAt: element['updated_at'],
          ownerId: element['owner_id'].toString(),
          date: element['date'],
          time: element['time'],
        ),
      );
    });
    more = false;
    setState(() => loading = false);
  }

  void _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reached to bottom;
      if (allLoaded || more) return;

      more = true;
      setState(
        () => locations.add(
          Location(
            id: 0,
            location: "",
            ownerId: "",
            lat: "",
            lng: "",
            date: "",
            time: "",
            createdAt: "",
            updatedAt: "",
          ),
        ),
      );

      int page = (responseData['current_page']) + 1;
      responseData = await LocationService.fetch(page: page.toString());
      setLocation(responseData);
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reached to top;
    }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      Toastr(message: "Permission not granted").show();
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    // var coordinates = Coordinates(position.latitude, position.longitude);
    // print(Geocoder.local.findAddressesFromCoordinates(coordinates));
    lat = position.latitude.toString();
    lng = position.longitude.toString();

    setState(() => loading = true);
    location = await LocationService.getAddress(lat: lat, lng: lng);
    setState(() => loading = false);
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toastr(message: "Please enable your location").show();
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    // _positionItems.add(_PositionItem(type, displayValue));
    // setState(() {});
  }
}
