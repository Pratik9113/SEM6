import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TrafficAlertScreen extends StatefulWidget {
  @override
  _TrafficAlertScreenState createState() => _TrafficAlertScreenState();
}

class _TrafficAlertScreenState extends State<TrafficAlertScreen> {
  List<dynamic> latestUpdates = [];
  bool isLoading = false;
  final String tomtomApiKey = dotenv.env['API_KEY']!;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString("traffic_alert");
    if (cachedData != null) {
      setState(() {
        latestUpdates = json.decode(cachedData);
        isLoading = false;
      });
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      fetchTrafficAlerts(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> fetchTrafficAlerts(double lat, double lon) async {
    setState(() {
      isLoading = true;
    });

    double latDiff = 0.1;
    double lonDiff = 0.1;
    String bbox =
        '${lon - lonDiff},${lat - latDiff},${lon + lonDiff},${lat + latDiff}';

    // String url = "https://api.tomtom.com/traffic/services/5/incidentDetails"
    //     "?key=$tomtomApiKey"
    //     "&bbox=$bbox"
    //     "&fields=%7Bincidents%7Btype,geometry%7Btype,coordinates%7D,properties%7Bid,iconCategory,magnitudeOfDelay,events%7Bdescription,code,iconCategory%7D,startTime,endTime,from,to,length,delay,roadNumbers,timeValidity,probabilityOfOccurrence,numberOfReports,lastReportTime,tmc%7BcountryCode,tableNumber,tableVersion,direction,points%7Blocation,offset%7D%7D%7D%7D%7D"
    //     "&language=en-GB"
    //     "&timeValidityFilter=present";

    String url =
        "https://api.tomtom.com/traffic/services/5/incidentDetails?key=$tomtomApiKey&bbox=$bbox&fields=%7Bincidents%7Btype,geometry%7Btype,coordinates%7D,properties%7Bid,iconCategory,magnitudeOfDelay,events%7Bdescription,code,iconCategory%7D,startTime,endTime,from,to,length,delay,roadNumbers,timeValidity,probabilityOfOccurrence,numberOfReports,lastReportTime,tmc%7BcountryCode,tableNumber,tableVersion,direction,points%7Blocation,offset%7D%7D%7D%7D%7D&language=en-GB&timeValidityFilter=present";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          latestUpdates = data['incidents'] ?? [];
          isLoading = false;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("traffic_alert", json.encode(latestUpdates));
      } else {
        print('Failed to load traffic data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching traffic alerts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🚦 Traffic Alerts'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        actions: [
          IconButton(
            onPressed: _getCurrentLocation,
            icon: Icon(Icons.refresh, size: 28, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : latestUpdates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50, color: Colors.red),
                      SizedBox(height: 10),
                      Text(
                        "No traffic alerts found.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: latestUpdates.length,
                  itemBuilder: (context, index) {
                    var incident = latestUpdates[index];

                    String startDest =
                        incident['properties']?['from'] ?? 'Unknown';
                    String endDest = incident['properties']?['to'] ?? 'Unknown';
                    int length =
                        (incident['properties']?['length'] as num?)?.toInt() ??
                            0;

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ListTile(
                        title:
                            Text("Traffic Alert from $startDest to $endDest"),
                        subtitle: Text("Length: $length meters"),
                        leading: Icon(Icons.warning_amber_outlined,
                            color: Colors.orange),
                      ),
                    );
                  },
                ),
    );
  }
}
