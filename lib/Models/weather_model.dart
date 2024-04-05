
class Weather {
  Weather({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.rain,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });
  late final Coord coord;
  late final List<WeatherElement> weather;
  late final String base;
  late final Main main;
  late final int visibility;
  late final Wind wind;
  late final Rain rain;
  late final Clouds clouds;
  late final int dt;
  late final Sys sys;
  late final int timezone;
  late final int id;
  late final String name;
  late final int cod;
  
  Weather.fromJson(Map<String, dynamic> json){
    coord = Coord.fromJson(json['coord']);
    weather = List.from(json['weather']).map((e)=>WeatherElement.fromJson(e)).toList();
    base = json['base'];
    main = Main.fromJson(json['main']);
    visibility = json['visibility'];
    wind = Wind.fromJson(json['wind']);
    if(json['rain'] != null){
      rain = Rain.fromJson(json['rain']);
    }
    clouds = Clouds.fromJson(json['clouds']);
    dt = json['dt'];
    sys = Sys.fromJson(json['sys']);
    if(json['timezone'] != null){
      timezone = json['timezone'];
    }
    id = json['id'];
    name = json['name'];
    cod = json['cod'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coord'] = coord.toJson();
    data['weather'] = weather.map((e)=>e.toJson()).toList();
    data['base'] = base;
    data['main'] = main.toJson();
    data['visibility'] = visibility;
    data['wind'] = wind.toJson();
    data['rain'] = rain.toJson();
    data['clouds'] = clouds.toJson();
    data['dt'] = dt;
    data['sys'] = sys.toJson();
    data['timezone'] = timezone;
    data['id'] = id;
    data['name'] = name;
    data['cod'] = cod;
    return data;
  }
}

class Coord {
  Coord({
    required this.lon,
    required this.lat,
  });
  late var lon;
  late var lat;
  
  Coord.fromJson(Map<String, dynamic> json){
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    return data;
  }
}

class WeatherElement {
  WeatherElement({
    this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  late final int? id;
  late final String main;
  late final String description;
  late final String icon;
  
  WeatherElement.fromJson(Map<String, dynamic> json){
    if(json['id'] != null){
      id = json['id'];
    }
    else{
      id = 0;
    }
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}

class Main {
  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });
  late var temp;
  late var feelsLike;
  late var tempMin;
  late var tempMax;
  late final int pressure;
  late final int humidity;
  late final int seaLevel;
  late final int grndLevel;
  
  Main.fromJson(Map<String, dynamic> json){
    temp = json['temp'];
    feelsLike = json['feels_like'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];

    if(json['pressure'] != null){
      pressure = json['pressure'];
    }
    else{
      pressure = 0;
    }

    if(json['humidity'] != null){
      humidity = json['humidity'];
    }
    else{
      humidity = 0;
    }

    if(json['sea_level'] != null){
      seaLevel = json['sea_level'];
    }
    else{
      seaLevel = 0;
    }

    if(json['grnd_level'] != null){
      grndLevel = json['grnd_level'];
    }
    else{
      grndLevel = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['temp_min'] = tempMin;
    data['temp_max'] = tempMax;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['sea_level'] = seaLevel;
    data['grnd_level'] = grndLevel;
    return data;
  }
}

class Wind {
  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });
  late var speed;
  late var deg;
  late var gust;
  
  Wind.fromJson(Map<String, dynamic> json){

    if(json['speed'] != null){
      speed = json['speed'];
    }
    else{
      speed = 0.0;
    }

    if(json['deg'] != null){
      deg = json['deg'];
    }
    else{
      deg = 0;
    }

    if(json['gust'] != null){
      gust = json['gust'];
    }
    else{
      gust = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['speed'] = speed;
    data['deg'] = deg;
    data['gust'] = gust;
    return data;
  }
}

class Rain {
  Rain({
    required this.the1h,
  });
  late var the1h;
  
  Rain.fromJson(Map<String, dynamic> json){
    the1h = json['1h'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['1h'] = the1h;
    return data;
  }
}

class Clouds {
  Clouds({
    required this.all,
  });
  late final int all;
  
  Clouds.fromJson(Map<String, dynamic> json){
    all = json['all'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['all'] = all;
    return data;
  }
}

class Sys {
  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });
  late final int type;
  late final int id;
  late final String country;
  late final int sunrise;
  late final int sunset;
  
  Sys.fromJson(Map<String, dynamic> json){
    if (json['type'] != null){
      type = json['type'];
    }
    else{
      type = 0;
    }
    if (json['id'] != null){
      id = json['id'];
    }
    else{
      id = 0;
    }
    country = json['country'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['country'] = country;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}