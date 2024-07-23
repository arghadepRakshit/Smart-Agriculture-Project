import 'package:flutter/material.dart';
import 'package:projecttest/Screen/weather_home.dart';
import 'package:intl/intl.dart';
import 'package:projecttest/Model/weather_model.dart'; // Adjust import based on your project structure
import 'package:projecttest/Services/services.dart'; // Adjust import based on your project structure
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import convert library for jsonDecode

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Agriculture ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Smart Agriculture '),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Customize preferred height
        child: AppBar(
          title: Text(
            title,
            style:
                TextStyle(color: Colors.white), // Change title color to white
          ),
          backgroundColor: Color(0xff6ec9ed), // Change background color
          centerTitle: true, // Center align title
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10), // Customize border radius
            ),
          ),
          elevation: 10, // Add elevation/shadow
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherHome()),
                );
              },
              child: Argha(),
            ),
            // Add spacing between the containers
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sensorst()),
                );
              },
              child: Container(
                height: 252,
                width: 400,
                decoration: BoxDecoration(
                  color: Color(0xff7e94f1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Sensor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Argha extends StatefulWidget {
  const Argha({Key? key}) : super(key: key);

  @override
  State<Argha> createState() => _ArghaState();
}

class _ArghaState extends State<Argha> {
  WeatherData? weatherInfo;
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
      print('Error fetching weather data: $e'); // Debug print
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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF676BD0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 300,
        width: 400,
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: Color(0xfffcfffa))
              : weatherInfo != null
                  ? WeatherDetail(
                      weather: weatherInfo!,
                      formattedDate: formattedDate,
                      formattedTime: formattedTime,
                    )
                  : Text(
                      'No data available',
                      style: TextStyle(color: Colors.white),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      weather.name,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xfff9f0f0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "${weather.temperature.current.toStringAsFixed(2)}°C",
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xfff4e8e8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (weather.weather.isNotEmpty)
                Text(
                  weather.weather[0].main,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xfff6eeee),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              WeatherWidget(weather: weather),
              const SizedBox(height: 10),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xfff8f1f1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xffede7e7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            height: 250,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          const SizedBox(width: 15),
          weatherInfoCard(title: title, value: value),
        ])
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
            color: Color(0xfff9f9f9),
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
        weather.weather[0].main.toLowerCase() == "rain") {
      imageAsset = "assets/rainy.png";
    } else {
      imageAsset = "assets/sunny.png";
    }

    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Sensor extends StatefulWidget {
  @override
  _SensorState createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  String doctorName = "";
  String specialization = "";

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/dd/index.php'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        doctorName = data['name'];
        specialization = data['specialization'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0xFF676BD0), // Outer container color
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Sensor Data',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF4A4A7F), // Inner container color
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.thermostat, // Thermostat icon
                              color: Colors.white,
                            ),
                            SizedBox(width: 3), // Spacing between icon and text
                            Text(
                              'Temperature:',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(width: 20), // Exact spacing
                            Text(
                              // doctorName,
                              '29.97' + '°C',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.water_drop, // Thermostat icon
                              color: Colors.white,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Humidity:',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(width: 20), // Exact spacing
                            Text(
                              // specialization,
                              '92%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.water_drop, // Thermostat icon
                              color: Colors.white,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Moisturizer:',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(width: 20), // Exact spacing
                            Text(
                              // specialization,
                              '29%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sensorst extends StatefulWidget {
  @override
  _SensorstState createState() => _SensorstState();
}

class _SensorstState extends State<Sensorst> {
  double _temperature1 = 20.0;
  double _temperature2 = 10.0;
  double _temperature3 = 15.0;
  double _temperature4 = 25.0;
  String doctorName = "";
  String specialization = "";

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/dd/index.php'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        doctorName = data['name'];
        specialization = data['specialization'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                width: 400,
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xFF676BD0), // Outer container color
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Sensor Data',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF4A4A7F), // Inner container color
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.thermostat, // Thermostat icon
                                color: Colors.white,
                              ),
                              SizedBox(
                                  width: 3), // Spacing between icon and text
                              Text(
                                'Temperature:',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              SizedBox(width: 20), // Exact spacing
                              Text(
                                // doctorName,
                                '29.97' + '°C',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.water_drop, // Thermostat icon
                                color: Colors.white,
                              ),
                              SizedBox(width: 3),

                              Text(
                                'Humidity:',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(width: 20), // Exact spacing
                              Text(
                                // specialization,
                                '92%',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.water_drop, // Thermostat icon
                                color: Colors.white,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Moisturizer:',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(width: 20), // Exact spacing
                              Text(
                                // specialization,
                                '25%',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 400,
                height: 750,
                decoration: BoxDecoration(
                  color: Color(0xFF676BD0), // Outer container color
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10), // Spacing at the top
                    Text(
                      'Temperatures Controable',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 10),

                    // First Image and Slider
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/potato.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          Slider(
                            value: _temperature1,
                            min: -10.0,
                            max: 40.0,
                            divisions: 50,
                            label: _temperature1.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _temperature1 = value;
                              });
                            },
                          ),
                          Text(
                            _temperature1.toStringAsFixed(1) + '°C',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    // Second Image and Slider
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/onion.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          Slider(
                            value: _temperature2,
                            min: -10.0,
                            max: 40.0,
                            divisions: 50,
                            label: _temperature2.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _temperature2 = value;
                              });
                            },
                          ),
                          Text(
                            _temperature2.toStringAsFixed(1) + '°C',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    // Third Image and Slider
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/tomato.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          Slider(
                            value: _temperature3,
                            min: -10.0,
                            max: 40.0,
                            divisions: 50,
                            label: _temperature3.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _temperature3 = value;
                              });
                            },
                          ),
                          Text(
                            _temperature3.toStringAsFixed(1) + '°C',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    // Fourth Image and Slider
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/brinjal.jpeg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          Slider(
                            value: _temperature4,
                            min: -10.0,
                            max: 40.0,
                            divisions: 50,
                            label: _temperature4.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                _temperature4 = value;
                              });
                            },
                          ),
                          Text(
                            _temperature4.toStringAsFixed(1) + '°C',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
