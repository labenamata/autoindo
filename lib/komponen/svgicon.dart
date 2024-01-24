import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

Widget svgicon({required String url}) {
  final Widget networkSvg = SvgPicture.network(url,
      width: 70,
      height: 70,
      semanticsLabel: 'A shark?!',
      placeholderBuilder: (BuildContext context) => SizedBox(
            height: 70,
            width: 70,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.5),
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
              ),
            ),
          ));
  return networkSvg;
}
