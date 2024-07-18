import 'package:douce/features/user/chat/chat_controller.dart';
import 'package:douce/shared/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String doula = Get.arguments['doula'] as String;
    final String user = Get.arguments['user'] as String;
    final bool isDoula = Get.arguments['isDoula'] as bool;

    final ChatController chatController = Get.put(
      ChatController(doula: doula, user: user, isDoula: isDoula),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorDouce.douceBase,
                    ),
                  ),
                  Obx(
                    () => Text(
                      isDoula
                          ? chatController.namaUser.value
                          : chatController.namaDoula.value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.heart_broken_rounded,
                    color: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    child: Column(
                      children: [
                        ...chatController.messages.map(
                          (message) => message.sender ==
                                  chatController.pengguna.value
                              ? Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: message.sender == doula
                                            ? Image.network(
                                                chatController.imageDoula.value,
                                                width: 35,
                                                height: 35,
                                                fit: BoxFit.cover,
                                              )
                                            : chatController
                                                    .imageUser.value.isEmpty
                                                ? Image.asset(
                                                    'assets/images/blank-profile.png',
                                                    width: 35,
                                                    height: 35,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    chatController
                                                        .imageUser.value,
                                                    width: 35,
                                                    height: 35,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                      const SizedBox(width: 15),
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: ColorDouce.douceBase,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message.message,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                message.time,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: ColorDouce.douceBase,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message.message,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                message.time,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: message.sender == doula
                                            ? Image.asset(
                                                "assets/images/topdoula.png",
                                                width: 35,
                                                height: 35,
                                                fit: BoxFit.cover,
                                              )
                                            : chatController
                                                    .imageUser.value.isEmpty
                                                ? Image.asset(
                                                    'assets/images/blank-profile.png',
                                                    width: 35,
                                                    height: 35,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    chatController
                                                        .imageUser.value,
                                                    width: 35,
                                                    height: 35,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: chatController.messageController.value,
                        decoration: InputDecoration(
                          hintText: 'Tulis Pesan',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      chatController.sendMessage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorDouce.douceBase,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.telegram_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
