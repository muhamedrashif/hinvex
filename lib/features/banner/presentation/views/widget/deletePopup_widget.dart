import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/presentation/provider/banner_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

class DeletePostConfirmationDialog extends StatelessWidget {
  final String postId;
  final String imageUrl;

  const DeletePostConfirmationDialog(
      {super.key, required this.imageUrl, required this.postId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Banner',
        style: TextStyle(color: buttonTextColor),
      ),
      content: const Text(
        'Do you want to delete Banner',
        style: TextStyle(color: buttonTextColor),
      ),
      backgroundColor: titleTextColor,
      actions: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 30,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: buttonTextColor,
              ),
              child: const Center(
                child: Text(
                  'No',
                  style: TextStyle(color: titleTextColor),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {
              showProgress(context);
              Provider.of<BannerProvider>(context, listen: false)
                  .deleteStorageImage(
                url: imageUrl,
                id: postId,
                onSuccess: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                onFailure: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
            child: Container(
              height: 30,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: buttonTextColor,
              ),
              child: const Center(
                child: Text(
                  'Yes',
                  style: TextStyle(color: titleTextColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
