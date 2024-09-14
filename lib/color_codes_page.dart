import 'package:flutter/material.dart';

class ColorCodesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Codes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColorCodeItem(
              color: Colors.green,
              label: 'Green: Non-Emergency Incidents',
              description:
              'Examples: Minor accidents, property damage, nuisance complaints',
            ),
            SizedBox(height: 16),
            ColorCodeItem(
              color: Colors.yellow,
              label: 'Yellow: Warnings or Potential Threats',
              description:
              'Examples: Hazardous material spills, natural disasters (e.g., typhoons, earthquakes), civil unrest',
            ),
            SizedBox(height: 16),
            ColorCodeItem(
              color: Colors.blue,
              label: 'Blue: Medical Emergencies',
              description:
              'Examples: Heart attacks, strokes, accidents, injuries',
            ),
            SizedBox(height: 16),
            ColorCodeItem(
              color: Colors.red,
              label: 'Red: Critical or Life-Threatening Incidents',
              description:
              'Examples: Fires, building collapses, mass casualties, active shooters',
            ),
            SizedBox(height: 16),
            ColorCodeItem(
              color: Colors.cyan,
              label: 'Cyan Blue: Police Assistance Button',
              description:
              'Automated Message including the location will be sent to PNP in case assistance is needed.',
            ),
          ],
        ),
      ),
    );
  }
}

class ColorCodeItem extends StatelessWidget {
  final Color color;
  final String label;
  final String description;

  ColorCodeItem({
    required this.color,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          color: color,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }
}
