import '../models/validator.dart';

/// [UrlValidator] uses dart's [Uri] to parse the input and return its validity
class URLValidator implements Validator {
  @override
  bool validate(String input) {
    try {
      Uri.parse(input);

      return true;
    } catch (e) {
      /// It throws a [FormatException] when the URL is not valid
      return false;
    }
  }
}
