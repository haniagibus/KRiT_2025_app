import 'package:flutter/material.dart';

class SearchBarApp extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const SearchBarApp({super.key, this.onChanged});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  bool isDark = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            // onTap: () {
            //  controller.openView();
            // },
            onChanged: (value) {
             // controller.openView();
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'Item $index';
            return ListTile(
              title: Text(item),
              // onTap: () {
              //   controller.closeView(item);
              // },
            );
          });
        },
      ),
    );
  }
}

