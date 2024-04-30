import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/user/presentation/provider/user_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUser();
      _scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<UserProvider>(context, listen: false).fetchUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(builder: (context, state, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 1100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Hello Admin"),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 0),
                              child: SizedBox(
                                height: 40,
                                width: 300,
                                child: TextFormField(
                                  scrollPadding: const EdgeInsets.all(8),
                                  style: const TextStyle(fontSize: 10),
                                  controller: _searchController,
                                  onChanged: (query) {
                                    // Call the onSearchChanged method in UserProvider
                                    if (query.isEmpty) {
                                      state
                                        ..clearDoc()
                                        ..fetchUserList.clear()
                                        ..fetchUser();
                                    }
                                    if (query.isNotEmpty) {
                                      state.onSearchChanged(query);
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "User",
                        style: TextStyle(
                            color: titleTextColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: state.fetchUserList.isEmpty
                          ? const Center(
                              child: Text('No users found.'),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: state.fetchUserList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final user = state.fetchUserList[index];
                                log(" LENGTH::::::::::::${state.fetchUserList.length.toString()}");
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "ID:${user.userId}",
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      user.userImage),
                                                  radius: 30,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                                    child: Text(
                                                      "Name                : ${user.userName}",
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0),
                                                    child: Text(
                                                      "PhoneNumber  : ${user.userPhoneNumber}",
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Flexible(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        state.userDetails(
                                                            userModel: user);
                                                        state.fetchPosts(
                                                            userId:
                                                                user.userId);
                                                        state.fetchRepors(
                                                            userId:
                                                                user.userId);
                                                        Provider.of<RoutingProvider>(
                                                                context,
                                                                listen: false)
                                                            .userRouting(
                                                                UserRoutingEnum
                                                                    .userDetailWidget);
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: buttonColor,
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            "View Account",
                                                            style: TextStyle(
                                                              color:
                                                                  buttonTextColor,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    // if (state.fetchUserLoding)
                    //   const Padding(
                    //     padding: EdgeInsets.all(16.0),
                    //     child: Center(
                    //       child: CircularProgressIndicator(),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
