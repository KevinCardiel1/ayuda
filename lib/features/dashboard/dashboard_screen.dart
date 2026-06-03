
import 'package:flutter/material.dart';
import 'package:floreria_ajolote/features/admin/dashboard/admin_dashboard_screen.dart';
import 'package:floreria_ajolote/features/client/dashboard/client_dashboard_screen.dart';
import 'package:floreria_ajolote/core/models/user_profile.dart';

class DashboardScreen extends StatelessWidget {
  final UserProfile userProfile;
  const DashboardScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    // Use the user's role to decide which dashboard to show
    switch (userProfile.role) {
      case UserRole.admin:
        return AdminDashboardScreen(userProfile: userProfile);
      case UserRole.client:
        return ClientDashboardScreen(userProfile: userProfile);
      case UserRole.employee: // Or some other specific screen
        return AdminDashboardScreen(userProfile: userProfile); // Example: Employees might use admin view
    }
  }
}
