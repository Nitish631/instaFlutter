import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freehit/Payloads/PostResponseDto.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PostScreen extends StatefulWidget {
  final PostResponseDto postResponseDto;
  const PostScreen({super.key, required this.postResponseDto});

  @override
  State<PostScreen> createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  String? reacted = reactions["FIRE"];
  bool waitingForSecontTap=false;
  bool pauseVideo = false;
  bool showReactionsBox = false;
  bool isLoaded = false;
  bool doubleTapped = false;
  DateTime? firstTapTime;
  late List<String> fileList;
  late int fileCount;
  late PageController pageController;
  int currentPageIndex = 0;
  bool isLiked = false;
  late Map<String, int> sortedReactions;
  void _handleTapUp(TapUpDetails details) async {
    final now = DateTime.now();
    if (waitingForSecontTap &&firstTapTime != null &&
        now.difference(firstTapTime!) < const Duration(milliseconds: 300)) {
      
    } else {
      
     
    }
    firstTapTime = now;
  }

  void _handleLongPressStart() {
    if (doubleTapped) {
      setState(() {
        pauseVideo = !pauseVideo;
        showReactionsBox = true;
        print("SHOW THE REACTION BOX $showReactionsBox");
        print("PAUSE VIDEO $pauseVideo FROM THE SHOW BOX");
      });
    }
  }

  @override
  void initState() {
    fileList = widget.postResponseDto.fileUrls?.toList() ?? [];
    fileCount = fileList.length;
    if (fileCount > 1) {
      pageController = PageController(initialPage: 0);
    }
    rearrangeTheReactions();
    super.initState();
    _loadVideo();
  }

  void rearrangeTheReactions() {
    final entries =
        widget.postResponseDto.reactionCount?.entries.toList() ?? [];
    final likeEntry = entries.firstWhere((e) => e.key == "FIRE");
    entries.removeWhere((e) => e.key == "FIRE");
    entries.sort((a, b) => b.value.compareTo(a.value));
    sortedReactions = {
      likeEntry.key: likeEntry.value,
      for (final e in entries) e.key: e.value,
    };
  }

  Future<void> liked() async {}
  Future<void> comment() async {}
  Future<void> share() async {}

  @override
  void dispose() {
    pageController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Widget makeTheReactionsAndTheCounts() {
    final reactionsEntry = sortedReactions.entries.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(reactionsEntry.length, (index) {
        return makeAReactionAndACount(
          reactionsEntry.elementAt(index).key,
          reactionsEntry.elementAt(index).value,
        );
      }),
    );
  }

  Widget makeAReactionAndACount(String reaction, int count) {
    return Center(
      child: Column(
        children: [
          Text(
            "${reactions[reaction]}",
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          Text(
            "${count.toString()}",
            style: TextStyle(
              color: isDarkMode ? AppColors.primaryColor : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadVideo() async {
    // simulate load
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) setState(() => isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    bool isSingleFile = fileCount == 1;
    double width = MediaQuery.of(context).size.width;
    double postHeight = width < 501 ? width * 1.25 : double.infinity;
    print("File length $fileCount");
    return GestureDetector(
      onTapUp: _handleTapUp,
      // onLongPressStart: _handleLongPressStart,
      child: Container(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 501),
              child: Container(
                child: Row(
                  children: [
                    SizedBox(width: 2),
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${widget.postResponseDto.username}",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? AppColors.primaryColor
                                      : AppColors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "follow",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.linkColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${widget.postResponseDto.updatedAt.toString()}",
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 24,
                        width: 24,
                        child: Center(child: Icon(Icons.more_horiz)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 501,
                      maxHeight: 611.22,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          height: postHeight,
                          decoration: BoxDecoration(
                            color: isSingleFile ? Colors.black : null,
                            // border: Border.all(width: 0.5, color: Colors.white),
                          ),
                          alignment: Alignment.center,
                          child: Center(
                            child: isSingleFile
                                ? Text(
                                    isLoaded ? fileList.first : "Loading...",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                : PageView.builder(
                                    controller: pageController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fileCount,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.brown,
                                          // border: Border.all(
                                          //   width: 0.5,
                                          //   color: Colors.white,
                                          // ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          isLoaded
                                              ? fileList[index]
                                              : "Loading...",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                       isLiked? Center(
                          child: Text(
                            "$reacted",
                            style: GoogleFonts.poppins(fontSize: 50),
                          ),
                        ):SizedBox(),
                      ],
                    ),
                  ),
                  (!isSingleFile && width > 766)
                      ? Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          child: InkWell(
                            onTap: () {
                              if (currentPageIndex != 0) {
                                pageController.previousPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                                currentPageIndex--;
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Icon(Icons.arrow_left)),
                            ),
                          ),
                        )
                      : SizedBox(width: 0),
                  (!isSingleFile && width > 766)
                      ? Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              if (currentPageIndex < fileCount - 1) {
                                pageController.nextPage(
                                  duration: const Duration(microseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                                currentPageIndex++;
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Icon(Icons.arrow_right)),
                            ),
                          ),
                        )
                      : SizedBox(width: 0),
                  showReactionsBox
                      ? Positioned(
                          bottom: 5,
                          left: 5,
                          child: Container(
                            width: 250,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 501),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                isLiked = !isLiked;
                              });
                              await liked();
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              child: Center(
                                child: isLiked
                                    ? Text(
                                        "${reactions['FIRE']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 26,
                                        ),
                                      )
                                    : Icon(
                                        Icons.local_fire_department_outlined,
                                        size: 35,
                                        color: isDarkMode
                                            ? AppColors.primaryColor
                                            : AppColors.black,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () async {
                              await comment();
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              child: Center(
                                child: SvgPicture.asset(
                                  "comment-svgrepo-com.svg",
                                  color: isDarkMode
                                      ? AppColors.primaryColor
                                      : AppColors.dark,
                                  height: 50,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () async {
                              await share();
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 31,
                                  width: 31,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 3,
                                      color: isDarkMode
                                          ? AppColors.primaryColor
                                          : AppColors.black,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Transform.rotate(
                                    angle: 5.497,
                                    child: Icon(Icons.send, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    (sortedReactions != null)
                        ? Container(
                            width: 300,
                            child: makeTheReactionsAndTheCounts(),
                          )
                        : SizedBox(height: 0),
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
