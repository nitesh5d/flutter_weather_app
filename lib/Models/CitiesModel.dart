class CitiesModel {
  var country = '';
  var geonameid;
  var name;
  var subcountry;

  CitiesModel(
      {required this.country,
      required this.geonameid,
      required this.name,
      required this.subcountry});

  CitiesModel.fromJson(json) {
    country = json['country'];
    geonameid = json['geonameid'];
    name = json['name'];
    subcountry = json['subcountry'];
  }
}
