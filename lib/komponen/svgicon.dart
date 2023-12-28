import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

Widget svgicon({required String url}) {
  final Widget networkSvg = SvgPicture.network(url,
      semanticsLabel: 'A shark?!',
      placeholderBuilder: (BuildContext context) => SizedBox(
            height: 30,
            width: 30,
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
