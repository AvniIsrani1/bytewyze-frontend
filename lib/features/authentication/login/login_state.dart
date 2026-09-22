class LoginState {
  final bool isSubmitting;
  final String? errorMessage;

  const LoginState({this.isSubmitting = false, this.errorMessage});

  // return new state while keeping remaining values unchanged
  LoginState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
