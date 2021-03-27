String capitalizeString(String s) {
  String capitalizedString;
  try {
    capitalizedString = (s
        .trim()
        .split(" ")
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' '));
  } catch (e) {
    capitalizedString = s;
  }
  return capitalizedString;
}
