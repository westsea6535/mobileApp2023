import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  final List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int idx) {
          return Column(
            children: [
              Container(
                  width: 350.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.3),
                          offset: const Offset(0, 3),
                          blurRadius: 5.0
                      )
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.white,
                  )
              ),
              SizedBox(height: 10.0),
            ],
          );
        },
      )
    );
  }
}