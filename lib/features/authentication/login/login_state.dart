class LoginState {
  final bool isSubmitting;
  final String? errorMessage;

  const LoginState({
    this.isSubmitting = false,
    this.errorMessage,
  });

  // return new state while keeping remaining values unchanged
  LoginState copyWith({
    bool? isSubmitting, 
    String? errorMessage
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}