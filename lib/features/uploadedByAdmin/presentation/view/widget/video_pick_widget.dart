import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/provider/uploadedByAdmin_provider.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

class VideoPickWidget extends StatelessWidget {
  const VideoPickWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadedByAdminProvider>(builder: (context, state, _) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 200,
              child: Text("Upload Video"),
            ),
            state.videoPath == null
                ? DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashPattern: const [5, 5],
                    child: InkWell(
                      onTap: () {
                        showProgress(context);

                        state.getVideo(onSuccess: () {
                          Navigator.pop(context);
                        }, onFailure: () {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 148.0, vertical: 20),
                        child: Column(
                          children: [
                            Image.asset(
                              ImageConstant.imageIcon,
                              fit: BoxFit.cover,
                            ),
                            const Text(
                              "Pick your video from here",
                              style: TextStyle(fontSize: 13),
                            ),
                            const Text(
                              "Supports: Mp4",
                              style: TextStyle(fontSize: 8, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300)),
                      height: 60,
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.videoPath.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                state.removeVideo(state.videoPath.toString());
                              },
                              child: const Icon(
                                Icons.close,
                                size: 13,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
