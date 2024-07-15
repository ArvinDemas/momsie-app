import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.selectedItem,
  });

  final List<String> items;
  final Function(String) onChanged;
  final RxString selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ColorDouce.douceBase,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ColorDouce.douceBase,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ColorDouce.douceBase,
            width: 1,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      ),
      isExpanded: true,
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        onChanged(value!);
      },
      value: selectedItem.value.isEmpty ? null : selectedItem.value,
      style: TextStyle(
        color: selectedItem.isEmpty ? Colors.black26 : Colors.black,
        fontSize: 16,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: ColorDouce.douceBase,
      ),
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((String item) {
          return Text(
            item,
            style: TextStyle(
              color: ColorDouce.douceBase,
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList();
      },
    );
  }
}
