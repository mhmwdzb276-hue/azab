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
      title: 'Azab..x Pro',
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
  int _currentIndex = 0;
  int freeVideosRemaining = 3; // السماح بـ 3 فيديوهات مجانية لتجربة كاملة واحترافية

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
          content: Text('من فضلك اكتب النص أولاً لتوليد الصوت باللهجة المحددة!'),
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
          content: Text('تم توليد الصوت النقي بنجاح ($selectedDialect)!'),
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

    // التحقق من عدد المحاولات المجانية المتبقية (3 فيديوهات)
    if (freeVideosRemaining <= 0) {
      openSubscriptionDialog(isLimitReached: true);
      return;
    }

    setState(() {
      isGeneratingVideo = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isGeneratingVideo = false;
        freeVideosRemaining--; // خصم محاولة من الثلاثة
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم توليد الفيديو بنجاح! متبقي لك ($freeVideosRemaining) محاولات مجانية.'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    });
  }

  void openSubscriptionDialog({bool isLimitReached = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
              const SizedBox(width: 8),
              Text(
                isLimitReached ? 'استهلكت محاولاتك الثلاث المجانية!' : 'ترقية إلى Azab..x Pro',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLimitReached
                      ? 'جربت التطبيق وشوفت الجودة العالية في أول 3 فيديوهات بنفسك! اشترك الآن بـ 5$ فقط لفتح أحدث الأدوات والمميزات وحرية التوليد بلا حدود وبدون علامة مائية.'
                      : 'استمتع بكافة مميزات الذكاء الاصطناعي بلا حدود، بدقة 4K حقيقية، وبدون أي علامة مائية.',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                _buildPlanCard('الباقة الاحترافية (Pro Plan)', '5.00 \$ / شهرياً', Colors.blueAccent),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(isLimitReached ? 'لاحقاً' : 'متابعة مجاناً', style: const TextStyle(color: Colors.grey)),
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
              setState(() {
                freeVideosRemaining = 15; // تفعيل محاولات متقدمة بعد الاشتراك
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SNackBar(
                  content: Text('مبروك! تم تفعيل اشتراك Pro بنجاح وأصبحت كل الميزات متاحة.'),
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
        title: Text(_currentIndex == 0 ? 'Azab..x (المجاني: $freeVideosRemaining فيديوهات)' : 'Azab..x - القوالب'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
        actions: [
          TextButton.icon(
            onPressed: () => openSubscriptionDialog(isLimitReached: false),
            icon: const Icon(Icons.workspace_premium, color: Colors.amber, size: 18),
            label: const Text('PRO', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildStudioTab() : _buildTemplatesTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF181818),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation),
            label: 'الاستوديو',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'القوالب',
          ),
        ],
      ),
    );
  }

  Widget _buildStudioTab() {
    return Column(
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
                    'منطقة المعاينة (AI Video Preview)',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الجودة: $selectedResolution | المتبقي مجاناً: $freeVideosRemaining فيديوهات',
                    style: const TextStyle(color: Colors.amberAccent, fontSize: 11),
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
                    hintText: 'اكتب وصف المشهد لتوليد فيديو عالي الجودة...',
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
                    hintText: 'اكتب النص للتحويل الصوتي النقي...',
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
      ],
    );
  }

  Widget _buildTemplatesTab() {
    final List<Map<String, String>> templates = [
      {'title': 'قصص أطفال كرتونية', 'desc': 'قالب مخصص لتحريك الشخصيات وصوت نقي.', 'tag': 'مجاني'},
      {'title': 'فيديوهات ريلز حماسية', 'desc': 'انتقالات سريعة ونصوص متحركة لجذب المشاهدين.', 'tag': 'PRO'},
      {'title': 'وثائقيات الغابة والطبيعة', 'desc': 'مؤثرات سينمائية عالية الجودة.', 'tag': 'PRO'},
      {'title': 'إعلانات تجارية للمتاجر', 'desc': 'تصميم تسويقي احترافي جاهز بالكامل.', 'tag': 'مجاني'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final t = templates[index];
        return Card(
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: const Icon(Icons.auto_fix_high, color: Colors.amber, size: 28),
            title: Text(t['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text(t['desc']!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            trailing: Chip(
              label: Text(t['tag']!, style: const TextStyle(fontSize: 10, color: Colors.black)),
              backgroundColor: t['tag'] == 'PRO' ? Colors.amber : Colors.blueAccent,
              padding: EdgeInsets.zero,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم فتح قالب "${t['title']}" بنجاح!'),
                  backgroundColor: Colors.blueAccent,
                ),
              );
            },
          ),
        );
      },
    );
  }
}