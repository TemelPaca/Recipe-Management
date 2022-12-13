String? emailInputValidation<T>(
  String? value,
) {
  RegExp exp = RegExp(r'(^([\w\.\-_]+)?\w+@[\w-_]+(\.\w+){1,}$)');

  String? matchedVal;

  if (value != null) matchedVal = exp.stringMatch(value);

  if (matchedVal == null) {
    return 'Invalid value entered !';
  } else {
    return null;
  }
}
