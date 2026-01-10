import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../features/account/widgets/profile_card.dart';
import '../features/account/widgets/diagnosis_history_item.dart';
import '../features/account/widgets/feedback_section.dart';

class AccountScreen extends StatelessWidget {
  final AppState appState;

  const AccountScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          ProfileCard(
            name: 'John Doe',
            email: 'john.doe@example.com',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Diagnosis History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  if (appState.diagnosisHistory.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No diagnosis history yet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ...appState.diagnosisHistory.asMap().entries.map((entry) {
                      final index = entry.key;
                      final historyEntry = entry.value;
                      return InkWell(
                        onTap: () {
                          appState.setSelectedHistoryIndex(index);
                        },
                        child: DiagnosisHistoryItem(
                          faultName: historyEntry.primaryFaultName,
                          complaintSummary: historyEntry.complaintText,
                          dateTime: historyEntry.timestamp,
                          confidencePercentage: historyEntry.confidencePercentage,
                          feedbackStatus: historyEntry.feedbackStatus,
                        ),
                      );
                    }),
                  FeedbackSection(appState: appState),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
        ),
      );
      },
    );
  }
}
