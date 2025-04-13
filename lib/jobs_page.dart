import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_01/job_details_page.dart';

void main() {
  runApp(const JobsPage());
}

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});
  @override
  JobsPageState createState() => JobsPageState();
}

class JobsPageState extends State<JobsPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> jobs = [];
  List<Map<String, dynamic>> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs(); // Fetch job data on start
  }

  // 🔥 Fetch jobs data from Firestore once
  Future<void> fetchJobs() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Jobs").get();

      List<Map<String, dynamic>> dataList = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        jobs = dataList;
        filteredJobs = dataList; // Initialize with all jobs
      });
    } catch (e) {
      print("Error fetching jobs: $e");
    }
  }

  // 🔍 Search function (filters locally)
  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredJobs = jobs;
      } else {
        filteredJobs = jobs
            .where((job) =>
                job['title']?.toLowerCase().contains(query.toLowerCase()) ??
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
          "Jobs",
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
                          prefixIcon: Icon(Icons.work, color: Colors.indigo),
                          hintText: "Search for jobs...",
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
              "Latest Job Openings for Professionals",
              style: TextStyle(
                  color: Colors.indigo.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(height: 30),

            // ✅ Show jobs without flickering
            filteredJobs.isEmpty
                ? Center(child: Text("No jobs found"))
                : GridView.builder(
                    itemCount: filteredJobs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var job = filteredJobs[index];

                      return Card(
                        elevation: 7,
                        shadowColor: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              job['title'] ?? "No title",
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
                                      Text(job['location'] ?? "No location"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_rounded,
                                          color: Colors.blue),
                                      Text(job['duration'] ?? "No duration"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.local_atm,
                                          color: Colors.green),
                                      Text(job['salary'] ?? "No salary"),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  JobDetailsPage(
                                                      jobData: job)));
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
