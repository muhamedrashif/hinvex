import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/provider/uploadedByAdmin_provider.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

class VideoPickWidget extends StatelessWidget {
  final UserProductDetailsModel? userProductDetailsModel;
  const VideoPickWidget(
      {super.key, this.userProductDetailsModel, this.isEditing});
  final bool? isEditing;
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
            Column(
              children: [
                DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: const [5, 5],
                  child: InkWell(
                    onTap: () {
                      state.getVideo(context: context);
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
                ),
                state.videoPath == null
                    ? const SizedBox()
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
                                  onTap: () async {
                                    showProgress(context);

                                    await state
                                        .removeVideo(
                                            path: state.videoPath.toString(),
                                            isEditing: isEditing ?? false,
                                            userProductDetailsModel:
                                                userProductDetailsModel)
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
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
          ],
        ),
      );
    });
  }
}
