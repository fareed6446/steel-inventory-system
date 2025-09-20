import 'package:flutter/material.dart';
import 'services/supabase_service.dart';

class SupabaseTestScreen extends StatefulWidget {
  const SupabaseTestScreen({super.key});

  @override
  State<SupabaseTestScreen> createState() => _SupabaseTestScreenState();
}

class _SupabaseTestScreenState extends State<SupabaseTestScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  String _status = 'Testing connection...';
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      // Test basic connection
      final response = await _supabaseService.client
          .from('users')
          .select('count')
          .limit(1);

      setState(() {
        _status = '✅ Connected to Supabase successfully!';
        _isConnected = true;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Connection failed: $e';
        _isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Test'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isConnected ? Icons.check_circle : Icons.error,
                size: 80,
                color: _isConnected ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                _status,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_isConnected) ...[
                const Text(
                  'Supabase integration is working correctly!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go Back'),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: _testConnection,
                  child: const Text('Retry Connection'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
