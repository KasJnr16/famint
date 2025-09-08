class UniValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required.";
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return "Invalid email address.";
    }
    return null;
  }

  static String? validatePAssword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }

    if (value.length < 6) {
      return "Password must be atleast 6 characters long.";
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain atleast one special character.";
    }

    return null;
  }

  static String? validatePhoneNumner(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required.";
    }

    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return "Invalid phone number format (10 digits required).";
    }

    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required.";
    }

    if (value.length < 3) {
      return "Username should be atleast 4 characters.";
    }

    return null;
  }

  static String? validateEmptyText(String? filename, String? value) {
    if (value == null || value.isEmpty) {
      return "$filename is required.";
    }
    return null;
  }
}
