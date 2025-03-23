import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/*
  This is a MovieCard Shimmer Widget.
  This widget is used to show shimmer effect in MovieCard.
  We will use this widget in home screen to show shimmer effect while loading data.
*/
class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5, // Placeholder for shimmer loading
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}