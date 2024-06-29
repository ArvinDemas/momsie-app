import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    required this.onChangeIndex,
    required this.listItems,
    super.key,
  });

  final List<Map<String, String>> listItems;
  final Function(int) onChangeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
      ),
      height: MediaQuery.of(context).size.height * 0.1,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01,
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: listItems
                  .map(
                    (item) => navbarItems(
                      item['label']!,
                      int.parse(item['count']!),
                      context,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
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
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
        ),
        width: MediaQuery.of(context).size.width * 0.17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.abc),
            const SizedBox(height: 3),
            FittedBox(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
