class CustomException {
  final String? message;
  final Map? errors;

  CustomException({this.message = null, this.errors = null});

  factory CustomException.fromJson(Map<String, dynamic> json) {
    return CustomException(
      message: json['message'],
      errors: json['errors'],
    );
  }

  set state(CustomException state) {}
}
