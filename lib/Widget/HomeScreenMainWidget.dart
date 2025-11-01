import 'package:flutter/material.dart';
import 'package:freehit/Payloads/PostResponseDto.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Widget/PostScreen.dart';
import 'package:freehit/Utils/Colors.dart';

class HomeScreenMainWidget extends StatefulWidget {
  const HomeScreenMainWidget({super.key});

  @override
  State<HomeScreenMainWidget> createState() => _HomeScreenMainWidgetState();
}

class _HomeScreenMainWidgetState extends State<HomeScreenMainWidget> {
  List<String> storiesUrl = List.generate(10, (i) => "video_$i.mp4");
  List<PostResponseDto> posts = List.generate(100, (i) {
    Set<String> fileUrls = Set();
    if (i % 3 == 0) {
      fileUrls.add("post $i video 1");
      fileUrls.add("post $i video 2");
      fileUrls.add("post $i video 3");
      fileUrls.add("post $i video 4");
    } else {
      fileUrls.add("post $i");
    }
    return PostResponseDto(
      fileUrls: fileUrls,
      title: "title",
      contentDescription: "contentDescription",
      postPrivate: false,
      postId: i,
      allowComments: true,
      isReel: false,
      userId: i,
      username: "userName",
      userProfileUrl: "userProfileUrl",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      mainCategoryIds: {1,2,3,4},
      subCategoryIds: {1,2,3,4,5,6},
      commentCount: 44,
      reactionCount: {
        "LIKE":10,
        "LOVE":50,
        "CARE":49,
        "LAUGH":55,
        "WOW":23,
        "SAD":44,
        "ANGRY":10,
        "FIRE":4
      }
    );
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      cacheExtent:6 * 585,
      itemCount: posts.length + 1,
      itemBuilder: (context, index) {
        // First item: stories bar
        if (index == 0) {
          return Container(
            height: 100,
            color: isDarkMode ? AppColors.dark : AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: storiesUrl.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: isWidthShrinkable ? 60 : 100,
                  height: isWidthShrinkable ? 60 : 100,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          );
        }

        // Regular post widgets
        return PostScreen(
          key: ValueKey(posts[index - 1]),
          postResponseDto: posts[index - 1],
        );
      },
    );
  }
}
