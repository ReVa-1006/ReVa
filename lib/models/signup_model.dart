/// Data model for new-user registration.
class SignupModel {
  final String fullName;
  final String username;
  final String? email;
  final String? phoneNumber;
  final String password;
  final String? role; // 'buyer' | 'seller' — set after role selection

  SignupModel({
    required this.fullName,
    required this.username,
    this.email,
    this.phoneNumber,
    required this.password,
    this.role,
  }) : assert(
          email != null || phoneNumber != null,
          'Either email or phone number must be provided.',
        );

  /// The contact identifier used for registration.
  String get identifier => email ?? phoneNumber ?? '';

  /// Whether the user registered with an email.
  bool get isEmailSignup => email != null && email!.isNotEmpty;

  /// Returns a copy with an updated role.
  SignupModel copyWith({String? role}) => SignupModel(
        fullName: fullName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        role: role ?? this.role,
      );

  /// Converts to a JSON map (e.g. to send to the backend).
  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'username': username,
        if (email != null) 'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        'password': password,
        if (role != null) 'role': role,
      };

  @override
  String toString() =>
      'SignupModel(username: $username, identifier: $identifier, role: $role)';
}
