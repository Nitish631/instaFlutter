import 'dart:convert';

class PostResponseDto {
  final int? postId;
  final String? title;
  final String? contentDescription;
  final bool? postPrivate;
  final bool? allowComments;
  final bool? isReel;
  final int? userId;
  final String? username;
  final String? userProfileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Set<String>? fileUrls;
  final Set<int>? mainCategoryIds;
  final Set<int>? subCategoryIds;
  final int? commentCount;
  final Map<String, int>? reactionCount;

  PostResponseDto({
    this.postId,
    this.title,
    this.contentDescription,
    this.postPrivate,
    this.allowComments,
    this.isReel,
    this.userId,
    this.username,
    this.userProfileUrl,
    this.createdAt,
    this.updatedAt,
    this.fileUrls,
    this.mainCategoryIds,
    this.subCategoryIds,
    this.commentCount,
    this.reactionCount,
  });

  factory PostResponseDto.fromJson(Map<String, dynamic> json) {
    return PostResponseDto(
      postId: json['postId'] as int?,
      title: json['title'] as String?,
      contentDescription: json['contentDescription'] as String?,
      postPrivate: json['postPrivate'] as bool?,
      allowComments: json['allowComments'] as bool?,
      isReel: json['isReel'] as bool?,
      userId: json['userId'] as int?,
      username: json['username'] as String?,
      userProfileUrl: json['userProfileUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      fileUrls: json['fileUrls'] != null
          ? Set<String>.from(json['fileUrls'])
          : null,
      mainCategoryIds: json['mainCategoryIds'] != null
          ? Set<int>.from(json['mainCategoryIds'])
          : null,
      subCategoryIds: json['subCategoryIds'] != null
          ? Set<int>.from(json['subCategoryIds'])
          : null,
      commentCount: json['commentCount'] as int?,
      reactionCount: json['reactionCount'] != null
          ? Map<String, int>.from(json['reactionCount'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'title': title,
      'contentDescription': contentDescription,
      'postPrivate': postPrivate,
      'allowComments': allowComments,
      'isReel': isReel,
      'userId': userId,
      'username': username,
      'userProfileUrl': userProfileUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'fileUrls': fileUrls?.toList(),
      'mainCategoryIds': mainCategoryIds?.toList(),
      'subCategoryIds': subCategoryIds?.toList(),
      'commentCount': commentCount,
      'reactionCount': reactionCount,
    };
  }
}