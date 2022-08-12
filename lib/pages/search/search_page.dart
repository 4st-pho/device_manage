import 'package:flutter/material.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/widgets/text_form_field/search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SearchTextField(
                  hintText: 'Search name user or team',
                  controller: _searchController,
                  type: TextInputType.text,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
