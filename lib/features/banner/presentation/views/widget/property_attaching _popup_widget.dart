import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/presentation/provider/banner_provider.dart';
import 'package:provider/provider.dart';

// void showAttachPropertyIntoBannerPopUpWidget(BuildContext context) {
//   final TextEditingController_searchController = TextEditingController();
//   Provider.of<BannerProvider>(context, listen: false).fetchProducts();

//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return
//     },
//   );
// }

class PropertyAttachingPopupScreen extends StatefulWidget {
  final String id;
  const PropertyAttachingPopupScreen({super.key, required this.id});

  @override
  State<PropertyAttachingPopupScreen> createState() =>
      _PropertyAttachingPopupScreenState();
}

class _PropertyAttachingPopupScreenState
    extends State<PropertyAttachingPopupScreen> {
  // final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<BannerProvider>(context, listen: false).fetchProducts();

  //     _scrollController.addListener(_scrollListener);
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     Provider.of<BannerProvider>(context, listen: false).fetchProducts();
  //   }
  // }
  final TextEditingController _searchController = TextEditingController();
  int? _selectedRadio;

  @override
  void initState() {
    super.initState();
    _selectedRadio = null;
  }

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
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.close_sharp,
                            ),
                          ))
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
                                      border: Border.all(),
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
                                              child: Image.network(
                                                state.suggestions[index]
                                                    .propertyImage![0],
                                                fit: BoxFit.cover,
                                              ),
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
                                      child: Radio(
                                        value: index,
                                        groupValue: _selectedRadio,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _selectedRadio = value;

                                            if (value != null) {
                                              state.updateBannerId(
                                                  id: state
                                                      .suggestions[index].id
                                                      .toString(),
                                                  bannerId: widget.id);
                                            } else {
                                              state.updateBannerId(
                                                  id: state
                                                      .suggestions[index].id
                                                      .toString(),
                                                  bannerId: '');
                                            }
                                          });
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
