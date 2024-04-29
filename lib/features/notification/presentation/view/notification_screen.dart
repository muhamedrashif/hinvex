import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/notification/data/model/notification_model.dart';
import 'package:hinvex/features/notification/presentation/provider/notification_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void cleardata() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationProvider>(builder: (context, state, _) {
        log(state.sendLoading.toString());
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 1100,
                child: Form(
                  key: _formkey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 80,
                            child: Text("Hello Admin"),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Notifications",
                            style: TextStyle(
                                color: titleTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Image"),
                              const Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 70.0),
                                child: InkWell(
                                  onTap: () {
                                    state.getImage();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey[200]),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 40),
                                      child: Text(
                                        "Choose File",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        state.imageFile != null
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 124.0, top: 8),
                                    child: DottedBorder(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                      dashPattern: const [
                                        5,
                                        5,
                                      ],
                                      child: Container(
                                          height: 85,
                                          width: 130,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 4.0),
                                          child: Image.memory(
                                            state.imageFile!,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 124.0, top: 8),
                                    child: DottedBorder(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                      dashPattern: const [
                                        5,
                                        5,
                                      ],
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 51.0, vertical: 30),
                                        child: const Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Title"),
                              const Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              const SizedBox(width: 80.0),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Create A Titile",
                                        hintStyle: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Title';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Description"),
                              const Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              const SizedBox(
                                width: 37.0,
                              ),
                              Expanded(
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            "Description about notification (Maximum 50 words for better experience)",
                                        hintStyle: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                      maxLines: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  if (_formkey.currentState!.validate()) {
                                    _formkey.currentState!.save();
                                    state.sendAndStroreNotification(
                                      notification: NotificationModel(
                                        description:
                                            _descriptionController.text,
                                        title: _titleController.text,
                                        timestamp: Timestamp.now(),
                                      ),
                                      onSuccess: () {
                                        cleardata();
                                      },
                                    );
                                  }
                                },
                                child: state.sendLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator())
                                    : Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: sentButtonColor),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 40),
                                          child: Text(
                                            "Send",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: buttonTextColor),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
