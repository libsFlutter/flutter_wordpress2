import '../wp_constants.dart';

class ParamsTagList {
  final WordPressContext context;
  final int pageNum;
  final int perPage;
  final String searchQuery;
  final List<int> excludeTagIDs;
  final List<int> includeTagIDs;
  final int? offset;
  final Order order;
  final CategoryTagOrderBy orderBy;
  final bool? hideEmpty;
  final int? post;
  final String slug;

  ParamsTagList({
    this.context = WordPressContext.view,
    this.pageNum = 1,
    this.perPage = 10,
    this.searchQuery = '',
    this.excludeTagIDs = const [],
    this.includeTagIDs = const [],
    this.offset,
    this.order = Order.asc,
    this.orderBy = CategoryTagOrderBy.name,
    this.hideEmpty,
    this.post,
    this.slug = '',
  });

  @override
  String toString() {
    return constructUrlParams({
      'context': enumStringToName(context.toString()),
      'page': pageNum.toString(),
      'per_page': perPage.toString(),
      'search': searchQuery,
      'exclude': listToUrlString(excludeTagIDs),
      'include': listToUrlString(includeTagIDs),
      'offset': offset?.toString() ?? '',
      'order': enumStringToName(order.toString()),
      'orderby': enumStringToName(orderBy.toString()),
      'hide_empty': hideEmpty?.toString() ?? '',
      'post': post?.toString() ?? '',
      'slug': slug,
    });
  }
}
