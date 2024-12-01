import 'package:flutter/material.dart';
import 'package:timed/widgets/round_gradient_button.dart';

import '../utils/app_colors.dart';

class ReportGenerate extends StatefulWidget {
  const ReportGenerate({super.key});

  @override
  State<ReportGenerate> createState() => _ReportGenerateState();
}

class _ReportGenerateState extends State<ReportGenerate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the default back button
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red,size: 40,),
            onPressed: () {
              Navigator.pop(context); // Goes back to the previous screen
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Placeholder content for the body
          Expanded(
            child: Center(
              child: Text(
                'Report Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Two buttons at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundGradientButton(title: "Save", onPressed: (){          }),
                RoundGradientButton(title: "Download", onPressed: (){          }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
