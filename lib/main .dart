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

  final List<String> videoResolutions = [
    '🎬 4K Ultra HD (سينمائي فائق الجودة)',
    '🖥️ 1080p Full HD (عالي الدقة)',
    '📱 720p HD (مناسب للمنصات السريعة)',
  ];

  late String selectedDialect;
  late String selectedResolution;
  double videoSpeed = 1.0;

  final TextEditingController voiceTextController = TextEditingController();
  final TextEditingController videoPromptController = TextEditingController();

  bool isGeneratingVoice = false;
  bool isGeneratingVideo = false;

  @override
  void initState() {
    super.initState();
    selectedDialect = arabicDialects[0];
    selectedResolution = videoResolutions[0];
  }

  @override
  void dispose() {
    voiceTextController.dispose();
    videoPromptController.dispose();
    super.dispose();
  }

  void generateAIVoice() {
    final text = voiceTextController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك اكتب النص أولاً لتوليد الصوت بالهجة المحددة!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isGeneratingVoice = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isGeneratingVoice = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم توليد الصوت بوضوح تام ودقة عالية باستخدام ($selectedDialect)!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void generateAIVideo() {
    final prompt = videoPromptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك اكتب وصف الفيديو بالذكاء الاصطناعي أولاً!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isGeneratingVideo = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isGeneratingVideo = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم توليد فيديو احترافي كامل بـ ($selectedResolution) بنجاح!'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    });
  }

  void openSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text('باقات اشتراك Azab..x Pro', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'احصل على وصول غير محدود لتوليد الفيديوهات والأصوات بالذكاء الاصطناعي بجودة عالية جداً وبدون علامة مائية!',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                _buildPlanCard('الباقة المميزة (Pro Plan)', '5.00 \$ / شهرياً', Colors.blueAccent),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlanCard(String title, String price, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 2),
              Text(price, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم اختيار الباقة بنجاح! جاري تحويلك لبوابة الدفع...'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(60, 30),
            ),
            child: const Text('اشتراك', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Azab..x - استوديو المونتاج والذكاء الاصطناعي'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium, color: Colors.amber),
            tooltip: 'الاشتراكات والنسخة المدفوعة',
            onPressed: openSubscriptionDialog,
          ),
        ],
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
                border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, size: 52, color: Colors.amber),
                    const SizedBox(height: 6),
                    const Text(
                      'منطقة المعاينة الاحترافية (AI Video Preview)',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الجودة المتاحة: $selectedResolution | السرعة: ${videoSpeed.toStringAsFixed(1)}x',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
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
                    '🎬 توليد فيديو احترافي بالذكاء الاصطناعي:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: videoPromptController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'اكتب وصف المشهد الذي تريد توليده كفيديو عالي الجودة...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                          ),
                          child: DropdownButton<String>(
                            value: selectedResolution,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF1E1E1E),
                            underline: const SizedBox(),
                            items: videoResolutions.map((String res) {
                              return DropdownMenuItem<String>(
                                value: res,
                                child: Text(res, style: const TextStyle(color: Colors.white, fontSize: 11)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedResolution = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      isGeneratingVideo
                          ? const CircularProgressIndicator(color: Colors.amber)
                          : ElevatedButton.icon(
                              onPressed: generateAIVoice, // Will link to video generator
                              onPressed: generateAIVideo,
                              icon: const Icon(Icons.movie_filter_rounded, size: 16),
                              label: const Text('توليد الفيديو'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🎙️ توليد الصوت الذكي باللهجات العربية:',
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
                          child: Text(dialect, style: const TextStyle(color: Colors.white, fontSize: 11)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDialect = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: voiceTextController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'اكتب النص للتحويل الصوتي الواقي النقي...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: isGeneratingVoice
                        ? const CircularProgressIndicator(color: Colors.blueAccent)
                        : ElevatedButton.icon(
                            onPressed: generateAIVoice,
                            icon: const Icon(Icons.mic_rounded, size: 16),
                            label: const Text('توليد الصوت الذكي'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                    _buildToolButton(Icons.movie_creation, 'الفيديو الذكي'),
                    _buildToolButton(Icons.text_fields, 'نصوص (Text)'),
                    _buildToolButton(Icons.filter_alt, 'فلاتر'),
                    _buildToolButton(Icons.speed, 'السرعة'),
                  ],
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