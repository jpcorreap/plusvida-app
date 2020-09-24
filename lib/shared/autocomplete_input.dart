import "package:flutter/material.dart";
import 'dart:convert';

class DataSearch extends SearchDelegate<String> {
  final List data;
  DataSearch(this.data);

  @override
  // What actions can I perform on app bar
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  // Left leading icon on the app bar
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  // What is shown with someone searches for anything
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? data
        : data
            .where((element) =>
                element["value"].toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          // It comes back to the previous screen
          Navigator.pop(context, jsonEncode(suggestionList[index]));
        },
        leading: Icon(
          Icons.check_circle,
          color: Color(0xff0066d0),
        ),
        title: Text(
          suggestionList[index]["value"],
          style: TextStyle(
              color: Color(0xff0066d0),
              fontWeight: FontWeight.normal,
              fontFamily: "Lato"),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}
