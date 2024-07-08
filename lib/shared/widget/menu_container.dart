import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.image,
  });

  final String title;
  final IconData icon;
  final Function onTap;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 0.3,
              ),
            ),
          ),
          child: Row(
            children: [
              image == null
                  ? Icon(
                      icon,
                      color: ColorDouce.douceBase,
                      size: 32,
                    )
                  : Image.asset(
                      "assets/images/$image",
                      width: 32,
                      height: 32,
                    ),
              const SizedBox(width: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
