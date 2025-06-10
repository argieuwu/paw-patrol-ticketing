import 'package:capstone2/res/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
// Import your app_styles.dart file here
// import 'app_styles.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  void signUserOut(BuildContext context) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Sign Out", style: AppStyle.headLineStyle2),
        content: Text("Are you sure you want to sign out?",
            style: AppStyle.headLineStyle3),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel",
                style: AppStyle.headLineStyle4
                    .copyWith(color: AppStyle.textColor2)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Sign Out",
              style: AppStyle.headLineStyle4.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldSignOut ?? false) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  void _showEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const EditProfileBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppStyle.primaryColor,
                    AppStyle.steelBlue,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile",
                            style: AppStyle.bookTickets,
                          ),
                          IconButton(
                            onPressed: _showEditProfile,
                            icon: const Icon(
                              FluentSystemIcons.ic_fluent_edit_regular,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Profile Picture with Border
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppStyle.staticLavander,
                              child: Icon(
                                FluentSystemIcons.ic_fluent_person_filled,
                                size: 60,
                                color: AppStyle.primaryColor,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppStyle.icyTeal,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                FluentSystemIcons.ic_fluent_camera_filled,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user?.displayName ?? "User",
                        style: AppStyle.bookTickets,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?.email ?? "No email",
                        style: AppStyle.goodMorning,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Profile Options
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Account Section
                  _buildSectionHeader("Account"),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: FluentSystemIcons.ic_fluent_person_accounts_filled,
                    title: "Edit Profile",
                    subtitle: "Update your personal information",
                    onTap: _showEditProfile,
                    color: AppStyle.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  _buildOptionCard(
                    icon: FluentSystemIcons.ic_fluent_key_regular,
                    title: "Change Password",
                    subtitle: "Update your account password",
                    onTap: () => _showChangePassword(),
                    color: AppStyle.icyTeal,
                  ),
                  const SizedBox(height: 8),
                  _buildOptionCard(
                    icon: FluentSystemIcons.ic_fluent_ticket_regular,
                    title: "My Bookings",
                    subtitle: "View your travel history",
                    onTap: () => Navigator.pushNamed(context, '/bookings'),
                    color: AppStyle.ticketBlue,
                  ),

                  const SizedBox(height: 24),

                  // Preferences Section
                  _buildSectionHeader("Preferences"),
                  const SizedBox(height: 12),
                  _buildSwitchCard(
                    icon: FluentSystemIcons.ic_fluent_alert_regular,
                    title: "Push Notifications",
                    subtitle: "Receive booking updates",
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                    color: AppStyle.busrouteBG2,
                  ),
                  const SizedBox(height: 8),
                  _buildSwitchCard(
                    icon: FluentSystemIcons.ic_fluent_dark_theme_regular,
                    title: "Dark Mode",
                    subtitle: "Switch to dark theme",
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                    color: AppStyle.bgColor2,
                  ),

                  const SizedBox(height: 24),

                  // Support Section
                  _buildSectionHeader("Support"),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: FluentSystemIcons.ic_fluent_add_circle_regular,
                    title: "Help & Support",
                    subtitle: "Get help with your account",
                    onTap: () => Navigator.pushNamed(context, '/help'),
                    color: AppStyle.frostedJade,
                  ),
                  const SizedBox(height: 8),
                  _buildOptionCard(
                    icon: FluentSystemIcons.ic_fluent_info_regular,
                    title: "About",
                    subtitle: "App version and information",
                    onTap: () => _showAboutDialog(),
                    color: AppStyle.coolLightPurple,
                  ),

                  const SizedBox(height: 32),

                  // Sign Out Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                      color: Colors.red.withOpacity(0.05),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          FluentSystemIcons.ic_fluent_sign_out_regular,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "Sign Out",
                        style: AppStyle.headLineStyle2.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "Sign out of your account",
                        style: AppStyle.headLineStyle5.copyWith(
                          color: Colors.red.withOpacity(0.7),
                        ),
                      ),
                      trailing: const Icon(
                        FluentSystemIcons.ic_fluent_chevron_right_regular,
                        color: Colors.red,
                        size: 16,
                      ),
                      onTap: () => signUserOut(context),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppStyle.headLineStyle2.copyWith(
          color: AppStyle.textColor2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppStyle.headLineStyle4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppStyle.headLineStyle5.copyWith(
            color: AppStyle.textColor.withOpacity(0.7),
          ),
        ),
        trailing: Icon(
          FluentSystemIcons.ic_fluent_chevron_right_regular,
          color: AppStyle.textColor.withOpacity(0.5),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppStyle.headLineStyle4.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppStyle.headLineStyle5.copyWith(
            color: AppStyle.textColor.withOpacity(0.7),
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: color,
          activeTrackColor: color.withOpacity(0.3),
        ),
      ),
    );
  }

  void _showChangePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Change Password", style: AppStyle.headLineStyle2),
        content: Text(
          "A password reset link will be sent to your email address.",
          style: AppStyle.headLineStyle3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: AppStyle.headLineStyle4),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: FirebaseAuth.instance.currentUser?.email ?? '',
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password reset email sent!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              }
            },
            child: Text(
              "Send Reset Link",
              style: AppStyle.headLineStyle4
                  .copyWith(color: AppStyle.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("About", style: AppStyle.headLineStyle2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Travel App", style: AppStyle.headLineStyle4),
            Text("Version 1.0.0", style: AppStyle.headLineStyle5),
            const SizedBox(height: 10),
            Text(
              "Your trusted companion for seamless travel experiences.",
              style: AppStyle.headLineStyle5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK",
                style: AppStyle.headLineStyle4
                    .copyWith(color: AppStyle.primaryColor)),
          ),
        ],
      ),
    );
  }
}

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Edit Profile", style: AppStyle.headLineStyle1),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              style: AppStyle.headLineStyle4,
              decoration: InputDecoration(
                labelText: "Display Name",
                labelStyle: AppStyle.headLineStyle5,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(FluentSystemIcons.ic_fluent_person_regular),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              style: AppStyle.headLineStyle4,
              decoration: InputDecoration(
                labelText: "Phone Number",
                labelStyle: AppStyle.headLineStyle5,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(FluentSystemIcons.ic_fluent_phone_regular),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: AppStyle.headLineStyle4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.currentUser
                            ?.updateDisplayName(_nameController.text);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Profile updated successfully!")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Save",
                        style: AppStyle.headLineStyle4
                            .copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
