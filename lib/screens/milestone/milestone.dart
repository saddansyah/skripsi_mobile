import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';

class MilestoneScreen extends StatefulWidget {
  const MilestoneScreen({super.key});

  @override
  State<MilestoneScreen> createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        reverse: true,
        child: Image.asset('assets/images/milestone_map.png',
            colorBlendMode: BlendMode.color),
      ),
    );
  }
}
