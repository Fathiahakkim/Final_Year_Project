import 'package:flutter/material.dart';
import '../../../state/app_state.dart';
import '../../../models/diagnosis_history_entry.dart';

class FeedbackSection extends StatefulWidget {
  final AppState appState;

  const FeedbackSection({super.key, required this.appState});

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleSendFeedback() {
    // Capture feedback text (will be sent to backend later)
    final feedbackText = _feedbackController.text.trim(); // ignore: unused_local_variable
    _feedbackController.clear();
    // TODO: Send feedbackText to backend when backend is implemented
  }

  FeedbackStatus? _getSelectedFeedbackStatus() {
    if (widget.appState.selectedHistoryIndex == null) return null;
    if (widget.appState.diagnosisHistory.isEmpty) return null;
    
    final selectedIndex = widget.appState.selectedHistoryIndex!;
    if (selectedIndex < 0 || selectedIndex >= widget.appState.diagnosisHistory.length) return null;
    
    return widget.appState.diagnosisHistory[selectedIndex].feedbackStatus;
  }

  bool _areButtonsDisabled() {
    final feedbackStatus = _getSelectedFeedbackStatus();
    return feedbackStatus != null && feedbackStatus != FeedbackStatus.notReviewed;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, child) {
        final buttonsDisabled = _areButtonsDisabled();
        final selectedFeedbackStatus = _getSelectedFeedbackStatus();
        final isYesSelected = selectedFeedbackStatus == FeedbackStatus.correct;
        final isNoSelected = selectedFeedbackStatus == FeedbackStatus.incorrect;
        
        return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Feedback on Diagnosis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Was the diagnosis accurate?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FeedbackButton(
                  icon: Icons.thumb_up,
                  label: 'Yes',
                  isSelected: isYesSelected,
                  color: Colors.blue,
                  isDisabled: buttonsDisabled,
                  onTap: () {
                    widget.appState.updateMostRecentFeedbackStatus(FeedbackStatus.correct);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FeedbackButton(
                  icon: Icons.thumb_down,
                  label: 'No',
                  isSelected: isNoSelected,
                  color: Colors.grey,
                  iconColor: Colors.red,
                  isDisabled: buttonsDisabled,
                  onTap: () {
                    widget.appState.updateMostRecentFeedbackStatus(FeedbackStatus.incorrect);
                  },
                ),
              ),
            ],
          ),
          if (isNoSelected) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      hintText: 'What was the actual issue?',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _feedbackController.text.trim().isEmpty ? null : _handleSendFeedback,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ],
      ),
        );
      },
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool isDisabled;

  const _FeedbackButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
    this.iconColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (iconColor ?? Colors.grey.shade600),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
