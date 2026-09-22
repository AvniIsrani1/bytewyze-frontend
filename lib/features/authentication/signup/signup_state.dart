class SignupState {
  final bool isSubmitting;
  final String? errorMessage;

  const SignupState({
    this.isSubmitting = false,
    this.errorMessage,
  });

  // return new state while keeping remaining values unchanged
  SignupState copyWith({
    bool? isSubmitting, 
    String? errorMessage
  }) {
    return SignupState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}