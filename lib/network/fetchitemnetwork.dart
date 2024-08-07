import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemFetcher {
  final void Function(List<dynamic> items, bool isError, bool isLoadingMore) callback;

  ItemFetcher(this.callback);

  Future<void> fetchItems({bool loadMore = false}) async {
    final url = 'https://jsonplaceholder.typicode.com/posts';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> fetchedItems = json.decode(response.body);
        callback(fetchedItems, false, loadMore);
      } else {
        callback([], true, loadMore);
      }
    } catch (e) {
      callback([], true, loadMore);
    }
  }
}
