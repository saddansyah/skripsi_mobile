String? textfieldValidator(String? value,
    {String message = 'Terjadi kesalahan input'}) {
  if (value == null || value.isEmpty) {
    return message;
  }
  return null;
}
