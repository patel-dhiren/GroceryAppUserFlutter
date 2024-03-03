import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:grocery_app_user/views/verification/verification_view.dart';
import 'package:grocery_app_user/widget/custom_button.dart';

import '../../gen/assets.gen.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>(); // Add this line
  String mobileNumber = '';

  void _verifyPhoneNumber() async {
    FirebaseService().verifyPhoneNumber(
      mobileNumber,
          () {

        Navigator.pushNamed(context, AppConstant.verificationView, arguments: mobileNumber);
      },
          (String message) {
        print('error : $message');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Assets.images.veggieBg.image(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    // Wrap your Column in a Form widget
                    key: _formKey, // Add this line
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Get your groceries\nwith nectar',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          // Change TextField to TextFormField
                          decoration: InputDecoration(
                            labelText: 'Enter Mobile Number',
                            prefixText: '+91',
                            suffixIcon: Icon(Icons.call),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (value.length != 10) {
                              // Assuming Indian mobile numbers
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            mobileNumber = "+91$value";
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                          title: 'Continue',
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              // Add this line
                              // If the form is valid, display a Snackbar.
                              _formKey.currentState!.save(); // Save the form
                              _verifyPhoneNumber();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
