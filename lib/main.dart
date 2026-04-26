import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:glassmorphism/glassmorphism.dart';

void main() => runApp(MaterialApp(home: IOSLauncher(), debugShowCheckedModeBanner: false));

class IOSLauncher extends StatefulWidget {
  @override
  _IOSLauncherState createState() => _IOSLauncherState();
}

class _IOSLauncherState extends State<IOSLauncher> {
  List<Application> apps = [];

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  // ఫోన్ లో ఉన్న యాప్స్ అన్నింటినీ లోడ్ చేస్తుంది
  _loadApps() async {
    List<Application> _apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );
    setState(() => apps = _apps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://your-wallpaper-url.com/ios18.jpg"), // iOS 18 వాల్‌పేపర్ లింక్ ఇవ్వండి
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50), // స్టేటస్ బార్ కోసం స్పేస్
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, 
                  mainAxisSpacing: 25, 
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.8,
                ),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  Application app = apps[index];
                  return GestureDetector(
                    onTap: () => DeviceApps.openApp(app.packageName),
                    child: Column(
                      children: [
                        // ఐకాన్ డిజైన్ (Rounded Corners like iOS)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: app is ApplicationWithIcon 
                              ? Image.memory(app.icon, width: 60) 
                              : Icon(Icons.android, size: 60),
                        ),
                        SizedBox(height: 8),
                        Text(
                          app.appName,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildDock(), // కింద ఉండే iOS డొక్
          ],
        ),
      ),
    );
  }

  // iOS Dock (కింద ఉండే గ్లాస్ బార్)
  Widget _buildDock() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GlassmorphicContainer(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 90,
        borderRadius: 30,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)]),
        borderGradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.2)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             // ఇక్కడ మీకు కావాల్సిన మెయిన్ యాప్స్ ఐకాన్స్ పెట్టుకోవచ్చు
             _dockIcon(Icons.phone, Colors.green),
             _dockIcon(Icons.message, Colors.blue),
             _dockIcon(Icons.camera_alt, Colors.grey),
             _dockIcon(Icons.language, Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _dockIcon(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
