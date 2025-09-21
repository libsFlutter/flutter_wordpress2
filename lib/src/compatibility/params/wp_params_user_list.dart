import '../wp_constants.dart';

class ParamsUserList {
  final WordPressContext context;
  final int pageNum;
  final int perPage;
  final String searchQuery;
  final List<int> excludeUserIDs;
  final List<int> includeUserIDs;
  final int? offset;
  final Order order;
  final UsersOrderBy orderBy;
  final String slug;
  final List<String> roles;

  ParamsUserList({
    this.context = WordPressContext.view,
    this.pageNum = 1,
    this.perPage = 10,
    this.searchQuery = '',
    this.excludeUserIDs = const [],
    this.includeUserIDs = const [],
    this.offset,
    this.order = Order.asc,
    this.orderBy = UsersOrderBy.name,
    this.slug = '',
    this.roles = const [],
  });

  @override
  String toString() {
    return constructUrlParams({
      'context': enumStringToName(context.toString()),
      'page': pageNum.toString(),
      'per_page': perPage.toString(),
      'search': searchQuery,
      'exclude': listToUrlString(excludeUserIDs),
      'include': listToUrlString(includeUserIDs),
      'offset': offset?.toString() ?? '',
      'order': enumStringToName(order.toString()),
      'orderby': enumStringToName(orderBy.toString()),
      'slug': slug,
      'roles': listToUrlString(roles),
    });
  }
}
