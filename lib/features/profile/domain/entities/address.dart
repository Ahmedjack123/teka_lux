class Address {
  const Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    this.state,
    required this.country,
    this.postalCode,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String street;
  final String city;
  final String? state;
  final String country;
  final String? postalCode;
  final bool isDefault;

  String get displayText {
    final parts = <String>[street, city];
    if (state != null && state!.isNotEmpty) parts.add(state!);
    parts.add(country);
    if (postalCode != null && postalCode!.isNotEmpty) parts.add(postalCode!);
    return parts.join(', ');
  }

  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
