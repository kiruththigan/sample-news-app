import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onSearch;
  final TextEditingController? controller;

  const SearchInput({
    Key? key,
    required this.onChanged,
    required this.onSearch,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              hintText: "🔍 Search news...",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all( width: 1),
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          child: IconButton(
            onPressed: onSearch,
            icon: const Icon(Icons.search),
          ),
        ),

      ],
    );
  }
}
