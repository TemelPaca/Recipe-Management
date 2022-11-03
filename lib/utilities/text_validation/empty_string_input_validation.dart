String? emptyStringInputValidation(
  String? value,
) {
  if (value == null || value.isEmpty) {
    return "Can not be empty !";
  }
  return null;
}
