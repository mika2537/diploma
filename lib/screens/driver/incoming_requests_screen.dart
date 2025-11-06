import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// --- 🔧 CONFIGURATION ---
/// Replace with your actual backend base URL connected to MongoDB
const String baseUrl = "http://localhost:5050/api";

class IncomingRequests extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onBack;

  const IncomingRequests({
    Key? key,
    required this.user,
    required this.onBack,
  }) : super(key: key);

  @override
  State<IncomingRequests> createState() => _IncomingRequestsState();
}

class _IncomingRequestsState extends State<IncomingRequests> {
  List<Map<String, dynamic>> requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  /// --- 🧠 Fetch data from MongoDB backend ---
  Future<void> _loadRequests() async {
    setState(() => loading = true);
    try {
      final uri = Uri.parse("$baseUrl/driver/${widget.user['id']}/requests");
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          requests = List<Map<String, dynamic>>.from(data["requests"] ?? []);
        });
      } else {
        debugPrint("Failed to fetch requests: ${res.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error loading requests: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  /// --- ✅ Accept request ---
  Future<void> _handleAccept(String requestId) async {
    try {
      final uri = Uri.parse("$baseUrl/rides/$requestId/accept");
      final res = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"driverId": widget.user['id']}),
      );

      if (res.statusCode == 200) {
        _showSnack("Хүсэлт амжилттай зөвшөөрөгдлөө!");
        _loadRequests();
      } else {
        _showSnack("Алдаа гарлаа: ${res.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Accept error: $e");
    }
  }

  /// --- ❌ Reject request ---
  Future<void> _handleReject(String requestId) async {
    try {
      final uri = Uri.parse("$baseUrl/rides/$requestId/reject");
      final res = await http.put(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"driverId": widget.user['id']}),
      );

      if (res.statusCode == 200) {
        _showSnack("Хүсэлт татгалзагдлаа");
        _loadRequests();
      } else {
        _showSnack("Алдаа гарлаа: ${res.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Reject error: $e");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
          child: Column(
            children: [
              // --- Header ---
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Ирсэн хүсэлтүүд",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- Request List ---
              Expanded(
                child: loading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : requests.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.person,
                          size: 36, color: Colors.grey),
                    ),
                    SizedBox(height: 12),
                    Text("Одоогоор шинэ хүсэлт байхгүй байна",
                        style: TextStyle(color: Colors.grey)),
                  ],
                )
                    : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, i) {
                    final req = requests[i];
                    return RequestCard(
                      request: req,
                      onAccept: () => _handleAccept(req["_id"]),
                      onReject: () => _handleReject(req["_id"]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- 🎴 Request Card ---
class RequestCard extends StatefulWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestCard({
    Key? key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  double _swipeX = 0;

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _swipeX += d.delta.dx);
  }

  void _onPanEnd(DragEndDetails d) {
    if (_swipeX > 100) {
      widget.onAccept();
    } else if (_swipeX < -100) {
      widget.onReject();
    }
    setState(() => _swipeX = 0);
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      transform: Matrix4.translationValues(_swipeX, 0, 0),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Passenger Info
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    r["passengerName"] ?? "Зорчигч",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${r["fare"] ?? "5000"}₮",
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600)),
                    const Text("Тооцоолсон үнэ",
                        style:
                        TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),

            // Pickup Info
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Авах цэг",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        Text(
                          r["pickupPoint"] ?? "Баянзүрх дүүрэг, 3-р хороо",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onReject,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text("Татгалзах",
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text("Зөвшөөрөх"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            const Text(
              "← Шудрах эсвэл зөвшөөрөх →",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}