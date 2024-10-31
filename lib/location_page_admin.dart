import 'package:flutter/material.dart';
import 'package:payroll/API/api_location_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.email});
  final String email;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<Map<String, dynamic>> locationList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    check();
    searchController.addListener(_filterByDate);
  }

  void check() async {
    locationList = await getLocation(widget.email);
    setState(() {
      filteredList = List.from(locationList); // Initialize filtered list
    });
  }

  void _filterByDate() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = locationList.where((location) {
        bool matchesDate = true;
        if (selectedDate != null) {
          DateTime locationDate = DateTime.parse(location['date']);
          matchesDate = locationDate.year == selectedDate!.year &&
              locationDate.month == selectedDate!.month &&
              locationDate.day == selectedDate!.day;
        }
        return location['date'].toLowerCase().contains(query) && matchesDate;
      }).toList();

      // Sort the list by date in ascending order
      filteredList.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });
    });
  }

  Future<void> _openMap(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _filterByDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 20), // Calendar icon
                      SizedBox(width: 8), // Space between icon and text
                      Text(
                        selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(10.0),
        child: filteredList.isEmpty
            ? const Center(child: Text('No locations found.'))
            : ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> details = filteredList[index];
                  return InkWell(
                    onTap: () {
                      double latitude = double.parse(details['latitude']);
                      double longitude = double.parse(details['longitude']);
                      _openMap(latitude, longitude);
                    },
                    child: Card(
                      color: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 20, color: Colors.blueGrey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Date: ${details['date']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 20, color: Colors.blueGrey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Time: ${details['time']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 20, color: Colors.blueGrey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Location: ${details['latitude']},${details['longitude']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
