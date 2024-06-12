import 'package:flutter/material.dart';

import 'enums.dart';

extension BuildContextX on BuildContext {
  /// [style] shorten syntax for textTheme
  TextTheme get style => Theme.of(this).textTheme;
}

extension CowBreedStringX on CowBreed {
  /// [name] retrieve CowBreed string value
  String name() {
    return switch (this) {
      CowBreed.jersey => 'Jersey',
      CowBreed.limousin => 'Limousin',
      CowBreed.hallikar => 'Hallikar',
      CowBreed.hereford => 'Hereford',
      CowBreed.holstein => 'Holstein',
      CowBreed.simmental => 'Simmental',
    };
  }

  /// [price] retrieve CowBreed price
  String price() {
    return switch (this) {
      CowBreed.jersey => '1000 LINERA',
      CowBreed.limousin => '1000 LINERA',
      CowBreed.hallikar => '1000 LINERA',
      CowBreed.hereford => '5000 LINERA',
      CowBreed.holstein => '15000 LINERA',
      CowBreed.simmental => '15000 LINERA',
    };
  }

  /// [imageURL] retrieve CowBreed image asset path
  String imageURL() {
    return switch (this) {
      CowBreed.jersey => 'assets/jersey.png',
      CowBreed.limousin => 'assets/limousin.png',
      CowBreed.hallikar => 'assets/hallikar.png',
      CowBreed.hereford => 'assets/hereford.png',
      CowBreed.holstein => 'assets/holstein.png',
      CowBreed.simmental => 'assets/simmental.png',
    };
  }
}

extension CowGenderX on CowGender {
  /// [imageURL] retrieve CowGender image asset path
  String imageURL() {
    return switch (this) {
      CowGender.male => 'assets/male.png',
      CowGender.female => 'assets/female.png',
    };
  }
}
