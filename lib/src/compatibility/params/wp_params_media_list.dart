import '../wp_constants.dart';

class ParamsMediaList {
  final WordPressContext context;
  final int pageNum;
  final int perPage;
  final String searchQuery;
  final String afterDate;
  final List<int> includeAuthorIDs;
  final List<int> excludeAuthorIDs;
  final String beforeDate;
  final List<int> excludeMediaIDs;
  final List<int> includeMediaIDs;
  final int? offset;
  final Order order;
  final MediaOrderBy orderBy;
  final List<int> includeParentIDs;
  final List<int> excludeParentIDs;
  final MediaStatus mediaStatus;
  final MediaType? mediaType;
  final String mimeType;

  ParamsMediaList({
    this.context = WordPressContext.view,
    this.pageNum = 1,
    this.perPage = 10,
    this.searchQuery = '',
    this.afterDate = '',
    this.includeAuthorIDs = const [],
    this.excludeAuthorIDs = const [],
    this.beforeDate = '',
    this.excludeMediaIDs = const [],
    this.includeMediaIDs = const [],
    this.offset,
    this.order = Order.desc,
    this.orderBy = MediaOrderBy.date,
    this.includeParentIDs = const [],
    this.excludeParentIDs = const [],
    this.mediaStatus = MediaStatus.inherit,
    this.mediaType,
    this.mimeType = '',
  });

  @override
  String toString() {
    return constructUrlParams({
      'context': enumStringToName(context.toString()),
      'page': pageNum.toString(),
      'per_page': perPage.toString(),
      'search': searchQuery,
      'after': afterDate,
      'author': listToUrlString(includeAuthorIDs),
      'author_exclude': listToUrlString(excludeAuthorIDs),
      'before': beforeDate,
      'exclude': listToUrlString(excludeMediaIDs),
      'include': listToUrlString(includeMediaIDs),
      'offset': offset?.toString() ?? '',
      'order': enumStringToName(order.toString()),
      'orderby': enumStringToName(orderBy.toString()),
      'parent': listToUrlString(includeParentIDs),
      'parent_exclude': listToUrlString(excludeParentIDs),
      'status': enumStringToName(mediaStatus.toString()),
      'media_type': mediaType != null
          ? enumStringToName(mediaType.toString())
          : '',
      'mime_type': mimeType,
    });
  }
}
