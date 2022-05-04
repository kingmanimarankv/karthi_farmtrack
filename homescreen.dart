import 'dart:convert';

import 'package:farmtrack/models/fertilizers.dart';
import 'package:farmtrack/models/gfr.dart';
import 'package:farmtrack/models/rating.dart';
import 'package:farmtrack/models/values.dart';
import 'package:farmtrack/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _height = 0.0;
  final _width = 0.0;
  bool _loading = false;

  bool _isFormFetched = false;
  bool _isfertilizerFetched = false;
  bool _isWeatherFetched = false;

  List<Values> districts = [];
  var _districtSelected = null;

  final TextEditingController _availableNitrogenController =
      TextEditingController();
  final TextEditingController _availablePhosphorousController =
      TextEditingController();
  final TextEditingController _availablePottassiumController =
      TextEditingController();

  late String availableNitrogen;
  late String availablePhosphorous;
  late String availablePottassium;

  List<Ratings> ratings = [];

  List<Values> irrigationTypes = [];
  var _irrigationSelected = null;

  List<Values> soilTypes = [];
  var _soilTypeSelected = null;

  List<Values> durations = [];
  var _durationSelected = null;

  List<Values> seasons = [];
  var _seasonSelected = null;

  List<Values> crops = [];
  var _cropSelected = null;

  List<GFR> gfrs = [];

  List<Fertilizers> nitrogenFertilizers = [
    Fertilizers(1, 1, 20.6000, 0.0000, 0.0000, "Ammonium Sulphate"),
    Fertilizers(
        1, 2, 46.0000, 0.0000, 0.0000, "Urea(46 % N)(While free flowing)"),
    Fertilizers(1, 3, 45.0000, 0.0000, 0.0000,
        "Urea(Coated)(45 % N)(While free flowing)"),
    Fertilizers(1, 4, 25.0000, 0.0000, 0.0000, "Ammonium Chloride"),
    Fertilizers(1, 8, 46.0000, 0.0000, 0.0000, "Urea Super Granulated"),
    Fertilizers(1, 9, 46.0000, 0.0000, 0.0000, "Urea(Granular)"),
    Fertilizers(1, 10, 32.0000, 0.0000, 0.0000,
        "Urea Ammonium Nitrate(32 % N)(Liquid)"),
    Fertilizers(1, 11, 46.0000, 0.0000, 0.0000, "Neem Coated Urea")
  ];

  List<Fertilizers> phosphorousFertilizers = [
    Fertilizers(2, 12, 0.0000, 16.0000, 0.0000,
        "Single Superphosphate(16 % P2O5 Powdered)"),
    Fertilizers(2, 13, 0.0000, 14.0000, 0.0000,
        "Single Superphosphate(14 % P2O5 Powdered)"),
    Fertilizers(2, 14, 0.0000, 46.0000, 0.0000, "Triple Superphosphate"),
    Fertilizers(2, 15, 0.0000, 20.0000, 0.0000, "Bone meal  Raw"),
    Fertilizers(2, 16, 0.0000, 22.0000, 0.0000, "Bone meal Steamed"),
    Fertilizers(2, 17, 0.0000, 18.0000, 0.0000, "Rock Phosphate"),
    Fertilizers(2, 18, 0.0000, 70.0000, 0.0000,
        "Superphosphoric Acid (70 %) P2O5 (Liquid)"),
    Fertilizers(2, 69, 0.0000, 16.0000, 0.0000,
        "Single Superphosphate(16 % P2O5 Granulated)")
  ];

  List<Fertilizers> pottassiumFertilizers = [
    Fertilizers(3, 19, 0.0000, 0.0000, 60.0000,
        "Potassium Chloride(Muriate of Potash)"),
    Fertilizers(3, 20, 0.0000, 0.0000, 50.0000, "Potassium Sulphate"),
    Fertilizers(3, 21, 0.0000, 0.0000, 23.0000, "Potassium Schoenite"),
    Fertilizers(3, 22, 0.0000, 0.0000, 60.0000,
        "Potassium Chloride(Muriate of Potash)(Granular)"),
    Fertilizers(3, 23, 0.0000, 0.0000, 14.7000, "Potash Derived from Molasses")
  ];

  var _selectedNitrogenFertilizer = null;
  var _selectedPhosphorousFertilizer = null;
  var _selectedPottassiumFertilizer = null;

  double _nitrogenRequiredFertilizer = 0.0;
  double _phosphorousRequiredFertilizer = 0.0;
  double _pottassiumRequiredFertilizer = 0.0;

  @override
  void initState() {
    super.initState();

    getDistricts();

    _selectedNitrogenFertilizer = nitrogenFertilizers[7];
    _selectedPhosphorousFertilizer = phosphorousFertilizers[1];
    _selectedPottassiumFertilizer = pottassiumFertilizers[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Fertilizer Recommendation",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _loading
                  ? const LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.green,
                    )
                  : Container(),
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Fertilizer Recommendation.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.black54)),
                        Form(
                          child: Column(
                            children: [
                              districtDropDown(),
                              availableNitrogenTextField(),
                              availablePhosphorousTextField(),
                              availablePottassiumTextField()
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (_availableNitrogenController
                                        .text.isNotEmpty &&
                                    _availablePhosphorousController
                                        .text.isNotEmpty &&
                                    _availablePottassiumController
                                        .text.isNotEmpty) {
                                  await getCrops(_districtSelected.value);
                                  await getRatings(
                                      _availableNitrogenController.text,
                                      _availablePhosphorousController.text,
                                      _availablePottassiumController.text);
                                  await getIrrigationTypes();
                                  await getSoilTypes();
                                  await getDurations();
                                  await getSeasons();

                                  setState(() {
                                    _isFormFetched = true;
                                  });
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )),
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _districtSelected = null;
                                  _availableNitrogenController.clear();
                                  _availablePhosphorousController.clear();
                                  _availablePottassiumController.clear();
                                  _cropSelected = null;
                                  _irrigationSelected = null;
                                  _soilTypeSelected = null;
                                  _seasonSelected = null;
                                  _durationSelected = null;
                                  crops.clear();
                                  irrigationTypes.clear();
                                  soilTypes.clear();
                                  seasons.clear();
                                  durations.clear();
                                  _isFormFetched = false;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                    child: Text(
                                  "Reset",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                        _isFormFetched
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                color: Colors.grey.shade100,
                                child: Form(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      crops.isNotEmpty
                                          ? cropsDropDown()
                                          : Container(),
                                      irrigationTypes.isNotEmpty
                                          ? irrigationTypeDropDown()
                                          : Container(),
                                      soilTypes.isNotEmpty
                                          ? soilTypeDropDown()
                                          : Container(),
                                      seasons.isNotEmpty
                                          ? seasonDropDown()
                                          : Container(),
                                      durations.isNotEmpty
                                          ? durationDropDown()
                                          : Container(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                _irrigationSelected ??=
                                                    Values(false, "", "");
                                                _soilTypeSelected ??=
                                                    Values(false, "", "");
                                                _seasonSelected ??=
                                                    Values(false, "", "");
                                                _durationSelected ??=
                                                    Values(false, "", "");
                                              });

                                              if (_cropSelected != null) {
                                                await getGFR(
                                                    _irrigationSelected.value,
                                                    _soilTypeSelected.value,
                                                    _seasonSelected.value,
                                                    _cropSelected.value,
                                                    _districtSelected.value,
                                                    _durationSelected.value);

                                                calculateFertilizer(
                                                    _selectedNitrogenFertilizer
                                                        .n,
                                                    _selectedPhosphorousFertilizer
                                                        .p,
                                                    _selectedPottassiumFertilizer
                                                        .k);
                                              }
                                              // setState(() {
                                              //   if (_irrigationSelected.value == "") {
                                              //     _irrigationSelected = null;
                                              //   }
                                              //   if (_soilTypeSelected.value == "") {
                                              //     _soilTypeSelected = null;
                                              //   }
                                              //   if (_seasonSelected.value == "") {
                                              //     _seasonSelected = null;
                                              //   }
                                              //   if (_durationSelected.value == "") {
                                              //     _durationSelected = null;
                                              //   }
                                              // });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Center(
                                                  child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _cropSelected = null;
                                                _irrigationSelected = null;
                                                _soilTypeSelected = null;
                                                _seasonSelected = null;
                                                _durationSelected = null;
                                                _isfertilizerFetched = false;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Center(
                                                  child: Text(
                                                "Reset",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        _isfertilizerFetched
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                color: Colors.grey.shade100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Fertilizer Combination I : ",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    nitrogenFertilizerDropDown(),
                                    const SizedBox(height: 5),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Recommended Dosage : ",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              )),
                                          Text(
                                              _nitrogenRequiredFertilizer
                                                      .toStringAsFixed(2) +
                                                  " kg/ha",
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ))
                                        ]),
                                    phosphorousFertilizerDropDown(),
                                    const SizedBox(height: 5),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Recommended Dosage : ",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              )),
                                          Text(
                                              _phosphorousRequiredFertilizer
                                                      .toStringAsFixed(2) +
                                                  " kg/ha",
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ))
                                        ]),
                                    pottassiumFertilizerDropDown(),
                                    const SizedBox(height: 5),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text("Recommended Dosage : ",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              )),
                                          Text(
                                              _pottassiumRequiredFertilizer
                                                      .toStringAsFixed(2) +
                                                  " kg/ha",
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ))
                                        ]),
                                  ],
                                ))
                            : Container(),
                      ])),
            ],
          ),
        ));
  }

  calculateFertilizer(double n, double p, double k) {
    setState(() {
      _loading = true;
      _isfertilizerFetched = false;
    });

    int nCropRating = 0;
    int pCropRating = 0;
    int kCropRating = 0;

    for (int i = 0; i < ratings.length; i++) {
      if (ratings[i].soilTestName == "Nitrogen (N)") {
        nCropRating = int.parse(ratings[i].ratingCode);
      }
      if (ratings[i].soilTestName == "Phosphorus (P)") {
        pCropRating = int.parse(ratings[i].ratingCode);
      }
      if (ratings[i].soilTestName == "Potassium (K)") {
        kCropRating = int.parse(ratings[i].ratingCode);
      }
    }

    print("CropRating - N : " + nCropRating.toString());
    print("CropRating - P : " + pCropRating.toString());
    print("CropRating - K : " + kCropRating.toString());

    double nGfrRating = 0.0;
    double pGfrRating = 0.0;
    double kGfrRating = 0.0;

    for (int i = 0; i < gfrs.length; i++) {
      if (int.parse(gfrs[i].ratingCode) == nCropRating) {
        nGfrRating = double.parse(gfrs[i].n);
      }
      if (int.parse(gfrs[i].ratingCode) == pCropRating) {
        pGfrRating = double.parse(gfrs[i].p);
      }
      if (int.parse(gfrs[i].ratingCode) == kCropRating) {
        kGfrRating = double.parse(gfrs[i].k);
      }
    }

    print("GFR Rating - N : " + nGfrRating.toString());
    print("GFR Rating - P : " + pGfrRating.toString());
    print("GFR Rating - K : " + kGfrRating.toString());

    setState(() {
      if (n > 0) {
        _nitrogenRequiredFertilizer = (nGfrRating / n) * 100;
      }

      if (p > 0) {
        _phosphorousRequiredFertilizer = (pGfrRating / p) * 100;
      }

      if (k > 0) {
        _pottassiumRequiredFertilizer = (kGfrRating / k) * 100;
      }
    });

    print("Fertilizer - N  : " + _nitrogenRequiredFertilizer.toString());
    print("Fertilizer - P  : " + _phosphorousRequiredFertilizer.toString());
    print("Fertilizer - K  : " + _pottassiumRequiredFertilizer.toString());

    setState(() {
      _loading = false;
      _isfertilizerFetched = true;
    });
  }

  getGFR(String irrigationCode, String soilTypeCode, String seasonCode,
      String cropCode, String districtCode, String durationCode) async {
    setState(() {
      _loading = true;
      gfrs.clear();
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth.dac.gov.in/HealthCard/CropSet/GetFGR?Irrigation_Code=${irrigationCode}&Soil_type_code=${soilTypeCode}&Season_Code=${seasonCode}&Crop_code=${cropCode}&Variety_Code=&District_Code=${districtCode}&Duration_Code=${durationCode}"));
    if (response.statusCode == 200) {
      setState(() {
        gfrs = (json.decode(response.body) as List)
            .map((i) => GFR.fromJson(i))
            .toList();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  getCrops(String districtCode) async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth.dac.gov.in/HealthCard/CropSet/BindCrop?&Irrigation_Code=&District_Code=${districtCode}"));
    if (response.statusCode == 200) {
      setState(() {
        crops = (json.decode(response.body) as List)
            .map((i) => Values.fromJson(i))
            .toList();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  getSeasons() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth.dac.gov.in/HealthCard/CropSet/BindSeason"));
    if (response.statusCode == 200) {
      setState(() {
        seasons = (json.decode(response.body) as List)
            .map((i) => Values.fromJson(i))
            .toList();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  getDurations() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth.dac.gov.in/HealthCard/CropSet/BindDuration"));
    if (response.statusCode == 200) {
      setState(() {
        durations = (json.decode(response.body) as List)
            .map((i) => Values.fromJson(i))
            .toList();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  getSoilTypes() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth.dac.gov.in/HealthCard/CropSet/BindSoilType"));
    if (response.statusCode == 200) {
      setState(() {
        soilTypes = (json.decode(response.body) as List)
            .map((i) => Values.fromJson(i))
            .toList();
      });
    }

    setState(() {
      for (int i = 0; i < soilTypes.length; i++) {
        soilTypes[i].text = soilTypes[i].text.replaceAll("\n", "");
        soilTypes[i].text = soilTypes[i].text.replaceAll("\r", "");
      }
    });

    setState(() {
      _loading = false;
    });
  }

  getIrrigationTypes() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth.dac.gov.in/HealthCard/CropSet/BindIrrigation"));
    if (response.statusCode == 200) {
      setState(() {
        irrigationTypes = (json.decode(response.body) as List)
            .map((i) => Values.fromJson(i))
            .toList();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  getRatings(String N, String P, String K) async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth.dac.gov.in/Calculator/GetRating?&N=${N}&P=${P}&K=${K}&OC="));
    if (response.statusCode == 200) {
      setState(() {
        ratings = (json.decode(response.body) as List)
            .map((i) => Ratings.fromJson(i))
            .toList();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  getDistricts() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://soilhealth9.dac.gov.in/CommonFunction/GetDistrict?statecode=33"));
    if (response.statusCode == 200) {
      setState(() {
        districts = (json.decode(response.body) as List)
            .map((i) => Values.fromJson(i))
            .toList();
        districts.removeAt(0);
      });
    }
    setState(() {
      _loading = false;
    });
  }

  Widget pottassiumFertilizerDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Fertilizers>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Pottassium Fertilizers",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: pottassiumFertilizers
              .map<DropdownMenuItem<Fertilizers>>((Fertilizers value) {
            return DropdownMenuItem<Fertilizers>(
              value: value,
              child: Text(
                value.fertilizerName.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Fertilizers? newValue) {
            setState(() {
              _selectedPottassiumFertilizer = newValue!;
              calculateFertilizer(
                  _selectedNitrogenFertilizer.n,
                  _selectedPhosphorousFertilizer.p,
                  _selectedPottassiumFertilizer.k);
            });
          },
          value: _selectedPottassiumFertilizer),
    );
  }

  Widget phosphorousFertilizerDropDown() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<Fertilizers>(
            underline: const SizedBox(),
            isExpanded: true,
            hint: const Text(
              "Phosphorous Fertilizers",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black),
            ),
            items: phosphorousFertilizers
                .map<DropdownMenuItem<Fertilizers>>((Fertilizers value) {
              return DropdownMenuItem<Fertilizers>(
                value: value,
                child: Text(
                  value.fertilizerName.toString().toUpperCase(),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: (Fertilizers? newValue) {
              setState(() {
                _selectedPhosphorousFertilizer = newValue!;
                calculateFertilizer(
                    _selectedNitrogenFertilizer.n,
                    _selectedPhosphorousFertilizer.p,
                    _selectedPottassiumFertilizer.k);
              });
            },
            value: _selectedPhosphorousFertilizer));
  }

  Widget nitrogenFertilizerDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Fertilizers>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Nitrogen Fertilizers",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: nitrogenFertilizers
              .map<DropdownMenuItem<Fertilizers>>((Fertilizers value) {
            return DropdownMenuItem<Fertilizers>(
              value: value,
              child: Text(
                value.fertilizerName.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Fertilizers? newValue) {
            setState(() {
              _selectedNitrogenFertilizer = newValue!;
            });
            calculateFertilizer(
                _selectedNitrogenFertilizer.n,
                _selectedPhosphorousFertilizer.p,
                _selectedPottassiumFertilizer.k);
          },
          value: _selectedNitrogenFertilizer),
    );
  }

  Widget cropsDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Values>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Select Crop",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: crops.map<DropdownMenuItem<Values>>((Values value) {
            return DropdownMenuItem<Values>(
              value: value,
              child: Text(
                value.text.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Values? newValue) {
            setState(() {
              _cropSelected = newValue!;
            });
          },
          value: _cropSelected),
    );
  }

  Widget seasonDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Values>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Select Season",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: seasons.map<DropdownMenuItem<Values>>((Values value) {
            return DropdownMenuItem<Values>(
              value: value,
              child: Text(
                value.text.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Values? newValue) {
            setState(() {
              _seasonSelected = newValue!;
            });
          },
          value: _seasonSelected),
    );
  }

  Widget durationDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Values>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Select Duration Type",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: durations.map<DropdownMenuItem<Values>>((Values value) {
            return DropdownMenuItem<Values>(
              value: value,
              child: Text(
                value.text.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Values? newValue) {
            setState(() {
              _durationSelected = newValue!;
            });
          },
          value: _durationSelected),
    );
  }

  Widget soilTypeDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Values>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Select Soil Type",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: soilTypes.map<DropdownMenuItem<Values>>((Values value) {
            return DropdownMenuItem<Values>(
              value: value,
              child: Text(
                value.text.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Values? newValue) {
            setState(() {
              _soilTypeSelected = newValue!;
            });
          },
          value: _soilTypeSelected),
    );
  }

  Widget irrigationTypeDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Values>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Select Irrigation Type",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: irrigationTypes.map<DropdownMenuItem<Values>>((Values value) {
            return DropdownMenuItem<Values>(
              value: value,
              child: Text(
                value.text.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Values? newValue) {
            setState(() {
              _irrigationSelected = newValue!;
            });
          },
          value: _irrigationSelected),
    );
  }

  Widget availablePottassiumTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _availablePottassiumController,
        onFieldSubmitted: (text) {
          setState(() {
            availablePottassium = text;
          });
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please enter a valid value for Available Pottassium';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: "Available Potassium"),
      ),
    );
  }

  Widget availablePhosphorousTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _availablePhosphorousController,
        onFieldSubmitted: (text) {
          setState(() {
            availablePhosphorous = text;
          });
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please enter a valid value for Available Phosphorus';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: "Available Phosphorous"),
      ),
    );
  }

  Widget availableNitrogenTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _availableNitrogenController,
        onFieldSubmitted: (text) {
          setState(() {
            availableNitrogen = text;
          });
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please enter a valid value for Available Nitrogen';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none, hintText: "Available Nitrogen"),
      ),
    );
  }

  Widget districtDropDown() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<Values>(
          underline: const SizedBox(),
          isExpanded: true,
          hint: const Text(
            "Select District",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.black),
          ),
          items: districts.map<DropdownMenuItem<Values>>((Values value) {
            return DropdownMenuItem<Values>(
              value: value,
              child: Text(
                value.text.toString().toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (Values? newValue) {
            setState(() {
              _districtSelected = newValue!;
            });
          },
          value: _districtSelected),
    );
  }
}
