import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moyai_test_libraries/Retrofit/post_model.dart';

class Home extends StatelessWidget {
  const Home ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1D1E22),
        title: const Text('Test App'),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  FutureBuilder _body(){
    final apiService = ApiService(Dio(BaseOptions(contentType: "application/json")));
    return FutureBuilder(
      future: apiService.getPosts(),
      builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          final List<PostModel> posts = snapshot.data!;
          return _posts(posts);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Widget _posts(List<PostModel> posts){
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index){
        return Container (
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black38, width: 1),
          ),
          child: Column(
            children: [
              Text(
                posts[index].title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                posts[index].title
              )
            ],
          )
        )
      },
    )
  }
}