import 'package:flutter/material.dart';
import 'package:job_portal_01/sender_page.dart';

void main() {
  runApp(const InternshipDetailsPage(
    internship: {},
  ));
}

class InternshipDetailsPage extends StatefulWidget {
  final Map<String, dynamic> internship;

  const InternshipDetailsPage({super.key, required this.internship});

  @override
  State<InternshipDetailsPage> createState() => _InternshipDetailsPageState();
}

class _InternshipDetailsPageState extends State<InternshipDetailsPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for contrast
      appBar: AppBar(
        title: Text(
          widget.internship['title'] ?? "Internship Details",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Container(
          width: isLargeScreen ? screenWidth * 0.6 : screenWidth * 0.9,
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Internship Title
                    Text(
                      widget.internship['title'] ?? "No Title",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Internship Details with Icons
                    infoRow(Icons.location_on, "Location",
                        widget.internship['location'] ?? "Not specified"),
                    infoRow(Icons.business, "Company",
                        widget.internship['company'] ?? "Not specified"),
                    infoRow(Icons.local_atm, "Salary",
                        widget.internship['salary'] ?? "Not specified"),
                    infoRow(Icons.access_time, "Duration",
                        widget.internship['duration'] ?? "Not specified"),
                    Divider(
                      thickness: 3,
                    ),
                    infoRow(Icons.info_rounded, "About Internship",
                        widget.internship['information'] ?? "No info"),
                    infoRow(Icons.analytics_outlined, "Required Skills",
                        widget.internship['Rskills'] ?? "No skills required"),
                    infoRow(Icons.person, "Number of Openings",
                        widget.internship['vacancy'] ?? "Hiring Stopped"),
                    infoRow(
                        Icons.calendar_today_rounded,
                        "Start Date",
                        widget.internship['start date'] ?? "Date expired"),
                    infoRow(
                        Icons.calendar_today_rounded,
                        "End Date",
                        widget.internship['end date'] ?? "Date expired"),

                    const SizedBox(height: 20),

                    // Apply Button
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply button logic
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SenderPage(
                                          sender: widget.internship,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.blueAccent,
                            shadowColor: Colors.blue.withOpacity(0.4),
                          ),
                          child: const Text(
                            "Apply Now",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom method for displaying internship details
  Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
