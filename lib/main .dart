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
      title: 'Azab..x Pro Studio',
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
  int freeVideosRemaining = 3; // 3 محاولات مجانية

  // حالات نظام الاشتراك الحقيقي
  bool isProActive = false;
  String subscriptionStatus = 'الباقة المجانية (Free Tier)';
  DateTime? subscriptionExpiryDate;

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

  final TextEditingController voiceTextController = TextEditingController();
  final TextEditingController videoPromptController = TextEditingController();

  bool isGeneratingVoice = false;
  bool isGeneratingVideo = false;

  final List<Map<String, dynamic>> timelineLayers = [
    {'type': 'video', 'name': 'مشهد الذكاء الاصطناعي (1)', 'duration': '05:00 ث', 'icon': Icons.movie},
    {'type': 'audio', 'name': 'تعليق صوتي (اللهجة المصرية)', 'duration': '05:00 ث', 'icon': Icons.mic},
    {'type': 'text', 'name': 'نصوص متحركة (Subtitles)', 'duration': '05:00 ث', 'icon': Icons.text_fields},
  ];

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
        timelineLayers.add({
          'type': 'audio',
          'name': 'صوت جديد ($selectedDialect)',
          'duration': '04:30 ث',
          'icon': Icons.mic,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم توليد وإضافة الصوت للتايم لاين بنجاح ($selectedDialect)!'),
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

    // إذا لم يكن مشتركاً وانتهت محاولاته المجانية (أو انتهى اشتراكه)
    if (!isProActive && freeVideosRemaining <= 0) {
      openSubscriptionDialog(isLimitReached: true);
      return;
    }

    setState(() {
      isGeneratingVideo = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isGeneratingVideo = false;
        if (!isProActive) {
          freeVideosRemaining--; // خصم من المجاني فقط
        }
        timelineLayers.add({
          'type': 'video',
          'name': 'مقطع AI جديد ($selectedResolution)',
          'duration': '06:00 ث',
          'icon': Icons.movie_creation,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isProActive
              ? 'تم توليد الفيديو بنجاح (حساب Pro نشط بلا حدود).'
              : 'تم توليد الفيديو! متبقي لك ($freeVideosRemaining) محاولات مجانية.'),
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
                isLimitReached ? 'انتهت محاولاتك المجانية الثلاث!' : 'إدارة الاشتراكات (Azab..x Pro)',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLimitReached
                      ? 'لقد استهلكت محاولاتك المجانية! اشترك الآن بـ 5$ شهرياً لتفعيل اشتراك Pro وتجنب إغلاق ميزات التحرير والتصدير.'
                      : 'حالة الحساب الحالية: $subscriptionStatus\n' + (subscriptionExpiryDate != null ? 'تاريخ انتهاء الاشتراك: ${subscriptionExpiryDate.toString().substring(0, 10)}' : ''),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 12),
                _buildPlanCard('الباقة الاحترافية (Pro Plan)', '5.00 \$ / شهرياً', Colors.blueAccent),
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
      padding: const EdgeInsets.all(10),
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
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              const SizedBox(height: 2),
              Text(price, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isProActive = true;
                subscriptionStatus = 'باقة Pro نشطة (مدفوعة)';
                // نفترض أن الاشتراك لمدة 30 يوماً من تاريخ اليوم
                subscriptionExpiryDate = DateTime.now().add(const Duration(days: 30));
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('مبروك! تم تفعيل اشتراك Pro بنجاح لمدة 30 يوماً.'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(50, 28),
            ),
            child: Text(isProActive ? 'تجديد الاشتراك' : 'اشتراك الآن', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? (isProActive ? 'Azab..x Pro (نشط 🌟)' : 'Azab..x (المجاني: $freeVideosRemaining)')
            : 'Azab..x - القوالب'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
        actions: [
          TextButton.icon(
            onPressed: () => openSubscriptionDialog(isLimitReached: false),
            icon: Icon(Icons.workspace_premium, color: isProActive ? Colors.amber : Colors.grey, size: 18),
            label: Text(isProActive ? 'PRO نشط' : 'اشتراك', style: TextStyle(color: isProActive ? Colors.amber : Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildStudioTab() : _buildTemplatesTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF181818),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation), label: 'المحرر والاستوديو'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'القوالب الذكية'),
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
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_filled, size: 48, color: Colors.amber),
                  SizedBox(height: 4),
                  Text(
                    'شاشة المعاينة المباشرة (Multi-Layer Preview)',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF181818),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('⏱️ الجدول الزمني للطبقات (Timeline)', style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                  Text('حسب حالة الاشتراك', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: timelineLayers.length,
                  itemBuilder: (context, index) {
                    final layer = timelineLayers[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: layer['type'] == 'video' ? Colors.amber : Colors.blueAccent,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(layer['icon'], size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(layer['name'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(layer['duration'], style: const TextStyle(color: Colors.grey, fontSize: 9)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎬 توليد فيديو بالذكاء الاصطناعي:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber)),
                const SizedBox(height: 2),
                TextField(
                  controller: videoPromptController,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  decoration: InputDecoration(
                    hintText: 'وصف المشهد...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(6)),
                        child: DropdownButton<String>(
                          value: selectedResolution,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1E1E1E),
                          underline: const SizedBox(),
                          items: videoResolutions.map((String res) {
                            return DropdownMenuItem<String>(value: res, child: Text(res, style: const TextStyle(color: Colors.white, fontSize: 10)));
                          }).toList(),
                          onChanged: (String? val) => setState(() => selectedResolution = val!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    isGeneratingVideo
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.amber))
                        : ElevatedButton.icon(
                            onPressed: generateAIVideo,
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text('إضافة للتايم لاين', style: TextStyle(fontSize: 10)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 8)),
                          ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('🎙️ توليد الصوت الذكي:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                const SizedBox(height: 2),
                Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(6)),
                  child: DropdownButton<String>(
                    value: selectedDialect,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E1E1E),
                    underline: const SizedBox(),
                    items: arabicDialects.map((String d) {
                      return DropdownMenuItem<String>(value: d, child: Text(d, style: const TextStyle(color: Colors.white, fontSize: 10)));
                    }).toList(),
                    onChanged: (String? val) => setState(() => selectedDialect = val!),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: voiceTextController,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  decoration: InputDecoration(
                    hintText: 'النص للتعليق الصوتي...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: isGeneratingVoice
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.blueAccent))
                      : ElevatedButton.icon(
                          onPressed: generateAIVoice,
                          icon: const Icon(Icons.mic, size: 14),
                          label: const Text('توليد وإضافة الصوت', style: TextStyle(fontSize: 10)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
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
            leading: const Icon(Icons.auto_fix_high, colo