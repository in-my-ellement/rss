import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

import './edit.dart';
import '../services/rss.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RSS Reader"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh feed",
            onPressed: () => setState(() {})
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FutureBuilder(
            builder: (BuildContext ctxt, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                //print(allItems.length);
                var all = List<RssItem>();
                snapshot.data.forEach((feed) {
                  all.addAll(feed.items);
                });

                all.sort((a, b) {
                  return -DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US').parse(a.pubDate).compareTo(DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US').parse(b.pubDate));
                });

                return Expanded(
                  child: ListView.builder(
                    itemCount: all.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                        return ListTile(
                          title: Text(all[index].title),
                          subtitle: Text(all[index].author ?? "Unknown author" + " | " + all[index].pubDate ?? "Unknown date"),
                          trailing: IconButton(
                            icon: Icon(Icons.content_copy),
                            tooltip: "Copy link to post",
                            onPressed: () {
                              ClipboardManager.copyToClipBoard(all[index].link);
                            }
                          ),
                          contentPadding: EdgeInsets.all(16.0),
                          onTap: () {
                            launch(all[index].link);
                          }
                        );
                    },
                  )
                );
              }
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            },
            future: getFeedsAsList()
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Redirect to edit page screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditPage())
          );
        }
      ),
    );
  }
}
