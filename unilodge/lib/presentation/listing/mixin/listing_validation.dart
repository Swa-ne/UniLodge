mixin InputValidationMixin {
  String? validateNumber(String value) {
    final numericRegex = RegExp(r'^[0-9]+$');
    if (value.isEmpty) {
      return 'This field is required';
    } else if (!numericRegex.hasMatch(value)) {
      return 'Please enter a valid number';
    }
    return null;
  }
   String? validateMinLength(String value, int minLength) {
    if (value.isEmpty) {
      return 'This field is required';
    } else if (value.length < minLength) {
      return 'Must be at least $minLength characters long';
    }
    return null;
  }
  String? validateStreet(String value) {
  if (value.length < 5) {
    return 'Street must be at least 5 characters long';
  }
  final validCharacters = RegExp(r'^[a-zA-Z0-9\s-]+$');
  if (!validCharacters.hasMatch(value)) {
    return 'Street can only contain letters, numbers, spaces, and hyphens';
  }
  
  return null; 
}
String? validateTextAndNumbers(String value) {
  final textAndNumbersRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
  if (value.isEmpty) {
    return 'Property Name is required';
  } else if (!textAndNumbersRegex.hasMatch(value)) {
    return 'Property Name should contain only letters, numbers, and spaces';
  }
  return null;
}

String? validatepropertyName(String value) {
  final textAndNumbersRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
  
  if (value.isEmpty) {
    return 'Property Name is required';
  } else if (value.length < 5) {
    return 'Property Name should be at least 5 characters long';
  } else if (!textAndNumbersRegex.hasMatch(value)) {
    return 'Property Name should contain only letters, numbers, and spaces';
  }
  
  return null;

  
}
String? validateDescription(String value) {
    if (value.isEmpty) {
      return 'Description is required';
    } else if (value.length < 10) {
      return 'Description should be at least 10 characters long';
    }
    return null;
  }
String? validateLeaseTerms(String value) {
    if (value.isEmpty) {
      return 'Lease terms are required';
    } else if (value.length < 10) {
      return 'Lease terms should be at least 10 characters long';
    }
    return null;
  }


}
