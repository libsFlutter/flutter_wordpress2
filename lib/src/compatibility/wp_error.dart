/// WordPress Error Compatibility Class
///
/// Maintains backward compatibility with the original flutter_wordpress library
/// error handling system.

class WordPressError implements Exception {
  String? code;
  String? message;
  Map<String, dynamic>? data;

  WordPressError({this.code, this.message, this.data});

  WordPressError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }

  @override
  String toString() {
    return 'WordPressError{code: $code, message: $message, data: $data}';
  }
}
