import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/presentation/provider/banner_provider.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WebPropertyAttachingPopupScreen extends StatefulWidget {
  final String id;
  const WebPropertyAttachingPopupScreen({super.key, required this.id});

  @override
  State<WebPropertyAttachingPopupScreen> createState() =>
      _WebPropertyAttachingPopupScreenState();
}

class _WebPropertyAttachingPopupScreenState
    extends State<WebPropertyAttachingPopupScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Consumer<BannerProvider>(
        builder: (context, state, _) {
          return SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 240,
                        child: TextFormField(
                          scrollPadding: const EdgeInsets.all(8),
                          style: const TextStyle(fontSize: 10),
                          controller: _searchController,
                          onChanged: (query) {
                            if (query.isNotEmpty) {
                              state
                                ..clearDoc()
                                ..searchProperty(query.toLowerCase());
                            }
                            if (query.isEmpty) {
                              state.clearSuggestions();
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: "Search Here",
                            hintStyle: TextStyle(fontSize: 10),
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          state.clearSuggestions();
                          Navigator.pop(context);
                        },
                        child: const SizedBox(
                          height: 20,
                          width: 20,
                          child: Icon(
                            Icons.close_sharp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                state.suggestions.isEmpty
                    ? const Center(
                        child: Text("No Property"),
                      )
                    : Expanded(
                        flex: 2,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.suggestions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2.0),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: SizedBox(
                                              height: 70,
                                              width: 80,
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: SizedBox(
                                                    height: 220,
                                                    width: 120,
                                                    child: Transform.scale(
                                                      scale: 1,
                                                      child: Image.asset(
                                                          ImageConstant.hinvex),
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
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
                                                imageUrl: state
                                                    .suggestions[index]
                                                    .propertyImage![0],
                                              ),
                                              // child: Image.network(
                                              //   state.suggestions[index]
                                              //       .propertyImage![0],
                                              //   fit: BoxFit.cover,
                                              // ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(state.suggestions[index]
                                                .propertyPrice
                                                .toString()),
                                            Text(state.suggestions[index]
                                                .getSelectedCategoryString),
                                            Text(state.suggestions[index]
                                                .getSelectedTypeString),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Checkbox(
                                        value: state.suggestions[index]
                                                .webBannerId ==
                                            widget.id,
                                        onChanged: (bool? value) {
                                          if (value != null) {
                                            showProgress(context);
                                            state.updateWebBannerId(
                                              product: state.suggestions[index],
                                              webBannerId: widget.id,
                                              onSuccess: () {
                                                Navigator.pop(context);
                                              },
                                              onFailure: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
