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
  final List<String> arabicDialects = [
    '🇪🇬 اللهجة المصرية (Egypt)',
    '🇸🇦 اللهجة السعودية والخليجية (Gulf)',
    '🇲🇦 اللهجة المغربية وشمال إفريقيا (North Africa)',
    '🇸🇾 اللهجة الشامية (Levantine)',
    '🌍 اللغة العربية الفصحى (MSA)',
  ];

  final List<String> videoFilters = [
    'بدون فلتر (Normal)',
    'سينمائي دافئ (Cinematic Warm)',
    'أبيض وأسود فني (B&W)',
    'تباين عالي (High Contrast)',
    'رومانسي ناعم (Soft Glow)',
  ];

  late String selectedDialect;
  late String selectedFilter;
  double videoSpeed = 1.0;

  final TextEditingController textController = TextEditingController();
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    selectedDialect = arabicDialects[0];
    selectedFilter = videoFilters[0];
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_fill_rounded, size: 56, color: Colors.blueAccent),
                    const SizedBox(height: 6),
                    Text(
                      'معاينة الفيديو | الفلتر: $selectedFilter',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      'السرعة: ${videoSpeed.toStringAsFixed(1)}x',
                      style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اختر اللهجة العربية للتوليد الصوتي:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 4),
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
                          child: Text(dialect, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDialect = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'فلتر الفيديو التأثيري:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1E1E1E),
                      underline: const SizedBox(),
                      items: videoFilters.map((String filter) {
                        return DropdownMenuItem<String>(
                          value: filter,
                          child: Text(filter, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('سرعة تشغيل المقطع:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      Text('${videoSpeed.toStringAsFixed(1)}x', style: const TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: videoSpeed,
                    min: 0.5,
                    max: 3.0,
                    divisions: 5,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.grey[800],
                    onChanged: (double value) {
                      setState(() {
                        videoSpeed = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: textController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                  const SizedBox(height: 10),
                  Center(
                    child: isGenerating
                        ? const CircularProgressIndicator(color: Colors.blueAccent)
                        : ElevatedButton.icon(
                            onPressed: generateAIVoice,
                            icon: const Icon(Icons.mic_rounded, size: 16),
                            label: const Text('توليد الصوت الذكي'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
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
                const SizedBox(height: 8),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey[850]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_creation_outlined, color: Colors.grey, size: 16),
                      const SizedBox(width: 6),
                      Text('التايم لاين الرئيسي (Timeline Tracks)', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
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

  Widget _buildToolButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 18),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ],
    );
  }
}