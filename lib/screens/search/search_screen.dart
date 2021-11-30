import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../models/entry.dart';
import '../../redux/appstate.dart';
import '../../widgets/home_list_item.dart';

class SearchScreen extends StatefulWidget {
  final bool autofillLaunch;

  SearchScreen({@required this.autofillLaunch});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';
  RegExp searchRegex;

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchTerm = searchController.text;
        searchRegex = RegExp(
          '.*$searchTerm.*',
          multiLine: true,
          caseSensitive: false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<AppState>(context).entries.entries;

    final filteredEntries = searchTerm.isEmpty
        ? <Entry>[]
        : entries.where((e) {
            return searchRegex.hasMatch(e.name) ||
                searchRegex.hasMatch(e.note) ||
                searchRegex.hasMatch(e.username);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: context.getString('back_tooltip'),
          icon: Icon(Feather.x_circle),
        ),
        title: TextFormField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: context.getString('search'),
          ),
        ),
      ),
      body: searchTerm.isEmpty
          ? Center(
              child: Text(
              context.getString('type_to_start_searching'),
            ))
          : filteredEntries.isEmpty
              ? Center(
                  child: Text(
                  'Nothing found...',
                ))
              : ListView.builder(
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, i) => HomeListItem(
                    entry: filteredEntries[i],
                    autofillLaunch: widget.autofillLaunch,
                    onReturnFromDetails: () {},
                  ),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
