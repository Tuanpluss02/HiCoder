import 'package:dio/dio.dart';
import 'package:hicoder/models/post.dart';
import 'package:hicoder/services/api_service.dart';

class PostService {
  Future<PostModel> createPost(
      {required String content, String? mediaUrl}) async {
    Response response = await ApiService().getDio.post("/post", data: {
      "content": content,
      "mediaUrl": mediaUrl,
    });
    if (response.statusCode == 200) {
      return PostModel.fromJson(response.data["body"]);
    } else {
      throw Exception(response.data["message"]);
    }
  }

  Future<List<PostModel>> fetchPosts() async {
    Response response = await ApiService().getDio.get("/post/newsfeed");
    if (response.statusCode == 200) {
      List<PostModel> posts = [];
      response.data["body"].forEach((post) {
        posts.add(PostModel.fromJson(post));
      });
      return posts;
    } else {
      throw Exception(response.data["message"]);
    }
  }
}
