import 'package:flutter/material.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/provider/uploadedByAdmin_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:provider/provider.dart';

Future<bool> showDeletePopup(BuildContext context, String id) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text(
            'Delete Post',
            style: TextStyle(color: buttonTextColor),
          ),
          content: const Text(
            'Do you want to detele post',
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
                    ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  showProgress(context);
                  Provider.of<UploadedByAdminProvider>(context, listen: false)
                      .deleteUploadedPosts(
                    id: id,
                    onSuccess: () {
                      Provider.of<UploadedByAdminProvider>(context,
                          listen: false)
                        ..fetchProducts()
                        ..removeFromfilteredUploadedPropertiesList(id);
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
                    ))),
              ),
            ),
          ],
        ),
      ) ??
      false; //if showDialouge had returned null, then return false
}
