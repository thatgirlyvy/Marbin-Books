import 'package:flutter/material.dart';

class BookRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;

  const BookRating({super.key, this.value = 0, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) => IconButton(
        onPressed: onChanged != null ? () {
          onChanged(value == index + 1 ? index : index + 1);
        } : null,
        color: index < value ? Colors.amber : null,
        iconSize: 30,
        icon: Icon(
          index < value ? Icons.star : Icons.star_border 
        ),
        padding: EdgeInsets.zero,
      )),
    );
  }
}