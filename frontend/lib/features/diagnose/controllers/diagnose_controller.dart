import 'package:flutter/material.dart';
import '../../../models/diagnosis_result_model.dart';

class DiagnoseController extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController complaintController = TextEditingController(
    text: 'Engine is shaking when idling.',
  );
  final GlobalKey carKey = GlobalKey();
  final GlobalKey micKey = GlobalKey();

  DiagnosisResult? _diagnosisResult;
  bool _isLoading = false;
  String? _errorMessage;
  String _displayedComplaint = '';
  bool _messageSent = false; // Track if message was sent to keep card expanded

  DiagnosisResult? get diagnosisResult => _diagnosisResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get displayedComplaint => _displayedComplaint;
  bool get messageSent => _messageSent;

  void initializeComplaintSelection() {
    complaintController.selection = TextSelection.collapsed(
      offset: complaintController.text.length,
    );
  }

  void setDiagnosisResult(DiagnosisResult? result) {
    _diagnosisResult = result;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void setDisplayedComplaint(String complaint) {
    _displayedComplaint = complaint;
    notifyListeners();
  }

  void setMessageSent(bool sent) {
    _messageSent = sent;
    notifyListeners();
  }

  void clearDiagnosis() {
    _diagnosisResult = null;
    _errorMessage = null;
    _isLoading = false;
    _messageSent = false;
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.dispose();
    complaintController.dispose();
    super.dispose();
  }
}
