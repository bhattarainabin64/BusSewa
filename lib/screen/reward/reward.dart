import 'package:flutter/material.dart';

class RewardPoints extends StatefulWidget {
  const RewardPoints({super.key});

  @override
  State<RewardPoints> createState() => _RewardPointsState();
}

class _RewardPointsState extends State<RewardPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Reward Points"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Image(image: AssetImage('assets/images/reward.png')),
          const Text("You have 0 points",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: const Text("Redeem Points")),
        ],
      ),
    );
  }
}
