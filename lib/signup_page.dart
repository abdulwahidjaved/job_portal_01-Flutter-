import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_01/main_page.dart';
import 'package:job_portal_01/signin_page.dart';

void main() {
  runApp(const SignupPage());
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  bool isPassword = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1200) {
          //Laptop
          return credenTial(0.4);
        } else if (constraints.maxWidth > 800) {
          //Tablet
          return credenTial(0.7);
        } else {
          //Mobile
          return credenTial(0.8);
        }
      }),
    );
  }

  Widget credenTial(double mainWidth) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.1,
          minWidth: MediaQuery.of(context).size.width * mainWidth,
        ),
        child: Card(
          elevation: 30,
          shadowColor: Colors.deepPurple,
          child: SingleChildScrollView(child: 
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SignupPage",
                  style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                SizedBox(height: 20),
                //Username
                SizedBox(
                  width: MediaQuery.of(context).size.width * mainWidth,
                  child: TextField(
                    controller: userController,
                    decoration: InputDecoration(
                      hintText: "Enter username",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //Email
                SizedBox(
                  width: MediaQuery.of(context).size.width * mainWidth,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //Password
                SizedBox(
                  width: MediaQuery.of(context).size.width * mainWidth,
                  child: TextField(
                    controller: passwordController,
                    obscureText: !isPassword,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Enter password",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            },
                            icon: Icon(
                              isPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue,
                            ))),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * mainWidth - 50,
                  child: ElevatedButton(
                      onPressed: () {
                        joinAccount();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 30,
                          shadowColor: Colors.black,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SigninPage()));
                  },
                  child: Text(
                    "Already have an account ? Click here",
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  void joinAccount() async {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String username = userController.text.toString().trim();

    if (email == "" || password == "" || username == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the fields")));
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Signup Successful")));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
        emailController.clear();
        passwordController.clear();
        userController.clear();
      } on FirebaseAuthException catch (ex) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(ex.toString())));
      }
    }
  }
}
