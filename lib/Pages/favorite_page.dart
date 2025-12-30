import 'package:first_flutter_project01/models/apod_data.dart';
import 'package:first_flutter_project01/models/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/astro_picture.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<FavoriteState>(
        builder: (context, favoriteState, child) {
          List<ApodData> list = favoriteState.favoriteList;
          return list.isNotEmpty
              ? ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 100,
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                      height: 100,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Scaffold(
                                    appBar: AppBar(
                                      title: Text(list[index].date),
                                    ),
                                    body: ChangeNotifierProvider.value(
                                        value: favoriteState,
                                      child: AstroPicture(apodData: list[index]),
                                    )
                                ); // 要填什麼資料進去呢？？
                              }));
                        },
                        child: Card(
                            elevation: 5.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(list[index].date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400]
                                ),),
                                Text(list[index].title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),)
                              ],
                            )
                        ),
                      )));
            },
            itemCount: favoriteState.favoriteList.length,
          )
          : Center(
            child: Text(
              '目前沒有收藏',
              style: TextStyle(fontSize: 30, color: Colors.grey[400]),
            ),
          );

        }));
  }
}