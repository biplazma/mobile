import 'dart:convert';
import 'package:http/http.dart';

final String cityUrl = 'https://gist.githubusercontent.com/Adem68/6dfda4303042784fd2ee6723d9206427/raw/55869b410d84b70d70e4166c5dd76df463ad08b9/il.json';
final String countyUrl = 'https://gist.githubusercontent.com/Adem68/c6bbcf1426a83f5a51414470c3c24724/raw/d5d08fe7f3902e752c1ee459973f86f2869543ad/ilce.json';
final String hospitalUrl =
    'https://gist.githubusercontent.com/Adem68/c6ab4402c1a7c55429d28d2da1fc7fc2/raw/5e200c730891457eebdfb2e1341b018788c8196e/hastane.json';

class CityData {
  String ilKodu;
  String il;

  CityData({
    this.ilKodu,
    this.il,
  });
}

class CountyData {
  String id;
  String ilKodu;
  String ilceKodu;
  String ilceAdi;

  CountyData({
    this.id,
    this.ilKodu,
    this.ilceKodu,
    this.ilceAdi,
  });
}

class HospitalData {
  String id;
  String tur;
  String ilKodu;
  String ilceKodu;
  String kurumKodu;
  String kurumTurKodu;
  String kurum;

  HospitalData({
    this.id,
    this.tur,
    this.ilKodu,
    this.ilceKodu,
    this.kurumKodu,
    this.kurumTurKodu,
    this.kurum,
  });
}

Future<List<CityData>> getCityData() async {
  List<CityData> cityData = [];
  try {
    Response response = await get(cityUrl);
    List data = jsonDecode(response.body);
    List<CityData> cityList = data
        .map((e) => CityData(
              il: e["IL"],
              ilKodu: e["IL_KODU"],
            ))
        .toList();
    cityData = cityList;
  } catch (e) {}
  return cityData;
}

Future<List<CountyData>> getCountyData() async {
  List<CountyData> countyData = [];
  try {
    Response response = await get(countyUrl);
    List data = jsonDecode(response.body);
    List<CountyData> countyList = data
        .map((e) => CountyData(
              id: e["id"],
              ilKodu: e["IL_KODU"],
              ilceKodu: e["ILCE_KODU"],
              ilceAdi: e["ILCE_ADI"],
            ))
        .toList();
    countyData = countyList;
  } catch (e) {}
  return countyData;
}

Future<List<HospitalData>> getHospitalData() async {
  List<HospitalData> hospitalData = [];

  try {
    Response response = await get(hospitalUrl);
    List data = jsonDecode(response.body);
    List<HospitalData> hospitalList = data
        .map((e) => HospitalData(
              id: e["ID"],
              ilKodu: e["IL_KODU"],
              ilceKodu: e["ILCE_KODU"],
              kurumKodu: e["KURUM_KODU"],
              kurumTurKodu: e["KURUM_TUR_KODU"],
              kurum: e["KURUM"],
            ))
        .toList();
    hospitalData = hospitalList;
  } catch (e) {}
  return hospitalData;
}
