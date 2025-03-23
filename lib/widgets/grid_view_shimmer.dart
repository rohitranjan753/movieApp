import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/*
  This is a GridView Shimmer Widget.
  This widget is used to show shimmer effect in GridView.
  We will use this widget in search screen to show shimmer effect while loading data.
*/
class GridViewShimmer extends StatelessWidget {
  const GridViewShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: 6, // Number of shimmer items
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey[100]!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.white10,
                height: 200,
                width: 130,
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.7,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
      ),
    );
  }
}