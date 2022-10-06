List<dynamic> numericValueInputValidation<T>(
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
    return ['Invalid value entered !', null];
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
      return ['Value cannot be less than $minValue !', null];
    }
    if (result > (maxValue as num)) {
      return ['Value cannot be greater than $maxValue !', null];
    }
  }

  return [null, result];
}

enum NumericDataType {
  integerType,
  doubleType,
}
