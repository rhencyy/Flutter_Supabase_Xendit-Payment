import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _brown = Color(0xFF5C3A21);
  final _client = Supabase.instance.client;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final meta = _client.auth.currentUser?.userMetadata ?? {};
    _nameCtrl.text = meta['full_name']?.toString() ?? '';
    _phoneCtrl.text = meta['phone']?.toString() ?? '';
    _addressCtrl.text = meta['address']?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _msg(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _client.auth.updateUser(UserAttributes(data: {
        'full_name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
      }));
      if (mounted) _msg('Profile saved!');
    } catch (e) {
      if (mounted) _msg('Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePassword() async {
    final ctrl = TextEditingController();
    final newPass = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          decoration: const InputDecoration(
              labelText: 'New password (min. 6 characters)',
              border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            style: ElevatedButton.styleFrom(backgroundColor: _brown),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (newPass == null || newPass.isEmpty) return;
    if (newPass.length < 6) {
      _msg('Password must be at least 6 characters');
      return;
    }
    try {
      await _client.auth.updateUser(UserAttributes(password: newPass));
      if (mounted) _msg('Password updated!');
    } catch (e) {
      if (mounted) _msg('Failed: $e');
    }
  }

  Future<void> _sendResetLink() async {
    final email = _client.auth.currentUser?.email;
    if (email == null) return;
    try {
      await _client.auth.resetPasswordForEmail(email);
      if (mounted) _msg('Reset link sent to $email');
    } catch (e) {
      if (mounted) _msg('Failed: $e');
    }
  }

  Future<void> _signOut() async {
    await _client.auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _client.auth.currentUser?.email ?? 'N/A';
    final initial =
        (_nameCtrl.text.isNotEmpty ? _nameCtrl.text : email).substring(0, 1).toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: _brown,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: _brown,
              child: Text(initial,
                  style: const TextStyle(fontSize: 36, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(email,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 24),
          const Text('Shipping Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _brown)),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                labelText: 'Phone number',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
                labelText: 'Delivery address',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            style: ElevatedButton.styleFrom(
                backgroundColor: _brown, padding: const EdgeInsets.symmetric(vertical: 14)),
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save Profile', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 24),
          const Text('Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _brown)),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePassword,
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Forgot Password (send reset link)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _sendResetLink,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: _signOut,
          ),
        ],
      ),
    );
  }
}