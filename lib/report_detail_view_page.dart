import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDetailViewPage extends StatelessWidget {
  final String reportId;

  ReportDetailViewPage({required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('incidentReports').doc(reportId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Report not found.'));
          }

          final report = snapshot.data!.data() as Map<String, dynamic>;
          final dateTime = report['dateTime'] ?? 'N/A';
          final location = report['location'] ?? 'N/A';
          final typeOfIncident = report['typeOfIncident'] ?? 'N/A';
          final cause = report['cause'] ?? 'N/A';
          final numberOfCasualties = report['numberOfCasualties'] ?? 'N/A';
          final identityOfCasualties = report['identityOfCasualties'] ?? 'N/A';
          final numberOfDisplacedPersons = report['numberOfDisplacedPersons'] ?? 'N/A';
          final respondingAgencies = report['respondingAgencies'] ?? 'N/A';
          final resourcesDeployed = report['resourcesDeployed'] ?? 'N/A';
          final images = report['images'] as List<dynamic>? ?? [];

          // Convert images list from List<dynamic> to List<Widget>
          final imageWidgets = images.map((url) {
            if (url is String) {
              return Image.network(url, width: 100, height: 100, fit: BoxFit.cover);
            }
            return SizedBox(); // Placeholder if the URL is not a string
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Incident Type: $typeOfIncident', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Location: $location'),
                  Text('Date: $dateTime'),
                  Text('Cause: $cause'),
                  Text('Number of Casualties: $numberOfCasualties'),
                  Text('Identity of Casualties: $identityOfCasualties'),
                  Text('Number of Displaced Persons: $numberOfDisplacedPersons'),
                  Text('Responding Agencies: $respondingAgencies'),
                  Text('Resources Deployed: $resourcesDeployed'),
                  SizedBox(height: 10),
                  if (imageWidgets.isNotEmpty) ...[
                    Text('Attached Images:'),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: imageWidgets,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
