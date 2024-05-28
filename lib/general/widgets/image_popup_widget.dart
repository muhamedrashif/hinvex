import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';
import 'package:shimmer/shimmer.dart';

class ImagePopUpWidget extends StatefulWidget {
  final List<dynamic> imageUrl;

  const ImagePopUpWidget({super.key, required this.imageUrl});

  @override
  State<ImagePopUpWidget> createState() => _ImagePopUpWidgetState();
}

class _ImagePopUpWidgetState extends State<ImagePopUpWidget> {
  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.imageUrl.length;
    });
  }

  void _previousImage() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.imageUrl.length) % widget.imageUrl.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 250,
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl[_currentIndex],
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: SizedBox(
                      height: 220,
                      width: 120,
                      child: Transform.scale(
                        scale: .6,
                        child: Image.asset(
                          ImageConstant.hinvex,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 36,
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      splashRadius: 2,
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                      ),
                      onPressed: _previousImage,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "${_currentIndex + 1}/${widget.imageUrl.length}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      splashRadius: 2,
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 20,
                      ),
                      onPressed: _nextImage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
