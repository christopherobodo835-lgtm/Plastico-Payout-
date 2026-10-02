import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(PlasticoApp());

class PlasticoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'Plastico Payout', theme: ThemeData(primarySwatch: Colors.green), home: RoleSelector());
  }
}

class RoleSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.green[700], body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("♻️", style: TextStyle(fontSize: 80)),
      Text("PLASTICO PAYOUT", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
      Text("Turning Waste to Wealth", style: TextStyle(color: Colors.white70)),
      SizedBox(height: 40),
      ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellerScreen())), child: Text("I AM SELLER - Sell 100kg+"), style: ElevatedButton.styleFrom(minimumSize: Size(250, 50))),
      SizedBox(height: 15),
      ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen())), child: Text("I AM ADMIN - Oyigbo Hub"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, minimumSize: Size(250, 50))),
    ])));
  }
}

class SellerScreen extends StatefulWidget {
  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  double kg = 0;
  TextEditingController kgController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController bankController = TextEditingController(text: "Access Bank");
  XFile? image;
  bool showQR = false;
  String qrData = "";
  final int rate = 350;
  final int minKg = 100;
  double get payout => kg * rate;
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked!= null) setState(() => image = picked);
  }
  void generateQR() {
    if (kg < minKg) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Minimum is ${minKg}kg!"))); return; }
    if (accountController.text.length < 10) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter valid account"))); return; }
    if (image == null) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Snap plastic photo first!"))); return; }
    setState(() { qrData = "PLASTICO|KG:$kg|PAY:N$payout|ACCT:${accountController.text}|${DateTime.now()}"; showQR = true; });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Sell Plastic - Min 100kg")), body: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Enter KG:", style: TextStyle(fontWeight: FontWeight.bold)),
      TextField(controller: kgController, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: "e.g 120", suffixText: "KG"), onChanged: (v) => setState(() => kg = double.tryParse(v)?? 0)),
      if (kg > 0 && kg < minKg) Text("❌ Minimum 100kg!", style: TextStyle(color: Colors.red)),
      if (kg >= minKg) Text("✅ Eligible", style: TextStyle(color: Colors.green)),
      SizedBox(height: 10),
      Container(padding: EdgeInsets.all(15), color: Colors.green[50], child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Rate: N$rate/kg"), Text("N${payout.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))])),
      SizedBox(height: 20),
      TextField(controller: accountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Account Number")),
      TextField(controller: bankController, decoration: InputDecoration(labelText: "Bank Name")),
      SizedBox(height: 20),
      ElevatedButton.icon(onPressed: pickImage, icon: Icon(Icons.camera), label: Text(image == null? "SNAP PHOTO" : "Photo ✓"), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50))),
      SizedBox(height: 15),
      ElevatedButton(onPressed: generateQR, child: Text("SELL - N${payout.toStringAsFixed(0)}"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, minimumSize: Size(double.infinity, 55))),
      if (showQR) Center(child: Column(children: [SizedBox(height: 20), QrImageView(data: qrData, size: 200), Text("PENDING - Waiting Hub", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))])),
    ])));
  }
}

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool isPaid = false;
  void payNow() { setState(() => isPaid = true); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ PAYSTACK N42000 SENT!"), backgroundColor: Colors.green)); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Admin - Oyigbo Hub"), backgroundColor: Colors.black, foregroundColor: Colors.white), body: Padding(padding: EdgeInsets.all(20), child: Card(elevation: 5, child: Padding(padding: EdgeInsets.all(15), child: Column(children: [
      Text("PENDING - 120kg = N42000", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Container(height: 120, color: Colors.grey[300], child: Center(child: Text("📸 Photo Evidence"))),
      SizedBox(height: 10),
      QrImageView(data: "PLASTICO|120kg|N42000", size: 120),
      SizedBox(height: 15),
      if (!isPaid) ElevatedButton(onPressed: payNow, child: Text("PAY NOW - Instant Paystack"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, minimumSize: Size(double.infinity, 55)))
      else Container(padding: EdgeInsets.all(15), color: Colors.green[100], child: Row(children: [Icon(Icons.check_circle, color: Colors.green), Text(" PAID")])),
    ])))),
    );
  }
} ww2
