import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.text,
    required this.icon,
    required this.num,
    required this.color,
  });
  final String text;
  final IconData icon;
  final String num;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        height: 121,
        width: 230,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                icon,
                size: 35,
              ),
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            const Gap(5),
            Text(
              num,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
