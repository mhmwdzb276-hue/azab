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
      home: const AzabStudioScreen(),
    );
  }
}

class AzabStudioScreen extends StatefulWidget {
  const AzabStudioScreen({super.key});

  @override
  State<AzabStudioScreen> createState() => _AzabStudioScreenState();
}

class _AzabStudioScreenState extends State<AzabStudioScreen> {
  // القائمة الشاملة للهجات العربية للتوليد الذكي
  final List<String> arabicDialects = [
    '🇪🇬 اللهجة المصرية (Egypt)',
    '🇸🇦 اللهجة السعودية والخليجية (Gulf)',
    '🇲🇦 اللهجة المغربية وشمال إفريقيا (North Africa)',
    '🇸🇾 اللهجة الشامية (Levantine)',
    '🌍 اللغة العربية الفصحى (MSA)',
  ];

  late String selectedDialect;
  final TextEditingController textController = TextEditingController();
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    selectedDialect = arabicDialects[0];
  }

  // دالة توليد الصوت الذكي
  void generateAIVoice() {
    final text = textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك اكتب نصاً أولاً لتوليد الصوت!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isGenerating = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم توليد الصوت بنجاح باستخدام ($selectedDialect)!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Azab..x - استوديو المونتاج والذكاء الاصطناعي'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: Column(
        children: [
          // شاشة معاينة الفيديو المصغرة (Preview Screen)
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill_rounded, size: 64, color: Colors.blueAccent),
                    SizedBox(height: 8),
                    Text(
                      'منطقة معاينة الفيديو (Preview)',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // لوحة التحكم وتوليد الصوت باللهجات
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اختر اللهجة العربية للتوليد الصوتي:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 6),
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
                          child: Text(dialect, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDialect = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: textController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'اكتب النص للتحويل الصوتي بالذكاء الاصطناعي...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: isGenerating
                        ? const CircularProgressIndicator(color: Colors.blueAccent)
                        : ElevatedButton.icon(
                            onPressed: generateAIVoice,
                            icon: const Icon(Icons.mic_rounded, size: 18),
                            label: const Text('توليد الصوت الذكي'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),

          // شريط التايم لاين وأدوات المونتاج السفلي (Timeline & Tools)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF181818),
              border: Border(top: BorderSide(color: Color(0xFF2C2C2C))),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildToolButton(Icons.cut, 'قص (Split)'),
                    _buildToolButton(Icons.audiotrack, 'إضافة صوت'),
                    _buildToolButton(Icons.text_fields, 'نصوص (Text)'),
                    _buildToolButton(Icons.filter_alt, 'فلاتر'),
                    _buildToolButton(Icons.speed, 'السرعة'),
                  ],
                ),
                const SizedBox(height: 10),
                // شكل مسارات التايم لاين الوهمية
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey[850]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_creation_outlined, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      Text('التايم لاين الرئيسي (Timeline Tracks)', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // أزرار أدوات المونتاج السريعة
  Widget _buildToolButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}