import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifcation/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.initializer();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    LocalNotification.notificationSubject.stream.listen((String payload) {
      showAlertMessage(payload, "Notification");
    });
  }

  showAlertMessage(String message, String header) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(header),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.purpleAccent,
              textColor: Colors.white,
              child: Text('Show One Time Notification'),
              onPressed: () async {
                await LocalNotification.ShowOneTimeNotification(
                    DateTime.now().add(Duration(minutes: 2)));
                showAlertMessage("Notification will be shown after 2 minutes",
                    "Notification Created");
              },
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.purpleAccent,
              textColor: Colors.white,
              child: Text('Show Periodic Notification'),
              onPressed: () async {
                await LocalNotification.ShowPeriodicNotification(
                    RepeatInterval.EveryMinute);
                showAlertMessage(
                    "Notification will be shown periodically in an interval of 1 minutes",
                    "Notification Created");
              },
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.purpleAccent,
              textColor: Colors.white,
              child: Text('Cancel Periodic Notification'),
              onPressed: () async {
                await LocalNotification.CancelNotification(2);
                showAlertMessage("Periodic notification has been cancelled.",
                    "Notification Cancelled");
              },
            ),
          ],
        ),
      ),
    );
  }
}
