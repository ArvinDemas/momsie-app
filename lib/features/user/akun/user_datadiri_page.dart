import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/account_topbar.dart';
import 'package:flutter/material.dart';

class UserDataDiriPage extends StatelessWidget {
  const UserDataDiriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController nikController = TextEditingController();
    final TextEditingController alamatController = TextEditingController();
    final TextEditingController birthController = TextEditingController();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const AccountTopBar(isEditPage: true),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                editTextField(nameController, "Nama Lengkap"),
                const SizedBox(height: 30),
                editTextField(nikController, "NIK"),
                const SizedBox(height: 30),
                editTextField(alamatController, "Alamat"),
                const SizedBox(height: 30),
                editTextField(birthController, "Tanggal Lahir"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget editTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          hintText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorDouce.douceBase,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
