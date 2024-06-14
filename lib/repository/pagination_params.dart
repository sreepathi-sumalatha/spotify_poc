// lib/pagination_params.dart

class PaginationParams {
  final int offset;
  final int limit;

  const PaginationParams({this.offset = 0, this.limit = 10});
}
