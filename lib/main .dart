import 'package:flutter/material.dart';

void main() {
  runApp(const AzabApp());
}

class AzabApp extends StatelessWidget {
  const AzabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Azab..x',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blueAccent,
      ),
      home: const TTSStudioScreen(),
    );
  }
}

class TTSStudioScreen extends StatefulWidget {
  const TTSStudioScreen({super.key});

  @override
  State<TTSStudioScreen> createState() => _TTSStudioScreenState();
}

class _TTSStudioScreenState extends State<TTSStudioScreen> {
  // القائمة الشاملة للهجات العربية في الوطن العربي
  final List<String> arabicDialects = [
    '🇪🇬 اللهجة المصرية (Egypt)',
    '🇸🇦 اللهجة السعودية والخليجية (Gulf)',
    '🇲🇦 اللهجة المغربية وشمال إفريقيا (North Africa)',
    '🇸🇾 اللهجة الشامية (Levantine)',
    '🌍 اللغة العربية الفصحى (MSA)',
  ];

  late String selectedDialect;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDialect = arabicDialects[0]; // الافتراضي مصرية
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Azab..x - استوديو الذكاء الاصطناعي'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر اللهجة العربية المطلوبة:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            // قائمة منسدلة لاختيار اللهجات
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
              ),
              child: DropdownButton<String>(
                value: selectedDialect,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E1E1E),
                underline: const SizedBox(),
                items: arabicDialects.map((String dialect) {
                  return DropdownMenuItem<String>(
                    value: dialect,
                    child: Text(dialect, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDialect = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'أدخل النص المراد تحويله لصوت:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'اكتب النص هنا، وسيتم قراءته باللهجة المختارة...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // زر توليد الصوت بالذكاء الاصطناعي
                },
                icon: const Icon(Icons.mic_rounded),
                label: const Text('توليد الصوت الذكي (Generate AI Voice)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}