import 'package:flutter/material.dart';
import 'package:taskbinrashideg/screens/itemdetailsscreen.dart';
import '../core/globalfunction.dart';
import '../network/fetchitemnetwork.dart';


class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  List items = [];
  List filteredItems = [];
  bool isLoading = true;
  bool isError = false;
  bool isLoadingMore = false;
  int page = 1;
  TextEditingController searchController = TextEditingController();
  late ItemFetcher itemFetcher;

  @override
  void initState() {
    super.initState();
    itemFetcher = ItemFetcher((fetchedItems, error, loadMore) {
      setState(() {
        if (loadMore) {
          items.addAll(fetchedItems);
        } else {
          items = fetchedItems;
        }
        filteredItems = items;
        isLoading = false;
        isLoadingMore = false;
        isError = error;
      });
    });
    fetchItems();
    searchController.addListener(() {
      filterItems();
    });
  }

  void fetchItems({bool loadMore = false}) {
    itemFetcher.fetchItems(loadMore: loadMore);
  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = items.where((item) {
        return item['title'].toString().toLowerCase().contains(query) ||
            item['body'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  void loadMoreItems() {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
        page++;
      });
      fetchItems(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Item List'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Item List'),
        ),
        body: Center(
          child: Text('Failed to load items'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 15.0,top: 10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                focusColor: Colors.teal.shade900,
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(25)
                  ),

                ),
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                    !isLoadingMore) {
                  loadMoreItems();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: filteredItems.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == filteredItems.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final item = filteredItems[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0,left: 10.0),
                        child: Container(
                                          padding: EdgeInsets.only(right: 15.0,left: 15.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.teal.shade900,
                              Colors.teal.shade700,
                              Colors.teal.shade500,
                            ]),
                            borderRadius: BorderRadius.all(
                                Radius.circular(25)
                            ),
                          ),
                          child: ListTile(
                            title: Text(item['title'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                            subtitle: Text(item['body'],style: TextStyle(fontSize: 15,color: Colors.white),),
                            onTap: () {
                              Navigator.push(context, GlobalFunction.route(ItemDetailsScreen(item: item),),);

                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),

                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
