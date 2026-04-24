/// Data model for user login.
///
/// Supports authentication via either email or phone number,
/// along with a password field.
class LoginModel {
  final String? email;
  final String? phoneNumber;
  final String password;

  LoginModel({
    this.email,
    this.phoneNumber,
    required this.password,
  }) : assert(
          email != null || phoneNumber != null,
          'Either email or phone number must be provided.',
        );

  /// The identifier used for login — returns email if available, otherwise phone number.
  String get identifier => email ?? phoneNumber ?? '';

  /// Whether the user is logging in with an email address.
  bool get isEmailLogin => email != null && email!.isNotEmpty;

  /// Whether the user is logging in with a phone number.
  bool get isPhoneLogin => phoneNumber != null && phoneNumber!.isNotEmpty;

  /// Creates a [LoginModel] from a JSON map.
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      password: json['password'] as String,
    );
  }

  /// Converts this [LoginModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'LoginModel(identifier: $identifier, isEmailLogin: $isEmailLogin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginModel &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(email, phoneNumber, password);
}
