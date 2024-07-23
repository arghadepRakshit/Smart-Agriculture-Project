import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projecttest/Model/weather_model.dart'; // Adjust import based on your project structure
import 'package:projecttest/Services/services.dart'; // Adjust import based on your project structure

class WeatherHome extends StatefulWidget {
  const WeatherHome({Key? key}) : super(key: key);

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    setState(() {
      isLoading = true;
    });

    try {
      WeatherData data = await WeatherServices().fetchWeather();
      setState(() {
        weatherInfo = data;
        isLoading = false;
      });
    } catch (e) {
      // Handle error, e.g., show an error message
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        // preferredSize: Size.fromHeight(70.0), // Customize preferred height
        title: Text(
          'Smart Agriculture ', // Replace with your actual title
          style: TextStyle(color: Colors.white), // Change title color to white
        ),
        backgroundColor: Color(0xff6ec9ed), // Change background color
        centerTitle: true, // Center align title
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10), // Customize border radius
          ),
        ),
        elevation: 10, // Add elevation/shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : WeatherDetail(
                  weather: weatherInfo,
                  formattedDate: formattedDate,
                  formattedTime: formattedTime,
                ),
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;

  const WeatherDetail({
    Key? key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                weather.name,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "${weather.temperature.current.toStringAsFixed(2)}°C",
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (weather.weather.isNotEmpty)
            Text(
              weather.weather[0].main,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 20),
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            formattedTime,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          WeatherWidget(weather: weather),
          const SizedBox(height: 20),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Color(0xFF4A4A7F),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      weatherInfoColumn(
                        icon: Icons.sunny,
                        title: "Wind",
                        value: "${weather.wind.speed} km/h",
                      ),
                      weatherInfoColumn(
                        icon: Icons.opacity,
                        title: "Humidity",
                        value: "${weather.humidity.toStringAsFixed(2)}%",
                      ),
                      weatherInfoColumn(
                        icon: Icons.thermostat,
                        title: "Min",
                        value: "${weather.minTemperature.toStringAsFixed(2)}°C",
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      weatherInfoColumn(
                        icon: Icons.water_drop,
                        title: "Humidity",
                        value: "${weather.humidity.toStringAsFixed(2)}%",
                      ),
                      weatherInfoColumn(
                        icon: Icons.air,
                        title: "Pressure",
                        value: "${weather.pressure} hPa",
                      ),
                      weatherInfoColumn(
                        icon: Icons.leaderboard,
                        title: "Sea-Level",
                        value: "${weather.seaLevel} m",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget weatherInfoColumn({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 5),
        weatherInfoCard(title: title, value: value),
      ],
    );
  }

  Widget weatherInfoCard({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final WeatherData weather;

  WeatherWidget({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the image asset based on the weather condition
    String imageAsset;
    if (weather.weather.isNotEmpty &&
        weather.weather[0].main.toLowerCase() == "haze") {
      imageAsset = "assets/haze.png";
    } else if (weather.weather.isNotEmpty &&
        weather.weather[0].main.toLowerCase() == "clouds") {
      imageAsset = "assets/cloudy.png";
    } else if (weather.weather.isNotEmpty &&
        weather.weather[0].main.toLowerCase() == "rainy") {
      imageAsset = "assets/rainy.png";
    } else {
      imageAsset = "assets/sunny.png";
    }

    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
