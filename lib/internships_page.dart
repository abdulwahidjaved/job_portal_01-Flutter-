import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_01/intership_details_page.dart';

void main() {
  runApp(const InternshipsPage());
}

class InternshipsPage extends StatefulWidget {
  const InternshipsPage({super.key});
  @override
  InternshipsPageState createState() => InternshipsPageState();
}

class InternshipsPageState extends State<InternshipsPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> internships = [];
  List<Map<String, dynamic>> filteredInternships = [];

  @override
  void initState() {
    super.initState();
    fetchInternships(); // Fetch data on start
  }

  // 🔥 Fetch data from Firestore once and store it
  Future<void> fetchInternships() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Internships").get();

      List<Map<String, dynamic>> dataList = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        internships = dataList;
        filteredInternships = dataList; // Initialize with all data
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // 🔍 Search function (filters locally)
  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredInternships = internships;
      } else {
        filteredInternships = internships
            .where((internship) =>
                internship['title']
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Internships",
          style: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 1200) {
            return fullScreen(0.6);
          } else if (constraints.maxWidth > 800) {
            return fullScreen(0.7);
          } else {
            return fullScreen(0.9);
          }
        },
      ),
    );
  }

  Widget fullScreen(double mainWidth) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔍 Search Box
            Container(
              width: MediaQuery.of(context).size.width * mainWidth,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 20,
                    color: Colors.blue.shade900)
              ]),
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) => filterSearch(value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.school, color: Colors.indigo),
                          hintText: "Search for internships...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        searchController.clear();
                        filterSearch("");
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
            Text(
              "Latest Remote & Offline Internships for Students",
              style: TextStyle(
                  color: Colors.indigo.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(height: 30),

            // ✅ Show data without flickering
            filteredInternships.isEmpty
                ? Center(child: Text("No internships found"))
                : GridView.builder(
                    itemCount: filteredInternships.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var internship = filteredInternships[index];

                      return Card(
                        elevation: 7,
                        shadowColor: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              internship['title'] ?? "No title",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.indigo),
                            ),
                            Divider(thickness: 2),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          color: Colors.red),
                                      Text(internship['location'] ??
                                          "No location"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_rounded,
                                          color: Colors.blue),
                                      Text(internship['duration'] ??
                                          "No duration"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.local_atm,
                                          color: Colors.green),
                                      Text(internship['salary'] ?? "No salary"),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InternshipDetailsPage(
                                                      internship: internship)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo.shade900,
                                    ),
                                    child: Text(
                                      "Apply Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
