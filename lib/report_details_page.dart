import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

class ReportDetailsPage extends StatefulWidget {
  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String dateTime = '';
  String location = '';
  String typeOfIncident = '';
  String cause = '';
  int numberOfCasualties = 0;
  String identityOfCasualties = '';
  int numberOfDisplacedPersons = 0;
  String respondingAgencies = '';
  String resourcesDeployed = '';
  List<XFile> images = [];
  List<String> imageDataUrls = [];

  // Initialize Firebase
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  // Function to pick images using image_picker
  void pickImages() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      final blob = html.Blob([imageBytes]);

      final reader = html.FileReader();
      reader.readAsDataUrl(blob);

      reader.onLoadEnd.listen((e) {
        if (reader.result != null) {
          setState(() {
            images.add(pickedFile);
            imageDataUrls.add(reader.result as String);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load image.')),
          );
        }
      });
    }
  }

  // Function to upload images to Firebase Storage and get URLs
  Future<List<String>> uploadImages() async {
    List<String> urls = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    for (var image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + image.name;
      Reference ref = storage.ref().child('incident_reports/$fileName');

      final Uint8List imageBytes = await image.readAsBytes();

      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;

      String url = await snapshot.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  // Function to save the report to Firestore
  Future<void> saveReport() async {
    if (_formKey.currentState!.validate()) {
      List<String> urls = await uploadImages();

      await FirebaseFirestore.instance.collection('incidentReports').add({
        'dateTime': dateTime,
        'location': location,
        'typeOfIncident': typeOfIncident,
        'cause': cause,
        'numberOfCasualties': numberOfCasualties,
        'identityOfCasualties': identityOfCasualties,
        'numberOfDisplacedPersons': numberOfDisplacedPersons,
        'respondingAgencies': respondingAgencies,
        'resourcesDeployed': resourcesDeployed,
        'images': urls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report Saved Successfully!')),
      );
      Navigator.pop(context); // Go back to the main page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Incident Report Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'Date and Time',
                  onChanged: (value) => dateTime = value,
                ),
                _buildTextField(
                  label: 'Location',
                  onChanged: (value) => location = value,
                ),
                _buildTextField(
                  label: 'Type of Incident',
                  onChanged: (value) => typeOfIncident = value,
                ),
                _buildTextField(
                  label: 'Cause',
                  onChanged: (value) => cause = value,
                ),
                _buildTextField(
                  label: 'Number of Casualties',
                  onChanged: (value) => numberOfCasualties = int.tryParse(value) ?? 0,
                ),
                _buildTextField(
                  label: 'Identity of Casualties',
                  onChanged: (value) => identityOfCasualties = value,
                ),
                _buildTextField(
                  label: 'Number of Displaced Persons',
                  onChanged: (value) => numberOfDisplacedPersons = int.tryParse(value) ?? 0,
                ),
                _buildTextField(
                  label: 'Responding Agencies',
                  onChanged: (value) => respondingAgencies = value,
                ),
                _buildTextField(
                  label: 'Resources Deployed',
                  onChanged: (value) => resourcesDeployed = value,
                ),
                SizedBox(height: 20),
                TextButton.icon(
                  onPressed: pickImages,
                  icon: Icon(Icons.attach_file),
                  label: Text('Attach Photos'),
                ),
                Wrap(
                  spacing: 10,
                  children: imageDataUrls
                      .where((dataUrl) => dataUrl.isNotEmpty)
                      .map((dataUrl) => Image.network(
                    dataUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ))
                      .toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveReport,
                  child: Text('Finalize & Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        TextFormField(
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
