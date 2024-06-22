String formatAccountNumber(String bankCode, String accountNumber) {
  final String accountNumberFormatted;
  switch (bankCode) {
    case "014":
    case "501":
    case "536":
      // Implement formatting for Bank Central Asia
      accountNumberFormatted = accountNumber
          .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    case "008":
    case "451":
    case "564":
      // Implement formatting for Bank Mandiri
      accountNumberFormatted = accountNumber
          .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    default:
      // Default formatting, no changes
      accountNumberFormatted = accountNumber
          .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");

  }
  return accountNumberFormatted.trimRight();;
}
