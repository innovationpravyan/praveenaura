import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/utils/database_utils.dart';
import '../../widgets/base_screen.dart';

class DebugDataUploadScreen extends ConsumerStatefulWidget {
  const DebugDataUploadScreen({super.key});

  @override
  ConsumerState<DebugDataUploadScreen> createState() => _DebugDataUploadScreenState();
}

class _DebugDataUploadScreenState extends ConsumerState<DebugDataUploadScreen> {
  bool _isLoading = false;
  String? _message;
  Map<String, int>? _dataCount;

  @override
  void initState() {
    super.initState();
    _checkExistingData();
  }

  Future<void> _checkExistingData() async {
    try {
      final count = await DatabaseUtils.getDataCount();
      setState(() {
        _dataCount = count;
      });
    } catch (e) {
      setState(() {
        _message = 'Error checking data: $e';
      });
    }
  }

  Future<void> _uploadSampleData() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await DatabaseUtils.uploadSampleData();
      setState(() {
        _message = '✅ Sample data uploaded successfully!\n5 salons and 12 services added to Firestore.';
      });
      await _checkExistingData();
    } catch (e) {
      setState(() {
        _message = '❌ Error uploading data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetAndUploadData() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await DatabaseUtils.resetAndUploadData();
      setState(() {
        _message = '✅ Data reset and uploaded successfully!\nFresh 5 salons and 12 services in Firestore.';
      });
      await _checkExistingData();
    } catch (e) {
      setState(() {
        _message = '❌ Error resetting data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Debug: Data Upload',
      showBottomNavigation: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Firestore Data Status',
                      style: context.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_dataCount != null) ...[
                      Text('Salons in database: ${_dataCount!['salons']}'),
                      Text('Services in database: ${_dataCount!['services']}'),
                    ] else
                      const Text('Checking database...'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Sample Data',
                      style: context.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This will upload the sample salon and service data from database_service.dart to Firestore:',
                    ),
                    const SizedBox(height: 8),
                    const Text('• 5 Salons (Elegance Beauty, Glamour Studio, etc.)'),
                    const Text('• 12 Services (Hair Care, Skin Care, Makeup, etc.)'),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _uploadSampleData,
                      icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload),
                      label: Text(_isLoading ? 'Uploading...' : 'Upload Sample Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _resetAndUploadData,
                      icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                      label: Text(_isLoading ? 'Resetting...' : 'Reset & Upload Fresh Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_message != null)
              Card(
                color: _message!.startsWith('✅')
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color: _message!.startsWith('✅')
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}