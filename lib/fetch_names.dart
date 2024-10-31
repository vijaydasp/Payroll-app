import 'package:flutter/material.dart';
import 'package:payroll/API/api_fetch_names.dart';
import 'package:payroll/API/api_login.dart';
import 'package:payroll/location_page_admin.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  List<Map<String, dynamic>> nameList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool isLoading = true;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNames();
    searchController.addListener(_filterNames);
  }

  void fetchNames() async {
    try {
      nameList = await getNames();
      setState(() {
        nameList.sort(
            (a, b) => a['name'].compareTo(b['name'])); // Sort alphabetically
        filteredList = List.from(nameList); // Initialize filtered list
        isLoading = false;
        hasError = nameList.isEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _filterNames() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = nameList.where((employee) {
        return employee['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imagePath),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(50.0), // Increased height to add space
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the search bar
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      hintStyle:
                          TextStyle(color: Colors.grey[600]), // Hint text color
                      border: InputBorder.none, // Remove border
                      contentPadding: EdgeInsets.all(10.0),
                      prefixIcon: Icon(Icons.search,
                          color: Colors.blueGrey), // Search icon color
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0), // Space below the search bar
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade100,
              const Color.fromARGB(255, 70, 168, 216)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
                ? const Center(
                    child: Text('Error fetching names.',
                        style: TextStyle(color: Colors.red, fontSize: 16)))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> details = filteredList[index];
                      String imagePath = '$baseurl/${details['imagePath']}';
                      String name = details['name'];
                      String email = details['email'];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationPage(email: email),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showImageDialog(imagePath);
                                  },
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(imagePath),
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
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
