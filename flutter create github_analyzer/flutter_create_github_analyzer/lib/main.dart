import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';

// Configuration: IP Address & API Base URL
class AppConfig {
  static const String ipAddress = "172.26.38.150";
  static const String baseUrl = "http://172.26.38.150:8000/analyze";
}

void main() => runApp(const GitHubAnalyzerApp());

class GitHubAnalyzerApp extends StatefulWidget {
  const GitHubAnalyzerApp({super.key});

  @override
  State<GitHubAnalyzerApp> createState() => _GitHubAnalyzerAppProState();
}

class _GitHubAnalyzerAppProState extends State<GitHubAnalyzerApp> {
  bool _isDarkMode = true; // Default to Modern Dark Mode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitAnalyzer Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurpleAccent,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurpleAccent,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: const Color(0xFF1A1D29),
        ),
      ),
      home: RepoAnalyzerScreenPro(
        isDarkMode: _isDarkMode,
        onThemeChanged: (val) => setState(() => _isDarkMode = val),
      ),
    );
  }
}

class RepoAnalyzerScreenPro extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const RepoAnalyzerScreenPro({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<RepoAnalyzerScreenPro> createState() => _RepoAnalyzerScreenProState();
}

class _RepoAnalyzerScreenProState extends State<RepoAnalyzerScreenPro> {
  final _ownerController = TextEditingController(text: "flutter");
  final _repoController = TextEditingController(text: "flutter");
  Map<String, dynamic>? _repoData;
  bool _isLoading = false;

  // --- LOGIC: Fetch Data from Python Backend ---
  Future<void> _fetchData() async {
    final owner = _ownerController.text.trim();
    final repo = _repoController.text.trim();
    if (owner.isEmpty || repo.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}?owner=$owner&repo_name=$repo'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _repoData = json.decode(utf8.decode(response.bodyBytes));
        });
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- LOGIC: Professional PDF Report Generation ---
  Future<void> _generatePdfReport() async {
    if (_repoData == null) return;
    final pdf = pw.Document();
    final repo = _repoData!['repo_info'];
    final languages = _repoData!['languages'] as Map<String, dynamic>;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          _buildPdfHeader(),
          pw.SizedBox(height: 24),
          _buildPdfRepoIdentity(repo),
          pw.SizedBox(height: 20),
          _buildPdfStatsGrid(repo),
          pw.SizedBox(height: 32),
          _buildPdfLanguagesTable(languages),
          pw.SizedBox(height: 40),
          _buildPdfFooter(),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: '${repo['name']}_Analysis_Report',
    );
  }

  // --- UI Components ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitAnalyzer Pro"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
          ),
          if (_repoData != null)
            IconButton(
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.deepPurpleAccent,
              ),
              onPressed: _generatePdfReport,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSearchCard(),
            const SizedBox(height: 32),
            if (_isLoading) _buildShimmerLoading(),
            if (!_isLoading && _repoData != null) _buildResultView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _ownerController,
              decoration: const InputDecoration(
                labelText: "GitHub Owner",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _repoController,
              decoration: const InputDecoration(
                labelText: "Repository Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "RUN DEEP ANALYSIS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[widget.isDarkMode ? 800 : 300]!,
      highlightColor: Colors.grey[widget.isDarkMode ? 700 : 100]!,
      child: Column(
        children: [
          Container(
            height: 30,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 180,
            width: 180,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final languages = _repoData!['languages'] as Map<String, dynamic>;
    return Column(
      children: [
        Text(
          _repoData!['repo_info']['name'].toString().toUpperCase(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurpleAccent,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: _getChartSections(languages),
              centerSpaceRadius: 50,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ...languages.entries.map(
          (e) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.circle,
                size: 12,
                color: Colors.deepPurpleAccent,
              ),
              title: Text(
                e.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "${e.value['Percentage']}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getChartSections(Map<String, dynamic> languages) {
    final colors = [
      Colors.deepPurpleAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.orangeAccent,
      Colors.cyanAccent,
    ];
    int index = 0;
    return languages.entries.map((e) {
      final color = colors[index % colors.length];
      index++;
      return PieChartSectionData(
        color: color,
        value: (e.value['Percentage'] as num).toDouble(),
        title: '',
        radius: 60,
      );
    }).toList();
  }

  // --- PDF WIDGETS ---
  pw.Widget _buildPdfHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: const pw.BoxDecoration(
        color: PdfColors.deepPurple900,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "GITHUB REPOSITORY ANALYSIS",
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "Generated via GitAnalyzer Pro by AmeeSha NimsiTh",
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
              ),
            ],
          ),
          pw.Text(
            DateTime.now().toString().split(' ')[0],
            style: const pw.TextStyle(color: PdfColors.white),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfRepoIdentity(dynamic repo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          repo['name'].toString().toUpperCase(),
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.deepPurple,
          ),
        ),
        pw.Text(
          "github.com/${repo['owner']}/${repo['name']}",
          style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 10),
        ),
      ],
    );
  }

  pw.Widget _buildPdfStatsGrid(dynamic repo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildStatBox("Stars", repo['stars'].toString()),
        _buildStatBox("Forks", repo['forks'].toString()),
        _buildStatBox("Issues", repo['open_issues'].toString()),
      ],
    );
  }

  pw.Widget _buildStatBox(String label, String value) {
    return pw.Container(
      width: 100,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfLanguagesTable(Map<String, dynamic> languages) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.deepPurple700),
      data: <List<String>>[
        ['Language', 'Usage Percentage (%)'],
        ...languages.entries.map((e) => [e.key, "${e.value['Percentage']}%"]),
      ],
    );
  }

  pw.Widget _buildPdfFooter() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          "Developer: AmeeSha NimsiTh (GitAnalyzer Pro)",
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
        pw.Text(
          "Page 1 of 1",
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
        ),
      ],
    );
  }
}
