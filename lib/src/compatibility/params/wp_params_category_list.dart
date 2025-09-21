import '../wp_constants.dart';

class ParamsCategoryList {
  final WordPressContext context;
  final int pageNum;
  final int perPage;
  final String searchQuery;
  final List<int> excludeCategoryIDs;
  final List<int> includeCategoryIDs;
  final Order order;
  final CategoryTagOrderBy orderBy;
  final bool? hideEmpty;
  final int? parent;
  final int? post;
  final String slug;

  ParamsCategoryList({
    this.context = WordPressContext.view,
    this.pageNum = 1,
    this.perPage = 10,
    this.searchQuery = '',
    this.excludeCategoryIDs = const [],
    this.includeCategoryIDs = const [],
    this.order = Order.asc,
    this.orderBy = CategoryTagOrderBy.name,
    this.hideEmpty,
    this.parent,
    this.post,
    this.slug = '',
  });

  ParamsCategoryList copyWith({int? pageNum, int? perPage}) {
    return ParamsCategoryList(
      context: context,
      pageNum: pageNum ?? this.pageNum,
      perPage: perPage ?? this.perPage,
      searchQuery: searchQuery,
      excludeCategoryIDs: excludeCategoryIDs,
      includeCategoryIDs: includeCategoryIDs,
      order: order,
      orderBy: orderBy,
      hideEmpty: hideEmpty,
      parent: parent,
      post: post,
      slug: slug,
    );
  }

  @override
  String toString() {
    return constructUrlParams({
      'context': enumStringToName(context.toString()),
      'page': pageNum.toString(),
      'per_page': perPage.toString(),
      'search': searchQuery,
      'exclude': listToUrlString(excludeCategoryIDs),
      'include': listToUrlString(includeCategoryIDs),
      'order': enumStringToName(order.toString()),
      'orderby': enumStringToName(orderBy.toString()),
      'hide_empty': hideEmpty?.toString() ?? '',
      'parent': parent?.toString() ?? '',
      'post': post?.toString() ?? '',
      'slug': slug,
    });
  }
}
