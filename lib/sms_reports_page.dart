import 'package:flutter/material.dart';

class SMSReportsPage extends StatelessWidget {
  // Sample data for SMS reports
  final List<Map<String, dynamic>> reports = [
    {
      'color': Colors.green,
      'colorTitle': 'Green: Non-Emergency Incidents',
      'number': '09123456789',
      'address': '123 Main St',
      'report': 'Minor accident',
    },
    {
      'color': Colors.yellow,
      'colorTitle': 'Yellow: Warnings or Potential Threats',
      'number': '09987654321',
      'address': '456 Elm St',
      'report': 'Hazardous material spill',
    },
    {
      'color': Colors.blue,
      'colorTitle': 'Blue: Medical Emergencies',
      'number': '09555555555',
      'address': '789 Oak St',
      'report': 'Heart attack',
    },
    {
      'color': Colors.red,
      'colorTitle': 'Red: Critical or Life-Threatening Incidents',
      'number': '09111222333',
      'address': '101 Pine St',
      'report': 'Building collapse',
    },
    {
      'color': Colors.cyan,
      'colorTitle': 'Cyan Blue: Police Assistance Button',
      'number': '09444555666',
      'address': '202 Maple St',
      'report': 'Police assistance needed',
    },
    {
      'color': Colors.green,
      'colorTitle': 'Green: Non-Emergency Incidents',
      'number': '09223344556',
      'address': '303 Birch St',
      'report': 'Property damage',
    },
    {
      'color': Colors.yellow,
      'colorTitle': 'Yellow: Warnings or Potential Threats',
      'number': '09334455667',
      'address': '404 Cedar St',
      'report': 'Natural disaster alert',
    },
    {
      'color': Colors.blue,
      'colorTitle': 'Blue: Medical Emergencies',
      'number': '09667788990',
      'address': '505 Fir St',
      'report': 'Accident with injuries',
    },
    {
      'color': Colors.red,
      'colorTitle': 'Red: Critical or Life-Threatening Incidents',
      'number': '09778899001',
      'address': '606 Spruce St',
      'report': 'Active shooter incident',
    },
    {
      'color': Colors.cyan,
      'colorTitle': 'Cyan Blue: Police Assistance Button',
      'number': '09889900112',
      'address': '707 Pine St',
      'report': 'Emergency assistance required',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Color Code')),
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Number')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Report')),
              DataColumn(label: Text('Action')),
            ],
            rows: reports.map((report) {
              return DataRow(
                cells: [
                  DataCell(Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: report['color'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
                  DataCell(Text(
                    report['colorTitle'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text(report['number'])),
                  DataCell(Text(report['address'])),
                  DataCell(
                    Text(
                      report['report'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                        // Add response logic here
                      },
                      child: Text('Respond'),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SMSReportsPage(),
  ));
}
