class UniFirebaseAuthException implements Exception {
  final String code;
  UniFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already in use. Please use a different email.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try aagin.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'Invalid login details. User not found';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-credential':
        return 'Invalid login details. Please check your credentials and try again.';
      case 'network-request-failed':
        return 'Network error occurred. Please check your connection.';
      case 'internal-error':
        return 'An internal error occurred. Please try again.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'unknown':
        return 'An unknown error occurred. Please try again.';
      default:
        return 'This $code error occurred. Please try again.';
    }
  }
}

class UniFirebaseException implements Exception {
  final String code;
  UniFirebaseException(this.code);

  String get message {
    switch (code) {
      case 'aborted':
        return 'The operation was aborted. Please try again.';
      case 'already-exists':
        return 'The resource you are trying to create already exists.';
      case 'cancelled':
        return 'The operation was cancelled. Please try again.';
      case 'data-loss':
        return 'Data loss occurred. Please try again later.';
      case 'deadline-exceeded':
        return 'The operation took too long. Please check your connection.';
      case 'failed-precondition':
        return 'The operation failed due to a failed precondition.';
      case 'internal':
        return 'An internal error occurred. Please try again.';
      case 'invalid-argument':
        return 'An invalid argument was provided. Please check your input.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'out-of-range':
        return 'The provided data is out of range. Please correct it.';
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'resource-exhausted':
        return 'The resource has been exhausted. Please try again later.';
      case 'unauthenticated':
        return 'You need to be authenticated to perform this action.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'unimplemented':
        return 'The operation is not implemented or supported.';
      case 'unknown':
        return 'An unknown error occurred. Please try again.';
      default:
        return 'This $code error occurred. Please try again.';
    }
  }
}

class UniFormatException implements Exception {
  String? code;
  UniFormatException({this.code});

  String get message {
    return 'There was a formatting issue: $code';
  }
}

class UniPlatformException implements Exception {
  final String code;
  UniPlatformException(this.code);

  String get message {
    switch (code) {
      case 'channel-error':
        return 'Unable to establish connection with Google. Please try again later.';
      case 'unknown':
        return 'An unknown error occurred. Please try again.';
      default:
        return 'This $code error occurred. Please try again.';
    }
  }
}
