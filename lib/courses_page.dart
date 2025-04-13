import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_01/course_details_page.dart';

void main() {
  runApp(const CoursesPage());
}

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});
  @override
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<QueryDocumentSnapshot> allCourses = [];
  List<QueryDocumentSnapshot> filteredCourses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Courses").get();
    setState(() {
      allCourses = querySnapshot.docs;
      filteredCourses = allCourses;
    });
  }

  void filterCourses(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredCourses = allCourses.where((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return data['title']
                ?.toString()
                .toLowerCase()
                .contains(searchQuery) ??
            false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Certified Courses",
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
        }));
  }

  Widget fullScreen(double mainWidth) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                      onChanged: (value) {
                        filterCourses(value);
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.school,
                          color: Colors.indigo,
                        ),
                        hintText: "Search for courses....",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                ],
              )),
            ),
            SizedBox(height: 30),
            Text(
              "Latest Certified Courses for Students",
              style: TextStyle(
                  color: Colors.indigo.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(height: 30),
            filteredCourses.isEmpty
                ? Center(child: Text("No data found"))
                : GridView.builder(
                    itemCount: filteredCourses.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var courseData =
                          filteredCourses[index].data() as Map<String, dynamic>?;

                      if (courseData == null) {
                        return SizedBox.shrink();
                      }

                      return Card(
                        elevation: 7,
                        shadowColor: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              courseData['title'] ?? "No title",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.indigo),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.red,
                                      ),
                                      Text(courseData['location'] ??
                                          "No location"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.blue,
                                      ),
                                      Text(courseData['duration'] ??
                                          "No duration"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_atm,
                                        color: Colors.green,
                                      ),
                                      Text(courseData['fees'] ?? "No fees"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CourseDetailsPage(
                                                        internship:
                                                            courseData)));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.indigo.shade900,
                                      ),
                                      child: Text(
                                        "View",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
