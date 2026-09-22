class SignupState {
  final bool isSubmitting;
  final String? errorMessage;

  const SignupState({this.isSubmitting = false, this.errorMessage});

  // return new state while keeping remaining values unchanged
  SignupState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignupState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
