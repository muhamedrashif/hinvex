import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/presentation/provider/banner_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

showAddWebBannerPopUpWidget(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    content: Consumer<BannerProvider>(builder: (context, state, _) {
      return Stack(
        children: [
          SizedBox(
            height: 160,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    state.imageFile != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
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
                                      padding: const EdgeInsets.all(8),
                                      child: Image.memory(
                                        state.imageFile!,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              )
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () async {
                                    state.getImage();
                                  },
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
                                ),
                              )
                            ],
                          ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          state.saveImage(
                            imagePath: state.imageFile!,
                            status: "0",
                            onSuccess: () {
                              showProgress(context);
                              state.clearImage();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            onFailure: () {
                              showProgress(context);
                              state.clearImage();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: state.saveImageloading
                            ? const CircularProgressIndicator()
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: buttonColor),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 8),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        color: buttonTextColor, fontSize: 10),
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
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                radius: 8,
                backgroundColor: buttonColor,
                child: Icon(
                  Icons.close,
                  size: 10,
                  color: buttonTextColor,
                ),
              ),
            ),
          ),
        ],
      );
    }),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
