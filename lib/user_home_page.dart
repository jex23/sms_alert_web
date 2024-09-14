import 'package:flutter/material.dart';

class ColorCodeItem extends StatelessWidget {
  final Color color;
  final String label;
  final String description;
  final int count;

  ColorCodeItem({
    required this.color,
    required this.label,
    required this.description,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '$count',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports Dashboard'),
        backgroundColor: Colors.blueGrey[900],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incident Reports Overview',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three cards per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 4 / 3, // Adjust aspect ratio for better layout
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  // Sample data
                  final data = [
                    {
                      'color': Colors.green,
                      'label': 'Green: Non-Emergency Incidents',
                      'description': 'Minor accidents, property damage, nuisance complaints',
                      'count': 10,
                    },
                    {
                      'color': Colors.yellow,
                      'label': 'Yellow: Warnings or Potential Threats',
                      'description': 'Hazardous material spills, natural disasters, civil unrest',
                      'count': 5,
                    },
                    {
                      'color': Colors.blue,
                      'label': 'Blue: Medical Emergencies',
                      'description': 'Heart attacks, strokes, accidents, injuries',
                      'count': 8,
                    },
                    {
                      'color': Colors.red,
                      'label': 'Red: Critical or Life-Threatening Incidents',
                      'description': 'Fires, building collapses, active shooters',
                      'count': 2,
                    },
                    {
                      'color': Colors.cyan,
                      'label': 'Cyan Blue: Police Assistance Button',
                      'description': 'Automated Message including location sent to PNP',
                      'count': 7,
                    },
                  ][index];
                  return ColorCodeItem(
                    color: data['color'] as Color,
                    label: data['label'] as String,
                    description: data['description'] as String,
                    count: data['count'] as int,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserHomePage(),
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}
