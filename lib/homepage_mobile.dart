import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_01/course_details_page.dart';
import 'package:job_portal_01/courses_page.dart';
import 'package:job_portal_01/create_page.dart';
import 'package:job_portal_01/internships_page.dart';
import 'package:job_portal_01/intership_details_page.dart';
import 'package:job_portal_01/jobs_page.dart';
import 'package:job_portal_01/signin_page.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePageMobile(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({super.key});
  @override
  HomePageMobileState createState() => HomePageMobileState();
}

class HomePageMobileState extends State<HomePageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 7,
          title: Text(
            "Job Hunt Portal",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.blue,
            child: ListView(
              children: [
                DrawerHeader(
                    child: Center(
                        child: Text(
                  "Job Portal",
                  style: TextStyle(fontSize: 35),
                ))),
                ListTile(
                    leading: Icon(Icons.book),
                    title: Text(
                      "Courses",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CoursesPage()));
                    }),
                ListTile(
                  leading: Icon(Icons.work),
                  title: Text(
                    "Jobs",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => JobsPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.school),
                  title: Text(
                    "Internships",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InternshipsPage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text(
                    "Add Jobs",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateFirestoreForm()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    // Navigate to login screen (replace '/login' with your actual route)
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SigninPage()));
                  },
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  height: 120,
                  child: Card(
                    elevation: 12,
                    shadowColor: Colors.black87,
                    color: Colors.lightBlue[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to Job Hunt Portal",
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Let’s help you land your dream career",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 250, maxWidth: double.infinity),
                  child: GridView.count(
                    shrinkWrap:
                        true, // Ensures GridView takes only the required height
                    // physics:
                    //     const NeverScrollableScrollPhysics(), // Prevents scrolling inside GridView
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1, // Number of columns
                    crossAxisSpacing: 10, // Space between columns
                    mainAxisSpacing: 10, // Space between rows
                    children: [
                      buildCourses(
                        "Master in-Demand\n Skills",
                        "Get certified and level up your career with 50% off on our\n services!",
                        "Know More",
                      ),
                      buildCourses(
                        "Web Development Workshop",
                        "Join our interactive workshop to become a professional web developer.",
                        "Register Now",
                      ),
                      buildCourses(
                          "Machine Learning Masterclass",
                          "Unlock the world of Machine Learning with our expert-led sessions.",
                          "Join Now")
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: 100, minWidth: double.infinity),
                  child: Card(
                    color: Colors.blue,
                    elevation: 10,
                    shadowColor: Colors.indigo.shade900,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Recommended For You",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Recommended Internships")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text("No data found"));
                            }

                            return ConstrainedBox(
                              constraints: const BoxConstraints(
                                  maxHeight: 250, minWidth: 100),
                              child: SizedBox(
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var courseData = snapshot.data!.docs[index]
                                        .data() as Map<String, dynamic>?;

                                    if (courseData == null) {
                                      return SizedBox
                                          .shrink(); // Handle null case
                                    }

                                    String title =
                                        courseData['title'] ?? "No Title";
                                    String description =
                                        courseData['company'] ?? "No Company";
                                    String location =
                                        courseData['location'] ?? "No Location";
                                    String salary =
                                        courseData['salary'] ?? "No salary";
                                    String duration =
                                        courseData['duration'] ?? "No duration";

                                    return Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.blue,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                width: double
                                                    .infinity, // Takes full available width
                                                child: Text(
                                                  " $description",
                                                  textAlign: TextAlign
                                                      .left, // Ensures left alignment
                                                ),
                                              ),
                                              Divider(thickness: 2),
                                              SizedBox(
                                                width: double
                                                    .infinity, // Takes full available width
                                                child: Row(
                                                  children: [
                                                    Icon(Icons
                                                        .location_on_outlined),
                                                    Text(location)
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: double
                                                    .infinity, // Takes full available width
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.local_atm_sharp),
                                                    Text(salary),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: double
                                                    .infinity, // Takes full available width
                                                child: Row(
                                                  children: [
                                                    Icon(Icons
                                                        .calendar_today_rounded),
                                                    Text(duration),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Add button functionality here
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InternshipDetailsPage(
                                                                  internship:
                                                                      courseData)));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.indigo.shade900,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Apply Now",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: 100, maxWidth: double.infinity),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Certification Courses For You",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Certification Courses for You")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text("No data found"));
                          }

                          return ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 250, minWidth: 100),
                            child: SizedBox(
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  var courseDataC = snapshot.data!.docs[index]
                                      .data() as Map<String, dynamic>?;

                                  if (courseDataC == null) {
                                    return SizedBox
                                        .shrink(); // Handle null case
                                  }

                                  String title =
                                      courseDataC['title'] ?? "No Title";
                                  String rating =
                                      courseDataC['rating'] ?? "No Description";
                                  String duration =
                                      courseDataC['duration'] ?? "No duration";
                                  String learners =
                                      courseDataC['learners'] ?? "0 Leranerd";

                                  return Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.blue,
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Divider(thickness: 2),
                                            SizedBox(
                                                width: double
                                                    .infinity, // Takes full available width
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    Text(
                                                      rating,
                                                      textAlign: TextAlign
                                                          .left, // Ensures left alignment
                                                    ),
                                                  ],
                                                )),
                                            SizedBox(
                                              width: double
                                                  .infinity, // Takes full available width
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person),
                                                  Text(learners),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: double
                                                  .infinity, // Takes full available width
                                              child: Row(
                                                children: [
                                                  Icon(Icons
                                                      .calendar_today_rounded),
                                                  Text(duration),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Add button functionality here
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseDetailsPage(
                                                                internship:
                                                                    courseDataC)));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.indigo.shade900,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "2025 Job Hunt Portal. Empowering innovations worldwide.\n",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "All Rights Reserved.",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildCourses(String text1, String text2, String text3) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 10,
        shadowColor: Colors.blue,
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text1,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900),
              textAlign: TextAlign.center,
            ),
            Text(
              text2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
