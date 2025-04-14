import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPageVersion extends StatefulWidget {
  const MapPageVersion({super.key});

  @override
  State<MapPageVersion> createState() => _MapPageVersionState();
}

class _MapPageVersionState extends State<MapPageVersion> {
  LatLng? currentLocation;
  LatLng? searchedLocation;
  List<LatLng> routePoints = [];
  List<String> turnInstructions = [];
  List<Map<String, dynamic>> turnMarkers = [];

  final String apiKey = dotenv.env['API_KEY']!;
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _startLiveLocationTracking();
  }

  // Fetch User's Current Location
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Move Map to Current Location
    _mapController.move(currentLocation!, 13.0);
  }

  void _startLiveLocationTracking() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(currentLocation!, 15.0);
    });
  }

  // Fuzzy Search using TomTom API
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    final String url =
        "https://api.tomtom.com/search/2/search/$query.json?key=$apiKey&limit=5&countrySet=IN";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["results"].isNotEmpty) {
        setState(() {
          searchResults = data["results"]; // Store results for suggestions
        });
      }
    }
  }

  Future<void> _getRoute() async {
    if (currentLocation == null || searchedLocation == null) return;

    final String routeUrl =
        "https://api.tomtom.com/routing/1/calculateRoute/${currentLocation!.latitude},${currentLocation!.longitude}:${searchedLocation!.latitude},${searchedLocation!.longitude}/json?key=$apiKey&instructionsType=text";

    final response = await http.get(Uri.parse(routeUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<dynamic> points = data["routes"][0]["legs"][0]["points"];
      List<dynamic> instructions =
          data["routes"][0]["guidance"]["instructions"];

      setState(() {
        routePoints = points
            .map((point) => LatLng(point["latitude"], point["longitude"]))
            .toList();

        turnMarkers.clear();

        for (var inst in instructions) {
          LatLng location =
              LatLng(inst["point"]["latitude"], inst["point"]["longitude"]);
          String turnType = inst["maneuver"] ?? "straight";
          String spokenInstruction = inst["message"]; // Instruction text

          turnMarkers.add({"location": location, "turnType": turnType});

          flutterTts.speak(spokenInstruction);
        }
      });
    }
  }

  Icon _getTurnIcon(String turnType) {
    switch (turnType.toLowerCase()) {
      case "turn-right":
        return Icon(Icons.arrow_right_alt, color: Colors.green, size: 30);
      case "turn-left":
        return Icon(Icons.arrow_left, color: Colors.blue, size: 30);
      case "u-turn":
        return Icon(Icons.u_turn_left, color: Colors.orange, size: 30);
      case "straight":
        return Icon(Icons.arrow_upward, color: Colors.grey, size: 30);
      case "roundabout":
        return Icon(Icons.sync, color: Colors.purple, size: 30);
      default:
        return Icon(Icons.circle, color: Colors.black, size: 20);
    }
  }

  // Move Map to Selected Location
  void _moveToLocation(double lat, double lon) {
    setState(() {
      searchedLocation = LatLng(lat, lon);
      searchResults = []; // Hide search results
      _searchController.clear(); // Clear search bar
    });

    _mapController.move(searchedLocation!, 13.0);
    _getRoute();
  }

  void _speakInstructions() async {
    for (String instruction in turnInstructions) {
      await flutterTts.speak(instruction);
      await Future.delayed(
          const Duration(seconds: 5)); // Wait before next instruction
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TomTom Map with Fuzzy Search"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _searchLocation,
                  decoration: InputDecoration(
                    hintText: "Enter a location...",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _searchLocation(_searchController.text);
                        }
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                // 📌 Search Results List
                if (searchResults.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        var result = searchResults[index];
                        return ListTile(
                          title: Text(result['address']['freeformAddress']),
                          onTap: () {
                            double lat = result['position']['lat'];
                            double lon = result['position']['lon'];
                            _moveToLocation(lat, lon);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // 📍 Map Section
          Expanded(
            child: currentLocation == null
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading while fetching location
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: currentLocation!,
                      initialZoom: 13.0,
                    ),
                    children: [
                      // 🗺️ Tile Layer
                      TileLayer(
                        urlTemplate:
                            "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey",
                        userAgentPackageName: 'com.example.app',
                      ),
                      TileLayer(
                        urlTemplate:
                            "https://api.tomtom.com/traffic/map/4/tile/flow/relative0/{z}/{x}/{y}.png?key=$apiKey",
                        userAgentPackageName:
                            'net.tlserver6y.flutter_map_location_marker.example',
                        maxZoom: 19,
                      ),
                      TileLayer(
                        urlTemplate:
                            "https://api.tomtom.com/traffic/map/4/tile/incidents/s1/{z}/{x}/{y}.png?key=$apiKey",
                        userAgentPackageName:
                            'net.tlserver6y.flutter_map_location_marker.example',
                        maxZoom: 19,
                      ),

                      // 📍 Marker Layer
                      MarkerLayer(
                        markers: [
                          // Current Location Marker
                          Marker(
                            width: 50.0,
                            height: 50.0,
                            point: currentLocation!,
                            child: Icon(Icons.location_pin,
                                color: Colors.blue, size: 40),
                          ),
                          // Searched Location Marker
                          if (searchedLocation != null)
                            Marker(
                              width: 50.0,
                              height: 50.0,
                              point: searchedLocation!,
                              child: Icon(Icons.location_pin,
                                  color: Colors.red, size: 40),
                            ),
                          ...turnMarkers.map((turn) => Marker(
                                width: 30.0,
                                height: 30.0,
                                point: turn["location"],
                                child: _getTurnIcon(turn["turnType"]),
                              )),
                        ],
                      ),
                      if (routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              color: Colors.blue,
                              strokeWidth: 5.0,
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
          ElevatedButton(
            onPressed: _speakInstructions,
            child: const Text("Start Navigation"),
          ),
        ],
      ),
    );
  }
}
