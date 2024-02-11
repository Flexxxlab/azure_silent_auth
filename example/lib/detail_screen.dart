import 'package:azure_silent_auth/model.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final User user;

  const DetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.name ?? 'Not Available'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Email: ${user.email ?? 'Not Available'}'),
            Text('Phone Number: ${user.phoneNumber ?? 'Not Available'}'),
            const SizedBox(height: 16),
            const Text(
              'Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
                'Formatted Address: ${user.formattedAddress ?? 'Not Available'}'),
            Text('Street Address: ${user.streetAddress ?? 'Not Available'}'),
            Text('Locality: ${user.locality ?? 'Not Available'}'),
            Text('Region: ${user.region ?? 'Not Available'}'),
            Text('Postal Code: ${user.postalCode ?? 'Not Available'}'),
            Text('Country: ${user.country ?? 'Not Available'}'),
            const SizedBox(height: 16),
            const Text(
              'Other Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Gender: ${user.gender ?? 'Not Available'}'),
            Text('Birthdate: ${user.birthdate ?? 'Not Available'}'),
            Text('Locale: ${user.locale ?? 'Not Available'}'),
            Text(
                'Updated At: ${user.updatedAt?.toString() ?? 'Not Available'}'),
          ],
        ),
      ),
    );
  }
}
