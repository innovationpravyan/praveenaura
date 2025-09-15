// edit_profile_screen.dart
import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.requiresLogin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline,
                size: 80,
                color: AppColors.grey400,
              ),
              const SizedBox(height: 16),
              const Text('Login Required'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.navigateToLogin(),
                child: const Text('Login Now'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: const Center(child: Text('Edit Profile Screen\n(Coming Soon)')),
    );
  }
}
