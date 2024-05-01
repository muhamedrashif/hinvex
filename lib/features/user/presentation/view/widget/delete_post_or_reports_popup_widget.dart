import 'package:flutter/material.dart';
import 'package:hinvex/features/user/presentation/provider/user_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

class DeletePostsOrReportsConfirmationDialog extends StatelessWidget {
  final String id;

  const DeletePostsOrReportsConfirmationDialog({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Post',
        style: TextStyle(color: buttonTextColor),
      ),
      content: const Text(
        'Do you want to delete post',
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

              Provider.of<UserProvider>(context, listen: false).deletePosts(
                id: id,
                onSuccess: () {
                  Provider.of<UserProvider>(context, listen: false)
                    ..fetchPostsList.clear()
                    ..fetchReportList.clear();
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
