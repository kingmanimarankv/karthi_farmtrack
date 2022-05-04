class Ratings {
  late String testResult;
  late String ratingCode;
  late String soilTestParaId;
  late String soilTestName;

  Ratings(
      this.testResult, this.ratingCode, this.soilTestParaId, this.soilTestName);

  Ratings.fromJson(Map<String, dynamic> json) {
    testResult = json['Test_Result'];
    ratingCode = json['rating_code'];
    soilTestParaId = json['Soil_Test_Para_Id'];
    soilTestName = json['soil_test_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Test_Result'] = this.testResult;
    data['rating_code'] = this.ratingCode;
    data['Soil_Test_Para_Id'] = this.soilTestParaId;
    data['soil_test_name'] = this.soilTestName;
    return data;
  }
}
