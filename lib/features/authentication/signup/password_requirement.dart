class PasswordRequirement {
  final String label;
  final bool Function(String password) isSatisfied;

  const PasswordRequirement({required this.label, required this.isSatisfied});

  static final List<PasswordRequirement> all = [
    PasswordRequirement(
      label: 'At least 10 characters',
      isSatisfied: (password) => password.length >= 10,
    ),
    PasswordRequirement(
      label: 'One uppercase letter',
      isSatisfied: (password) => password.contains(RegExp(r"[A-Z]")),
    ),
    PasswordRequirement(
      label: 'One lowercase letter',
      isSatisfied: (password) => password.contains(RegExp(r"[a-z]")),
    ),
    PasswordRequirement(
      label: 'One number',
      isSatisfied: (password) => password.contains(RegExp(r"[0-9]")),
    ),
    PasswordRequirement(
      label: 'One special character',
      isSatisfied: (password) => password.contains(RegExp(r"[^A-Za-z0-9]")),
    ),
  ];

  // every rule the given password fails
  static List<PasswordRequirement> unmetBy(String password) =>
      all.where((requirement) => !requirement.isSatisfied(password)).toList();
}
