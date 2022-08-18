import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/search_bloc/search_bloc.dart';
import 'package:manage_devices_app/helper/unfocus.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:manage_devices_app/widgets/text_form_field/search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  final _searchBloc = SearchBloc();
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBloc.dispose();
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
                _buildSearchTextField(context),
                const SizedBox(height: 20),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildContent() {
    return Expanded(
      child: StreamBuilder<List<String>>(
        stream: _searchBloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _searchBloc.onSubmitted(context,
                        value: data[index], textController: _searchController),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data[index]),
                      ),
                    ]),
                  );
                });
          } else {
            return  ShimmerList.listResult;
          }
        },
      ),
    );
  }

  SearchTextField _buildSearchTextField(BuildContext context) {
    return SearchTextField(
      hintText: 'Search name user or team',
      controller: _searchController,
      onChanged: _searchBloc.onTextChange,
      onSuffixPresses: () {
        _searchBloc.onSubmitted(context);
      },
      onSubmitted: (_) => _searchBloc.onSubmitted(context),
    );
  }
}
