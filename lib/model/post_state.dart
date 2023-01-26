

class Like{
  final int likes;
  final List<String> usernames;

  Like({
    required this.likes,
    required this.usernames
  });

  factory Like.fromJson(Map<String, dynamic> json){
    return Like(
        likes: json['likes'],
        usernames: (json['usernames'] as List).map((e) => e as String).toList()
    );
  }

}

class Comment{
  final String username;
  final String comment;
  final String imageUrl;

  Comment({

    required this.username,
    required this.comment,
    required this.imageUrl

  });

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
        username: json['username'],
        comment: json['comment'],
        imageUrl: json['imageUrl']);
  }
  Map<String,dynamic> toJson(){

    return {
      'comments' : this.comment,
      'imageUrl' : this.imageUrl,
      'username':this.username
    };
  }

}

class Post{
  final String id;
  final String imageUrl;
  final String caption;
  final String userId;
  final Like like;
  final List<Comment> comments;

  Post({
    required this.imageUrl,
    required this.like,
    required this.userId,
    required this.caption,
    required this.id,
    required this.comments
  });


}