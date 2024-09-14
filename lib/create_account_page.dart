import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html; // For web file picker handling.
import 'package:flutter/foundation.dart'; // To check if the app is running on web.
import 'package:intl/intl.dart';
import 'home_page.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // New controllers for email and password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;
  XFile? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _uploadImageAndCreateAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Upload Image to Firebase Storage (different for web)
      if (_imageFile != null) {
        String fileName = userCredential.user!.uid + '.jpg';
        final ref = _storage.ref().child('user_images').child(fileName);

        if (kIsWeb) {
          // Web: use the bytes from the file to upload
          final bytes = await _imageFile!.readAsBytes();
          await ref.putData(bytes);
        } else {
          // Mobile: use putFile
          await ref.putFile(File(_imageFile!.path));
        }

        _imageUrl = await ref.getDownloadURL();
      }

      // Store User Details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'address': _addressController.text,
        'birthday': _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '',
        'gender': _selectedGender,
        'phone_number': _phoneNumberController.text,
        'email': _emailController.text,
        'profile_image_url': _imageUrl,
      });

      // Navigate to Home Page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print('Account creation failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Account creation failed: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Center(
        child: Container(
          width: 500,
          child: Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.0),

                    // Date Picker for Birthday
                    GestureDetector(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Birthday',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'Select your birthday'
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedGender,
                      items: ['Male', 'Female', 'Other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),

                    // Image Picker for Profile Picture
                    GestureDetector(
                      onTap: _pickImage,
                      child: _imageFile == null
                          ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(75),
                        ),
                        child: Icon(Icons.camera_alt, size: 50, color: Colors.white),
                      )
                          : CircleAvatar(
                        radius: 75,
                        backgroundImage: _imageFile != null
                            ? kIsWeb
                            ? NetworkImage(_imageFile!.path)
                            : FileImage(File(_imageFile!.path)) as ImageProvider
                            : null,
                      ),
                    ),
                    SizedBox(height: 16.0),

                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _uploadImageAndCreateAccount,
                      child: Text('Create Account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}
