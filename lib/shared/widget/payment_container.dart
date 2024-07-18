import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';

class PaymentContainer extends StatelessWidget {
  const PaymentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/ovo.png',
            width: 100,
            height: 100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '081234567890',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorDouce.douceBase,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'A/N Miranda',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorDouce.douceBase,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
