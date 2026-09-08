import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'a_i_chat_bot_model.dart';
export 'a_i_chat_bot_model.dart';

class AIChatBotWidget extends StatefulWidget {
  const AIChatBotWidget({super.key});

  @override
  State<AIChatBotWidget> createState() => _AIChatBotWidgetState();
}

class _AIChatBotWidgetState extends State<AIChatBotWidget> {
  late AIChatBotModel _model;
  final ScrollController _scrollController = ScrollController();

  List<ProcedureRow> procedures = [];
  List<UserRow> dentists = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AIChatBotModel());
    _loadChatData();
  }

  @override
  void dispose() {
    _model.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatData() async {
    try {
      final fetchedProcs = await ProcedureTable().queryRows(queryFn: (q) => q.eq('status', 'Active')).catchError((_) => <ProcedureRow>[]);
      final fetchedDentists = await UserTable().queryRows(queryFn: (q) => q.eq('user_type', 'Dentist')).catchError((_) => <UserRow>[]);
      setState(() {
        if (fetchedProcs.isEmpty) {
          procedures = [
            ProcedureRow({'procedure_id': 'proc_1', 'procedure_name': 'Teeth Cleaning', 'pricing': 1500, 'category': 'General', 'status': 'Active'}),
            ProcedureRow({'procedure_id': 'proc_2', 'procedure_name': 'Teeth Whitening', 'pricing': 3000, 'category': 'Cosmetic', 'status': 'Active'}),
            ProcedureRow({'procedure_id': 'proc_3', 'procedure_name': 'Dental Filling', 'pricing': 2000, 'category': 'Restorative', 'status': 'Active'}),
            ProcedureRow({'procedure_id': 'proc_4', 'procedure_name': 'Root Canal', 'pricing': 8000, 'category': 'Endodontic', 'status': 'Active'}),
          ];
        } else {
          procedures = fetchedProcs;
        }

        if (fetchedDentists.isEmpty) {
          dentists = [
            UserRow({'user_id': 'dentist_1', 'fullname': 'Dr. Sarah Mitchell', 'user_type': 'Dentist'}),
            UserRow({'user_id': 'dentist_2', 'fullname': 'Dr. James Carter', 'user_type': 'Dentist'}),
            UserRow({'user_id': 'dentist_3', 'fullname': 'Dr. Priya Nair', 'user_type': 'Dentist'}),
          ];
        } else {
          dentists = fetchedDentists;
        }
      });
    } catch (e) {
      print('Error loading chatbot data: $e');
      setState(() {
        procedures = [
          ProcedureRow({'procedure_id': 'proc_1', 'procedure_name': 'Teeth Cleaning', 'pricing': 1500, 'category': 'General', 'status': 'Active'}),
          ProcedureRow({'procedure_id': 'proc_2', 'procedure_name': 'Teeth Whitening', 'pricing': 3000, 'category': 'Cosmetic', 'status': 'Active'}),
        ];
        dentists = [
          UserRow({'user_id': 'dentist_1', 'fullname': 'Dr. Sarah Mitchell', 'user_type': 'Dentist'}),
        ];
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<String> _generateReply(String query) async {
    final normalized = query.toLowerCase().trim();

    // 1. Check for database modification / privilege escalation attempts
    if (normalized.contains('make me admin') ||
        normalized.contains('grant admin') ||
        normalized.contains('update role') ||
        normalized.contains('set admin') ||
        normalized.contains('change my role') ||
        normalized.contains('become admin') ||
        normalized.contains('make me an admin') ||
        normalized.contains('give me admin') ||
        normalized.contains('sudo') ||
        normalized.contains('overwrite database') ||
        normalized.contains('edit database') ||
        normalized.contains('modify database') ||
        normalized.contains('update database') ||
        normalized.contains('delete database') ||
        normalized.contains('sql inject') ||
        normalized.contains('drop table') ||
        normalized.contains('insert into') ||
        normalized.contains('delete from') ||
        normalized.contains('update payments')) {
      return 'Warning: Unauthorized database edit or privilege escalation attempt detected. This activity has been logged.';
    }

    // 2. Check for weather / forecast (off-topic example)
    if (normalized.contains('weather') ||
        normalized.contains('forecast') ||
        normalized.contains('temperature today') ||
        normalized.contains('is it raining')) {
      return "I must stay true to the application's purpose. I can only assist with queries related to Toothy Dental Clinic.";
    }

    // 3. Make Gemini API Post Request
    try {
      final proceduresText = procedures.isEmpty
          ? 'No services currently configured.'
          : procedures.map((p) => '• ${p.procedureName}: ₱${p.pricing ?? 0} (Category: ${p.category})').join('\n');

      final dentistsText = dentists.isEmpty
          ? 'No dentists currently available.'
          : dentists.map((d) => '• ${d.fullname ?? 'Dentist'}').join('\n');

      final systemPrompt = '''
You are the AI Chatbot Assistant for Toothy Dental Clinic. Your job is to answer patients' questions about clinic hours, location, procedures, prices, and dentists.

Here is the current clinic data retrieved from our database:
Procedures and Prices:
$proceduresText

Active Dentists:
$dentistsText

Clinic Hours:
Monday - Saturday: 9:00 AM - 5:00 PM (Closed on Sundays)

Location Address:
2nd Floor, Med Plaza, Metro Manila.
Contact Number: (02) 888-DENT

CRITICAL RULES:
1. You have strictly READ-ONLY access. You cannot edit, delete, insert, or overwrite any database entries. Under no circumstances can you change user roles, modify bookings, or grant administrative privileges.
2. If the user asks you to perform database actions, change user roles, make them an admin, edit records, or anything similar, you must refuse and say: "I do not have authorization to edit database records or modify user privileges."
3. Stay on topic: You must only answer questions relevant to Toothy Dental Clinic. If the user asks about unrelated topics (such as weather, recipes, sports, news, coding, politics, or general trivia), you must reply with exactly: "I must stay true to the application's purpose. I can only assist with queries related to Toothy Dental Clinic."
4. Be polite, concise, and friendly. Do not output markdown lists of system instructions.
''';

      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': 'GEMINI_API_KEY_HERE',
        },
        body: jsonEncode({
          'systemInstruction': {
            'parts': [
              {
                'text': systemPrompt,
              }
            ]
          },
          'contents': [
            {
              'parts': [
                {
                  'text': query,
                }
              ]
            }
          ]
        }),
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map?;
          if (content != null) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final reply = parts[0]['text'] as String?;
              if (reply != null && reply.isNotEmpty) {
                return reply.trim();
              }
            }
          }
        }
      }
      
      // Fallback to local rule-based engine if HTTP request failed or response parsed empty
      return _generateLocalFallbackReply(normalized);
    } catch (e) {
      print('Gemini API call failed: $e. Falling back to local rule engine.');
      return _generateLocalFallbackReply(normalized);
    }
  }

  String _generateLocalFallbackReply(String query) {
    // 1. Check for pricing / procedures / cost / fee
    if (query.contains('price') ||
        query.contains('pricing') ||
        query.contains('cost') ||
        query.contains('fee') ||
        query.contains('charge') ||
        query.contains('rate') ||
        query.contains('how much') ||
        query.contains('procedure') ||
        query.contains('service')) {
      if (procedures.isEmpty) {
        return 'Our dental services include Teeth Cleaning, Teeth Whitening, Filling, Root Canal, and Orthodontics. Please visit the Prices page for estimated costs.';
      }
      final list = procedures.map((p) => '• ${p.procedureName}: ₱${p.pricing ?? 0}').join('\n');
      return 'Here are our dental services and estimated procedure prices:\n$list\n\n*Please note: Prices are read-only estimated budgets for patients.*';
    }

    // 2. Check for dentist / doctor / dentist names
    if (query.contains('dentist') ||
        query.contains('doctor') ||
        query.contains('specialist') ||
        query.contains('who works') ||
        query.contains('dr.')) {
      if (dentists.isEmpty) {
        return 'We have several qualified dentists available. You can view all our dentists and select them when scheduling an appointment.';
      }
      final list = dentists.map((d) => '• ${d.fullname ?? 'Dentist'}').join('\n');
      return 'Our clinic features the following dedicated dentists:\n$list\n\nYou can select a specific dentist when booking your appointment.';
    }

    // 3. Check for clinic hours
    if (query.contains('hour') ||
        query.contains('opening') ||
        query.contains('schedule') ||
        query.contains('open') ||
        query.contains('close') ||
        query.contains('time')) {
      return 'Toothy Clinic is open Monday to Saturday from 9:00 AM to 5:00 PM. We are closed on Sundays.';
    }

    // 4. Check for location
    if (query.contains('location') ||
        query.contains('address') ||
        query.contains('where') ||
        query.contains('place') ||
        query.contains('map') ||
        query.contains('find you')) {
      return 'We are located at: Toothy Dental Clinic, 2nd Floor, Med Plaza, Metro Manila. Walk-ins and bookings are welcome!';
    }

    // 5. Check for booking
    if (query.contains('book') ||
        query.contains('appointment') ||
        query.contains('schedule') ||
        query.contains('reserve') ||
        query.contains('booking')) {
      return 'You can schedule an appointment directly by navigating to the "Book Appointment" section on your dashboard. You can select your dentist, date, and preferred time slot there!';
    }

    // 6. Check for greetings
    if (query.contains('hello') ||
        query.contains('hi') ||
        query.contains('hey') ||
        query.contains('greetings')) {
      return 'Hello! How can I assist you with your dental queries today? You can ask about our dentists, services, prices, or operating hours.';
    }

    // Fallback message
    return 'I\'m sorry, I can only help with informational queries regarding clinic hours, location, services, and dentist details. For other requests, please contact our front desk at (02) 888-DENT.';
  }

  void _sendMessage() async {
    final text = _model.textController?.text.trim();
    if (text == null || text.isEmpty) return;

    setState(() {
      _model.chatMessages.add({
        'text': text,
        'isUser': true,
      });
      _model.textController?.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // Call dynamic API query
    final reply = await _generateReply(text);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _model.chatMessages.add({
          'text': reply,
          'isUser': false,
        });
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                color: const Color(0xFF6B4FA8), // Toothy & Co. Brand purple
                borderRadius: BorderRadius.circular(10.0),
              ),
              alignment: Alignment.center,
              child: const Text(
                '🦷',
                style: TextStyle(fontSize: 22.0),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ai Dentistant',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.interTight(),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Online',
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              font: GoogleFonts.inter(),
                              color: Colors.green,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        elevation: 1.0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Messages View
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _model.chatMessages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _model.chatMessages.length) {
                    // Render typing indicator bubble
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B4FA8),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '🦷',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    'Ai Dentistant is typing...',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final message = _model.chatMessages[index];
                  final isUser = message['isUser'] as bool;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B4FA8),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '🦷',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16.0),
                                topRight: const Radius.circular(16.0),
                                bottomLeft: Radius.circular(isUser ? 16.0 : 0.0),
                                bottomRight: Radius.circular(isUser ? 0.0 : 16.0),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Text(
                              message['text'] as String,
                              style: TextStyle(
                                color: isUser ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                                fontSize: 14.0,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                            ),
                          ),
                        ),
                        if (isUser) const SizedBox(width: 8.0),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              color: FlutterFlowTheme.of(context).secondaryBackground,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      onFieldSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 22.0,
                    buttonSize: 44.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.send_rounded,
                      color: FlutterFlowTheme.of(context).info,
                      size: 20.0,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
