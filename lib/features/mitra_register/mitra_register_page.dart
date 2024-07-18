import 'package:douce/features/mitra_register/mitra_register_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:douce/shared/widget/custom_dropdown.dart';
import 'package:douce/shared/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MitraRegisterPage extends StatelessWidget {
  const MitraRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MitraRegisterController controller =
        Get.put(MitraRegisterController());

    List<List<Widget>> formField = [
      firstFormField(controller),
      secondFormField(controller),
      thirdFormField(controller),
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 175,
            decoration: BoxDecoration(
              color: ColorDouce.douceBase,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 75,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Daftar Mitra',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w700,
                color: ColorDouce.douceBase,
              ),
            ),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  ...formField[controller.currentPage.value]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> firstFormField(MitraRegisterController controller) {
    return [
      CustomTextField(
        hintText: "Nama Lengkap",
        iconImage: const Icon(Icons.person),
        isPassword: false,
        controller: controller.nameController.value,
      ),
      const SizedBox(height: 30),
      CustomTextField(
        hintText: "NIK",
        iconImage: const Icon(Icons.email),
        isPassword: false,
        controller: controller.nikController.value,
      ),
      const SizedBox(height: 30),
      CustomTextField(
        hintText: "No. HP / WhatsApp",
        iconImage: const Icon(Icons.home),
        isPassword: false,
        controller: controller.nohpController.value,
      ),
      const SizedBox(height: 30),
      const SizedBox(height: 40),
      InkWell(
        onTap: () {
          controller.changePage(1);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Next",
              style: TextStyle(
                color: ColorDouce.douceBase,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorDouce.douceBase,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> secondFormField(MitraRegisterController controller) {
    return [
      const Text(
        "Gender",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 5),
      CustomDropDown(
        items: controller.genderList.value,
        onChanged: (value) {
          controller.genderSelect.value = value;
        },
        selectedItem: controller.genderSelect,
      ),
      const SizedBox(height: 10),
      const Text(
        "Pekerjaan",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 5),
      CustomDropDown(
        items: controller.jobList.value,
        onChanged: (value) {
          controller.jobSelect.value = value;
        },
        selectedItem: controller.jobSelect,
      ),
      const SizedBox(height: 10),
      const Text(
        "Education",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 5),
      CustomDropDown(
        items: controller.educationList.value,
        onChanged: (value) {
          controller.educationSelect.value = value;
        },
        selectedItem: controller.educationSelect,
      ),
      const SizedBox(height: 10),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              controller.changePage(0);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: ColorDouce.douceBase,
                ),
                const SizedBox(width: 10),
                Text(
                  "Back",
                  style: TextStyle(
                    color: ColorDouce.douceBase,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              controller.changePage(2);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Next",
                  style: TextStyle(
                    color: ColorDouce.douceBase,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  color: ColorDouce.douceBase,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> thirdFormField(MitraRegisterController controller) {
    return [
      const Text(
        "Tuliskan Biografi Tentang Anda",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 10),
      CustomTextField(
        hintText: "Biografi",
        iconImage: const Icon(Icons.person),
        isPassword: false,
        controller: controller.biografiController.value,
        lineLimit: 6,
      ),
      const SizedBox(height: 20),
      const Text(
        "Upload Foto",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 10),
      Obx(
        () => InkWell(
          onTap: () {
            controller.pickImage();
          },
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                controller.currentImage.value != null
                    ? Image.file(
                        controller.currentImage.value!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.camera_alt,
                        color: Colors.grey[500],
                        size: 50,
                      ),
                const SizedBox(height: 10),
                controller.currentImage.value != null
                    ? const Text(
                        "Change Image",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      )
                    : const Text(
                        "Upload Image",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              controller.changePage(1);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: ColorDouce.douceBase,
                ),
                const SizedBox(width: 10),
                Text(
                  "Back",
                  style: TextStyle(
                    color: ColorDouce.douceBase,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              controller.submitRegister();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ColorDouce.douceBase,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ];
  }
}
