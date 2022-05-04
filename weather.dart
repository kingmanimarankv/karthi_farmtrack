import 'dart:convert';

import 'package:farmtrack/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _height = 0.0;
  final _width = 0.0;
  bool _loading = false;

  bool _isWeatherFetched = false;

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  late String latitude;
  late String longitude;

  late Weather weather;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather Reports",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(height: 2, color: Colors.green),
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
                        const Text("Weather Reports.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.black54)),
                        Form(
                          child: Column(children: [
                            latitudeTextFormField(),
                            longitudeTextFormField()
                          ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (_latitudeController.text.isNotEmpty &&
                                    _longitudeController.text.isNotEmpty) {
                                  await getWeather(latitude, longitude);
                                  setState(() {
                                    _isWeatherFetched = true;
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
                                  _latitudeController.clear();
                                  _longitudeController.clear();
                                  _isWeatherFetched = false;
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
                      ])),
              _isWeatherFetched
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Temperature : ${weather.main.temp}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),
                          Text("Temperature (Max) : ${weather.main.tempMax}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              )),
                          Text("Temperature (Min) : ${weather.main.tempMax}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              )),
                          const Divider(),
                          Text("Pressure : ${weather.main.pressure}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),
                          const Divider(),
                          Text("Humidity : ${weather.main.humidity}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),
                          const Divider(),
                          Text("Wind Speed : ${weather.wind.speed}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),
                          Text("Degree : ${weather.wind.deg}",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              )),
                        ],
                      ))
                  : Container()
            ]))));
  }

  Widget latitudeTextFormField() {
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
        controller: _latitudeController,
        onFieldSubmitted: (text) {
          setState(() {
            latitude = text;
          });
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please enter a valid value for latitude';
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
            border: InputBorder.none, hintText: "Latitude"),
      ),
    );
  }

  Widget longitudeTextFormField() {
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
        controller: _longitudeController,
        onFieldSubmitted: (text) {
          setState(() {
            longitude = text;
          });
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Please enter a valid value for longitude';
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
            border: InputBorder.none, hintText: "Longitude"),
      ),
    );
  }

  getWeather(String latitude, String longitude) async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=b30de56fcbd933743d24fc9004670526&units=metric"));
    if (response.statusCode == 200) {
      setState(() {
        weather = Weather.fromJson(json.decode(response.body));
      });
    }
    setState(() {
      _loading = false;
    });
  }
}
