class GFR {
  late Null sampleId;
  late String districtCode;
  late Null groupCode;
  late String cropCode;
  late String varietyCode;
  late String seasonCode;
  late String soilTypeCode;
  late String irrigationCode;
  late String durationCode;
  late String gFRId;
  late String ratingCode;
  late String n;
  late String p;
  late String k;

  GFR(
      this.sampleId,
      this.districtCode,
      this.groupCode,
      this.cropCode,
      this.varietyCode,
      this.seasonCode,
      this.soilTypeCode,
      this.irrigationCode,
      this.durationCode,
      this.gFRId,
      this.ratingCode,
      this.n,
      this.p,
      this.k);

  GFR.fromJson(Map<String, dynamic> json) {
    sampleId = json['Sample_Id'];
    districtCode = json['District_Code'];
    groupCode = json['Group_Code'];
    cropCode = json['Crop_Code'];
    varietyCode = json['Variety_Code'];
    seasonCode = json['Season_Code'];
    soilTypeCode = json['Soil_type_code'];
    irrigationCode = json['Irrigation_Code'];
    durationCode = json['Duration_Code'];
    gFRId = json['GFR_Id'];
    ratingCode = json['Rating_Code'];
    n = json['N'];
    p = json['P'];
    k = json['K'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Sample_Id'] = this.sampleId;
    data['District_Code'] = this.districtCode;
    data['Group_Code'] = this.groupCode;
    data['Crop_Code'] = this.cropCode;
    data['Variety_Code'] = this.varietyCode;
    data['Season_Code'] = this.seasonCode;
    data['Soil_type_code'] = this.soilTypeCode;
    data['Irrigation_Code'] = this.irrigationCode;
    data['Duration_Code'] = this.durationCode;
    data['GFR_Id'] = this.gFRId;
    data['Rating_Code'] = this.ratingCode;
    data['N'] = this.n;
    data['P'] = this.p;
    data['K'] = this.k;
    return data;
  }
}
