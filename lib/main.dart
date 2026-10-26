import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const AzmerApp());

const gold = Color(0xFFE8BD69);
const ink = Color(0xFF071018);
const panel = Color(0xFF111E28);

class AzmerApp extends StatelessWidget {
  const AzmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azmer Premium Transport',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ink,
        colorScheme: ColorScheme.fromSeed(seedColor: gold, brightness: Brightness.dark),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: gold),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final pickup = TextEditingController(text: 'Setia Alam, Selangor');
  final destination = TextEditingController(text: 'KLIA Terminal 1');
  final date = TextEditingController();
  final time = TextEditingController(text: '10:00 AM');
  String trip = 'Airport Transfer';
  String vehicle = 'Toyota Alphard AGH30';
  final phoneNumber = '60123456789'; // GANTIKAN dengan nombor WhatsApp sebenar.
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

  int get price {
    final d = destination.text.toLowerCase();
    if (d.contains('genting')) return 350;
    if (d.contains('klia') || d.contains('klia 2')) return 300;
    if (trip == 'Hourly Chauffeur') return 50;
    return 250;
  }

  @override
  void initState() {
    super.initState();
    date.text = _dateText(selectedDate);
    destination.addListener(() => setState(() {}));
  }

  String _dateText(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        date.text = _dateText(picked);
      });
    }
  }

  Future<void> _sendBooking() async {
    final message = '''
AZMER PREMIUM TRANSPORT — TEMPAHAN BARU

Pickup: ${pickup.text}
Destinasi: ${destination.text}
Tarikh: ${date.text}
Masa: ${time.text}
Jenis perjalanan: $trip
Kenderaan: $vehicle
Anggaran harga: RM$price

Mohon sahkan ketersediaan dan harga akhir.
''';
    final uri = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp. Sila cuba lagi.')),
      );
    }
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  @override
  void dispose() {
    pickup.dispose();
    destination.dispose();
    date.dispose();
    time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ink,
        title: const Text('AZMER  PREMIUM', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w800)),
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.directions_car, color: gold))],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF172733), Color(0xFF080F15)]),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: gold.withOpacity(.55)),
              ),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PREMIUM TRANSPORT', style: TextStyle(color: gold, letterSpacing: 2, fontSize: 12)),
                SizedBox(height: 8),
                Text('Your Journey,\\nOur Priority.', style: TextStyle(fontSize: 29, height: 1.1, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('Private Chauffeur • Airport Transfer', style: TextStyle(color: Colors.white70)),
              ]),
            ),
            _sectionTitle('Butiran Perjalanan'),
            TextField(controller: pickup, decoration: const InputDecoration(labelText: 'Lokasi pickup', prefixIcon: Icon(Icons.my_location))),
            const SizedBox(height: 12),
            TextField(controller: destination, decoration: const InputDecoration(labelText: 'Destinasi', prefixIcon: Icon(Icons.location_on))),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: date, readOnly: true, onTap: _chooseDate, decoration: const InputDecoration(labelText: 'Tarikh', prefixIcon: Icon(Icons.calendar_month)))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: time, decoration: const InputDecoration(labelText: 'Masa', prefixIcon: Icon(Icons.schedule)))),
            ]),
            _sectionTitle('Jenis Perjalanan'),
            DropdownButtonFormField<String>(
              value: trip,
              decoration: const InputDecoration(labelText: 'Pilih perkhidmatan'),
              items: const [
                DropdownMenuItem(value: 'Airport Transfer', child: Text('Airport Transfer')),
                DropdownMenuItem(value: 'City Transfer', child: Text('City Transfer')),
                DropdownMenuItem(value: 'Genting Highlands', child: Text('Genting Highlands')),
                DropdownMenuItem(value: 'Hourly Chauffeur', child: Text('Hourly Chauffeur')),
              ],
              onChanged: (v) => setState(() => trip = v ?? trip),
            ),
            _sectionTitle('Pilih Kenderaan'),
            DropdownButtonFormField<String>(
              value: vehicle,
              decoration: const InputDecoration(labelText: 'Kenderaan'),
              items: const [
                DropdownMenuItem(value: 'Toyota Alphard AGH30', child: Text('Toyota Alphard AGH30')),
                DropdownMenuItem(value: 'Toyota Camry', child: Text('Toyota Camry')),
              ],
              onChanged: (v) => setState(() => vehicle = v ?? vehicle),
            ),
            _sectionTitle('Anggaran Harga'),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Expanded(child: Text('Harga anggaran\\nHarga akhir tertakluk pengesahan', style: TextStyle(color: Colors.white70))),
                Text('RM$price', style: const TextStyle(color: gold, fontSize: 27, fontWeight: FontWeight.bold)),
              ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _sendBooking,
                icon: const Icon(Icons.chat),
                label: const Text('TEMPAH MELALUI WHATSAPP', style: TextStyle(fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: ink),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Demo awal: harga dan nombor WhatsApp perlu disemak sebelum digunakan untuk pelanggan.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
