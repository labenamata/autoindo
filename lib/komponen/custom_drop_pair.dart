import 'package:auto_indo/model/pair.dart';
import 'package:flutter/material.dart';

Widget customDropPair(BuildContext context, Pair item, bool isSelected) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item.name!),
      //subtitle: Text(item.createdAt.toString()),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(item.image!),
      ),
    ),
  );
}
