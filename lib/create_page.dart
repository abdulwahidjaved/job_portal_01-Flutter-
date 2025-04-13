import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main()
{
  runApp(const UpdateFirestoreForm());
}

class UpdateFirestoreForm extends StatefulWidget {
  const UpdateFirestoreForm({super.key});

  @override
  UpdateFirestoreFormState createState() => UpdateFirestoreFormState();
}

class UpdateFirestoreFormState extends State<UpdateFirestoreForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController docIdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController informationController = TextEditingController();
  TextEditingController rskillsController = TextEditingController();
  TextEditingController vacancyController = TextEditingController();
  TextEditingController learnersController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String selectedCollection = "Jobs";

  List<String> collections = [
    "Jobs",
    "Courses",
    "Internships",
    "Certification Courses for You",
    "Recommended Internships"
  ];

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  void _updateFirestore() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection(selectedCollection)
          .doc(docIdController.text)
          .set({
        "title": titleController.text,
        "location": locationController.text,
        "company": companyController.text,
        "salary": salaryController.text,
        "fees": feesController.text,
        "duration": durationController.text,
        "information": informationController.text,
        "Rskills": rskillsController.text,
        "vacancy": vacancyController.text,
        "learners": learnersController.text,
        "email": emailController.text,
        "start date": startDate?.toIso8601String() ?? "",
        "end date": endDate?.toIso8601String() ?? "",
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Data successfully updated!")),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: $error")),
        );
      });
    }
  }

  Widget buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Job"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 8,
              shadowColor: Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildTextField(docIdController, "Document ID", Icons.document_scanner),
                    buildTextField(titleController, "Title", Icons.title),
                    buildTextField(locationController, "Location", Icons.location_on),
                    buildTextField(companyController, "Company", Icons.business),
                    buildTextField(salaryController, "Salary", Icons.money),
                    buildTextField(feesController, "Fees", Icons.payment),
                    buildTextField(durationController, "Duration", Icons.timer),
                    buildTextField(informationController, "Information", Icons.info),
                    buildTextField(rskillsController, "Required Skills", Icons.build),
                    buildTextField(vacancyController, "Vacancy", Icons.group),
                    buildTextField(learnersController, "Learners", Icons.people),
                    buildTextField(emailController, "Email", Icons.email),

                    ListTile(
                      title: Text("Start Date: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : "Select Date"}"),
                      leading: Icon(Icons.date_range, color: Colors.deepPurple),
                      onTap: () => _pickDate(context, true),
                    ),
                    ListTile(
                      title: Text("End Date: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : "Select Date"}"),
                      leading: Icon(Icons.date_range, color: Colors.deepPurple),
                      onTap: () => _pickDate(context, false),
                    ),

                    DropdownButtonFormField(
                      value: selectedCollection,
                      items: collections.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCollection = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Select Collection",
                        prefixIcon: Icon(Icons.list),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateFirestore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade900,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text("Create", style: TextStyle(fontSize: 18, color: Colors.white)),
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
}
