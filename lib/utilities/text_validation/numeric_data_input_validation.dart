String? numericValueInputValidation<T>(
  String? value,
  NumericDataType dataType,
  T minValue,
  T maxValue,
) {
  RegExp exp = RegExp(
      r'(^[\+]?\d+[,|.]?\d+$)|(^[-]?\d+[,|.]?\d+$)|(^\d+[,|.]?\d+$)|(^[0-9\ ]+$)');

  String? matchedVal;
  T? result;

  if (value != null) matchedVal = exp.stringMatch(value);

  if (matchedVal == null) {
    return 'Invalid value entered !';
  } else {
    switch (dataType) {
      case NumericDataType.integerType:
        result = int.tryParse(matchedVal) as T;
        break;
      case NumericDataType.doubleType:
        result = double.tryParse(matchedVal) as T;
        break;
    }

    if (result as num < (minValue as num)) {
      return 'Value cannot be less than $minValue !';
    }
    if (result > (maxValue as num)) {
      return 'Value cannot be greater than $maxValue !';
    }
  }

  return null;
}

enum NumericDataType {
  integerType,
  doubleType,
}
