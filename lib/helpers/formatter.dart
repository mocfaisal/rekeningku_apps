String formatAccountNumber(String bankName, String accountNumber) {
  switch (bankName) {
    case 'Bank Central Asia':
      // Implement formatting for Bank Central Asia
      return accountNumber.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    case 'Bank Mandiri':
      // Implement formatting for Bank Mandiri
      return accountNumber.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    case 'Bank Negara Indonesia':
      // Implement formatting for Bank Negara Indonesia
      return accountNumber.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    case 'Bank Rakyat Indonesia':
      // Implement formatting for Bank Rakyat Indonesia
      return accountNumber.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
    default:
      // Default formatting, no changes
      return accountNumber;
  }
}
