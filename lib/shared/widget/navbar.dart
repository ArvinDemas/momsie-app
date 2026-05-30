import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    required this.onChangeIndex,
    required this.listItems,
    required this.selectedIndex,
    super.key,
  });

  final List<Map<String, dynamic>> listItems;
  final Function(int) onChangeIndex;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.2,
          color: Colors.grey,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: listItems
            .map(
              (item) => navbarItems(
                item['label']!,
                item['count']!,
                context,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget navbarItems(
    String label,
    int navbarIndex,
    context,
  ) {
    return InkWell(
      onTap: () {
        onChangeIndex(navbarIndex);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedIndex == navbarIndex
                ? Transform.translate(
                    offset: const Offset(0, -25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/navbar/$label-active.png',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/navbar/$label.png',
                    width: 27,
                    height: 27,
                  ),
            const SizedBox(height: 5),
            Transform.translate(
              offset: selectedIndex == navbarIndex
                  ? const Offset(0, -25)
                  : const Offset(0, 0),
              child: FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: selectedIndex == navbarIndex ? 14 : 12,
                    fontWeight: selectedIndex == navbarIndex
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
