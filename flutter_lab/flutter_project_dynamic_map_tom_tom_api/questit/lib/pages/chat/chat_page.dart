import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  final String groqApiKey = dotenv.env['GROQ_API']!;

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "text": userMessage});
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (userMessage.toLowerCase().contains("fuel station")) {
      String? cachedData = prefs.getString("fuel_stations");

      if (cachedData != null) {
        List<dynamic> fuelStations = json.decode(cachedData);
        if (fuelStations.isNotEmpty) {
          String responseText = "Here are nearby fuel stations:\n";

          for (var station in fuelStations.take(3)) {
            String name = station["poi"]?["name"] ?? "Fuel Station";
            String address =
                station["address"]?["freeformAddress"] ?? "No Address";
            responseText += "🔹 $name - $address\n";
          }

          setState(() {
            messages.add({"role": "bot", "text": responseText});
          });
        } else {
          setState(() {
            messages.add(
                {"role": "bot", "text": "No fuel station data available."});
          });
        }
        return;
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "text":
                "I don't have fuel station data right now. Please refresh the fuel station list first."
          });
        });
        return;
      }
    }

    if (userMessage.toLowerCase().contains("traffic alert")) {
      String? trafficAlert = prefs.getString("traffic_alert");

      if (trafficAlert != null && trafficAlert.isNotEmpty) {
        List<dynamic> alertList = json.decode(trafficAlert);
        if (alertList.isNotEmpty) {
          String responseText = "🚦 **Traffic Alerts:**\n\n";

          for (var alert in alertList.take(3)) {
            // Limit to 3 alerts for readability
            String from = alert["properties"]?["from"] ?? "Unknown Location";
            String to = alert["properties"]?["to"] ?? "Unknown Location";
            String magnitude =
                alert["properties"]?["magnitudeOfDelay"]?.toString() ?? "N/A";
            String event = alert["properties"]?["events"]?[0]?["description"] ??
                "No event details";
            String startTime =
                alert["properties"]?["startTime"] ?? "Unknown time";
            String endTime = alert["properties"]?["endTime"] ?? "Unknown time";

            responseText +=
                "📍 From: $from\n➡️ To: $to\n⏳ Delay: $magnitude min\n🚧 Status: $event\n🕒 Start: $startTime\n🛑 End: $endTime\n\n";
          }

          setState(() {
            messages.add({"role": "bot", "text": responseText});
          });
        } else {
          setState(() {
            messages.add({
              "role": "bot",
              "text": "No traffic alerts available at the moment."
            });
          });
        }
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "text":
                "No traffic alert data found. Please refresh the traffic information."
          });
        });
      }
      return;
    }

    if (userMessage.toLowerCase().contains("hospital")) {
      String? hospitalData = prefs.getString("hospital");

      if (hospitalData != null && hospitalData.isNotEmpty) {
        List<dynamic> hospitalList = json.decode(hospitalData);
        if (hospitalList.isNotEmpty) {
          String responseText = "🏥 **Nearby Hospitals:**\n\n";

          for (var hospital in hospitalList.take(3)) {
            String name = hospital["poi"]?["name"] ?? "Unknown Hospital";
            String phone = hospital["poi"]?["phone"] ?? "No phone available";
            String address = hospital["address"]?["freeformAddress"] ??
                "No address available";
            double lat = hospital["position"]?["lat"] ?? 0.0;
            double lon = hospital["position"]?["lon"] ?? 0.0;

            responseText +=
                "🔹 $name**\n📍 $address\n📞 $phone\n🌍 [View on Map](https://www.google.com/maps/search/?api=1&query=$lat,$lon)\n\n";
          }

          setState(() {
            messages.add({"role": "bot", "text": responseText});
          });
        } else {
          setState(() {
            messages
                .add({"role": "bot", "text": "No hospital details available."});
          });
        }
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "text": "No hospital data found. Please refresh the hospital list."
          });
        });
      }
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $groqApiKey",
        },
        body: jsonEncode({
          "model": "mixtral-8x7b-32768",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an expert in truck safety and driving guidance."
            },
            {"role": "user", "content": userMessage}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data["choices"][0]["message"]["content"];

        setState(() {
          messages.add({"role": "bot", "text": botResponse});
        });
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "text": "Error fetching response. Please try again."
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({
          "role": "bot",
          "text": "Network error. Please check your internet connection."
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Truck Safety Chatbot"),
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
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["role"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg["role"] == "user"
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["text"]!,
                        style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask about truck safety...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
