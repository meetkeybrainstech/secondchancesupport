import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Second Chance Support',
      home: PrivacyPolicyScreen(),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Second Chance Support Privacy Policy',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Effective Date: 18-12-2023',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Thank you for choosing to support Second Chance Support. Your privacy and the security of your personal information are important to us. This Privacy Policy outlines how we collect, use, disclose, and protect your information when you engage with Second Chance Support as an organization, merchant, or donor.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Definitions',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '- Organization: Refers to Second Chance Support and all affiliated entities involved in providing support to homeless members.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '- Merchant: Any entity or individual partnering with Second Chance Support for fundraising or support activities.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '- Donor: An individual or entity contributing financial or in-kind donations to Second Chance Support.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '2. Information We Collect',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'a. Organization Information: When you engage with Second Chance Support as an organization, we may collect:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Organization name, address, and contact information.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Information about the services and support provided to homeless members.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Financial information for donation processing and reporting.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'b. Merchant Information: If you are a merchant partnering with Second Chance Support, we may collect:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Business name, address, and contact information.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Information related to fundraising activities and events.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'c. Donor Information: When you make a donation to Second Chance Support, we may collect:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Name, address, and contact information.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Payment information (credit card details, bank account information) for donation processing.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Donation history and preferences.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '3. How We Use Your Information',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'a. Organization Information: We use organization information to:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Provide support to homeless members.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Communicate about partnership opportunities.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Process and manage donations.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'b. Merchant Information: We use merchant information to:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Coordinate fundraising activities and events.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Communicate about collaboration opportunities.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'c. Donor Information: We use donor information to:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Process donations.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Send donation receipts and acknowledgments.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '   - Keep donors informed about Second Chance Support\'s activities.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '4. Information Sharing',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We do not sell, trade, or otherwise transfer your information to outside parties without your consent, except for the purpose of providing the agreed-upon services.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '5. Security Measures',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '6. Changes to Privacy Policy',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Second Chance Support reserves the right to update and revise this Privacy Policy. We will notify you of any changes through our website or other communication channels.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '7. Contact Information',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'If you have any questions or concerns regarding this Privacy Policy, please contact us at:',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                '[Insert Contact Information]',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'By engaging with Second Chance Support, you agree to the terms outlined in this Privacy Policy.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),

              Text(
                '18-12-2023',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
