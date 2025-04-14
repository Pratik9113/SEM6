import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FuelStationList extends StatefulWidget {
  const FuelStationList({super.key});

  @override
  State<FuelStationList> createState() => _FuelStationListState();
}

class _FuelStationListState extends State<FuelStationList> {
  List<dynamic> _fuelStations = [];
  bool _loading = true;
  String apiKey = dotenv.env['API_KEY']!;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString("fuel_stations");

    if (cachedData != null) {
      setState(() {
        _fuelStations = json.decode(cachedData);
        _loading = false;
      });
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permission denied");
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    _fetchNearbyFuelStations(position.latitude, position.longitude);
  }

  Future<void> _fetchNearbyFuelStations(double lat, double lon) async {
    String url =
        "https://api.tomtom.com/search/2/nearbySearch/.json?lat=$lat&lon=$lon&categorySet=7311&key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data");

      setState(() {
        _fuelStations = data["results"];
        _loading = false;
      });

      // Save response to cache
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("fuel_stations", json.encode(_fuelStations));
    } else {
      print("Error fetching fuel stations: ${response.statusCode}");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby Fuel Stations"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loading = true;
              });
              _getCurrentLocation();
            },
          )
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _fuelStations.isEmpty
              ? Center(child: Text("No fuel stations found"))
              : ListView.builder(
                  itemCount: _fuelStations.length,
                  itemBuilder: (context, index) {
                    var station = _fuelStations[index];
                    String name = station["poi"]["name"] ?? "Fuel Station";
                    String address =
                        station["address"]["freeformAddress"] ?? "No Address";

                    return Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(address),
                        leading:
                            Icon(Icons.local_gas_station, color: Colors.red),
                      ),
                    );
                  },
                ),
    );
  }
}
