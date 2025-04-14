import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:questit/category/video_card.dart';
import 'package:questit/pages/fuel/fuel_station_list.dart';
import 'package:questit/pages/hospital/hospital_page.dart';
import 'package:questit/pages/chat/chat_page.dart';
import 'package:questit/pages/trafficalert/traffic_alert_screen.dart';
import 'package:questit/pages/weather/weather_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:questit/category/category_page.dart';
import 'package:questit/category/suggested_videos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeSectionPage extends StatefulWidget {
  const HomeSectionPage({super.key});

  @override
  _HomeSectionPageState createState() => _HomeSectionPageState();
}

class _HomeSectionPageState extends State<HomeSectionPage> {
  final String tomtomApiKey = dotenv.env['API_KEY']!;

  final bool display = false;
  List<String> latestUpdates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrafficAlerts();
  }

  Future<void> fetchTrafficAlerts() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lon = position.longitude;

      double latDiff = 0.1;
      double lonDiff = 0.1;
      String bbox =
          '${lon - lonDiff},${lat - latDiff},${lon + lonDiff},${lat + latDiff}';

      String url =
          "https://api.tomtom.com/traffic/services/5/incidentDetails?key=$tomtomApiKey&bbox=$bbox&fields=%7Bincidents%7Btype,geometry%7Btype,coordinates%7D,properties%7Bid,iconCategory,magnitudeOfDelay,events%7Bdescription,code,iconCategory%7D,startTime,endTime,from,to,length,delay,roadNumbers,timeValidity,probabilityOfOccurrence,numberOfReports,lastReportTime,tmc%7BcountryCode,tableNumber,tableVersion,direction,points%7Blocation,offset%7D%7D%7D%7D%7D&language=en-GB&timeValidityFilter=present";
      print('Fetching traffic alerts from: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List incidents = data['incidents'] ?? [];
        setState(() {
          latestUpdates = incidents.map<String>((incident) {
            final String startDest =
                incident['properties']?['from'] ?? 'Unknown';
            final String endDest = incident['properties']?['to'] ?? 'Unknown';
            final int length =
                (incident['properties']?['length'] as num?)?.toInt() ?? 0;

            return 'Construction work between $startDest and $endDest is currently active. '
                'The affected road section is approximately $length meters long.';
          }).toList();

          isLoading = false;
        });
      } else {
        print('Failed to load traffic data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching traffic alerts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Traffic Alerts',
        'icon': Icons.traffic,
        'color': Colors.red,
        'route': TrafficAlertScreen(),
      },
      {
        'title': 'Weather Updates',
        'icon': Icons.wb_sunny,
        'color': Colors.orange,
        'route': WeatherScreen(),
      },
      // {'title': 'Navigation','icon': Icons.map,'color': Colors.blue},
      {
        'title': 'Fuel Stations',
        'icon': Icons.local_gas_station,
        'color': Colors.green,
        'route': FuelStationList(),
      },

      {
        'title': 'Emergency',
        'icon': Icons.local_hospital,
        'color': Colors.pink,
        'route': HospitalPage(),
      },
      {
        'title': 'ChatBot',
        'icon': Icons.local_hospital,
        'color': Colors.deepPurple,
        'route': ChatScreen(),
      },
    ];

    final List<Map<String, String>> videos = [
      {
        'title': 'Traffic Updates',
        'description': 'Stay updated with real-time traffic alerts.',
        'videoUrl':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      },
      {
        'title': 'Weather Forecast',
        'description': 'Get accurate weather predictions for your region.',
        'videoUrl':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      },
      {
        'title': 'Fuel Stations Nearby',
        'description': 'Find the nearest fuel stations with ease.',
        'videoUrl':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      },
    ];

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 218, 234),
      appBar: AppBar(
        title: const Text(
          '🚛 Truck Map',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
            onPressed: fetchTrafficAlerts,
            icon: const Icon(Icons.refresh, size: 28, color: Colors.white),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          _buildLatestUpdateCard(isDarkMode),
          const SizedBox(height: 20),

          // Categories Section
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: categories
                .map(
                  (category) => GestureDetector(
                    onTap: () {
                      if (category.containsKey('route')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => category['route'],
                          ),
                        );
                      }
                    },
                    child: CategoryPage(
                      title: category['title'],
                      icon: category['icon'],
                      color: category['color'],
                    ),
                  ),
                )
                .toList(),
          ),
          // Suggested Videos
          const SizedBox(height: 20),
          Text(
            "Essential Driving Tutorials: Videos You Must Watch for Safe Driving!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: videos
                .map((video) => VideoCard(
                      title: video['title']!,
                      description: video['description']!,
                      videoUrl: video['videoUrl']!,
                    ))
                .toList(),
          ),

          SuggestedVideos(
            title: 'Rules and Regulations',
            description:
                'Drive safely with real-time traffic alerts and navigation.',
            icon: Icons.local_police,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLatestUpdateCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.deepPurple[700]!, Colors.indigo[800]!]
              : [Colors.white, Colors.blueGrey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📢 LATEST UPDATE',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 10),
          if (isLoading)
            _buildShimmerEffect()
          else if (latestUpdates.isEmpty)
            const Text(
              '🚦 No traffic alerts available',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            )
          else
            Column(
              children: latestUpdates.take(3).map((update) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      const Icon(Icons.warning,
                          color: Colors.orangeAccent, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          update,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
