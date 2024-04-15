// lib/ui/signup_option.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tataguid/ui/get_contacts.dart';
import 'package:tataguid/ui/post_contacts.dart';

import '../widgets/BuildTextfield.dart';

class SignupOptions extends StatefulWidget {
  const SignupOptions({Key? key}) : super(key: key);

  @override
  State<SignupOptions> createState() => _SignupOptionsState();
}

class _SignupOptionsState extends State<SignupOptions> {
  late bool _current;
  PageController _controller = PageController();

  final TextEditingController agencyNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _current = true; // Set default value for _current
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.all(10),
            child: PageView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select your role",
                      style: TextStyle(
                          fontSize: size.width * 0.09,
                          fontWeight: FontWeight.w700),
                    ),
                    // there you can lottie files or image as per your need
                    Image.asset("assets/images/tour.png"),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                _current ? HexColor("#6709eb") : Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: RadioListTile(
                        value: true,
                        groupValue: _current,
                        title: Text(
                          "User",
                          style: TextStyle(
                              color: _current
                                  ? HexColor("#6709eb")
                                  : Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _current = true;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: HexColor("#6709eb"),
                        secondary: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                !_current ? HexColor("#6709eb") : Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: RadioListTile(
                        value: false,
                        groupValue: _current,
                        title: Text(
                          "Agency",
                          style: TextStyle(
                              color: !_current
                                  ? HexColor("#6709eb")
                                  : Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _current = false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: HexColor("#6709eb"),
                        secondary: Icon(Icons.admin_panel_settings),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                        onPressed: () {
                          if (_current) {
                            _controller.animateToPage(1,
                                duration: Duration(microseconds: 300),
                                curve: Curves.easeIn);
                          } else {
                            _controller.animateToPage(2,
                                duration: Duration(microseconds: 300),
                                curve: Curves.easeIn);
                          }
                        },
                        child: Text("Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04)),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupOptions()));
                        }),
                    Text("Fill all the details , carefully",
                        style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: size.height * 0.03),
                    BuildTextFormField(
                      'name',
                      nameController,
                      (value) {
                        // Email validation logic
                        return null;
                      },
                      TextInputType.text,
                      Icons.account_circle,
                    ),
                    SizedBox(height: size.height * 0.03),
                    BuildTextFormField(
                      'language',
                      languageController,
                      (value) {
                        // Email validation logic
                        return null;
                      },
                      TextInputType.text,
                      Icons.language,
                    ),
                    SizedBox(height: size.height * 0.03),
                    BuildTextFormField(
                      'Country',
                      countryController,
                      (value) {
                        // Email validation logic
                        return null;
                      },
                      TextInputType.text,
                      Icons.location_on,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserPage()));
                        },
                        child: Text("Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04)),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignupOptions()));
                      },
                    ),
                    Text("Fill all the details , carefully",
                        style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: size.height * 0.03),
                    BuildTextFormField(
                      'agency name',
                      agencyNameController,
                      (value) {
                        // Email validation logic
                        return null;
                      },
                      TextInputType.text,
                      Icons.account_circle,
                    ),
                    SizedBox(height: size.height * 0.03),
                    BuildTextFormField(
                      'Location',
                      locationController,
                      (value) {
                        // Email validation logic
                        return null;
                      },
                      TextInputType.text,
                      Icons.location_city,
                    ),
                    SizedBox(height: size.height * 0.03),
                    BuildTextFormField(
                      'Description',
                      descriptionController,
                      (value) {
                        // Email validation logic
                        return null;
                      },
                      TextInputType.text,
                      Icons.description,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AgencyPanelScreen()));
                        },
                        child: Text("Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04)),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
