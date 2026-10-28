import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String avatarUrl = 'https://i.pravatar.cc/300';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeProfilePicture,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.black, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Rhency Deleon', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('vigilante.user@gmail.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // My Purchases Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('My Purchases', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('View History >', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusItem(Icons.account_balance_wallet_outlined, 'To Pay', () {
                        _showInfoSnack('Navigating to To Pay orders...');
                      }),
                      _buildStatusItem(Icons.inventory_2_outlined, 'To Ship', () {
                        _showInfoSnack('Navigating to To Ship orders...');
                      }),
                      _buildStatusItem(Icons.local_shipping_outlined, 'To Receive', () {
                        _showInfoSnack('Navigating to To Receive orders...');
                      }),
                      _buildStatusItem(Icons.star_outline, 'To Rate', () {
                        _showInfoSnack('Navigating to To Rate items...');
                      }),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings / Account Options (Including Change Password)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_reset, color: Colors.white),
                    title: const Text('Change Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                    onTap: _showChangePasswordDialog,
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
                    onTap: () {
                      _showInfoSnack('Logged out successfully.');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  void _showInfoSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _changeProfilePicture() {
    setState(() {
      avatarUrl = 'https://i.pravatar.cc/300?u=${DateTime.now().millisecondsSinceEpoch}';
    });
    _showInfoSnack('Profile picture updated successfully!');
  }

  void _showChangePasswordDialog() {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Change Password', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPassController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
              onPressed: () {
                Navigator.pop(context);
                _showInfoSnack('Password successfully changed!');
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}