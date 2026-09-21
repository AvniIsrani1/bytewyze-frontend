class User {
  String id; // uuid
  String firstName;
  String lastName;
  String email;
  String phoneNumber;

  // need to add preferences and other profile info here too

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });
}
