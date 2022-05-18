class PetData {
  String pet; // 동물종류
  String startDay; //공고 시작일
  String discovery; //동물 발견장소
  String condition; //동물 상태
  String color; //동물 색상
  String subImage; //이미지 섬네일
  String mainImage; // 본 이미지
  String character; //발견특징

  PetData(
      {required this.character,
      required this.startDay,
      required this.color,
      required this.condition,
      required this.discovery,
      required this.mainImage,
      required this.pet,
      required this.subImage});

  factory PetData.fromJson(Map<String, dynamic> json) {
    return PetData(
        character: json["PARTCLR_MATR"] ?? "값이 비어있습니다.",
        startDay: json["PBLANC_BEGIN_DE"].toString(),
        color: json["COLOR_NM"].toString(),
        condition: json["SFETR_INFO"] ?? "",
        discovery: json["DISCVRY_PLC_INFO"].toString(),
        mainImage: json["IMAGE_COURS"].toString(),
        pet: json["SPECIES_NM"].toString(),
        subImage: json["THUMB_IMAGE_COURS"].toString());
  }
}
