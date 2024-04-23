import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget textTimeAgo({required DateTime dateTime, TextStyle? style}) {
  return Text(
    timeago.format(dateTime, allowFromNow: true),
    style: style,
  );
}
