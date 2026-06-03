// File: lib/features/client/profile/client_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floreria_ajolote/core/providers/user_profile_provider.dart';
import 'package:floreria_ajolote/core/state/auth_state_notifier.dart';
import 'package:floreria_ajolote/core/providers/occasions_provider.dart';
import 'package:floreria_ajolote/core/widgets/occasion_form_dialog.dart';
import 'package:floreria_ajolote/core/models/occasion.dart';

class ClientProfileScreen extends ConsumerStatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  ConsumerState<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends ConsumerState<ClientProfileScreen> {
  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Cambiar Contraseña 🔒',
              style: TextStyle(color: Color(0xFF2D2040), fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPassCtrl,
                  obscureText: obscureOld,
                  decoration: InputDecoration(
                    labelText: 'Contraseña Actual',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFE87A9B)),
                    suffixIcon: IconButton(
                      icon: Icon(obscureOld ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFE87A9B)),
                      onPressed: () => setDialogState(() => obscureOld = !obscureOld),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Ingresa tu contraseña actual' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: newPassCtrl,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'Nueva Contraseña',
                    prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFFE87A9B)),
                    suffixIcon: IconButton(
                      icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFE87A9B)),
                      onPressed: () => setDialogState(() => obscureNew = !obscureNew),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa la nueva contraseña';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPassCtrl,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFFE87A9B)),
                    suffixIcon: IconButton(
                      icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFE87A9B)),
                      onPressed: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                    if (v != newPassCtrl.text) return 'Las contraseñas no coinciden';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: Color(0xFF5A4A66))),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ref.read(authStateNotifierProvider.notifier).changePassword(
                    oldPassCtrl.text,
                    newPassCtrl.text,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contraseña actualizada correctamente 🌸'),
                      backgroundColor: Color(0xFFE87A9B),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE87A9B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Cambiar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final occasionsAsync = ref.watch(occasionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0F5),
        elevation: 0,
        title: const Text(
          'Mi Perfil 🌸',
          style: TextStyle(
              color: Color(0xFFE87A9B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: userProfile.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No se encontró el perfil.'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header with gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD6E0), Color(0xFFFFF0F5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFE87A9B), width: 2.5),
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: const Color(0xFFFFD6E0),
                          backgroundImage: profile.photoURL != null
                              ? NetworkImage(profile.photoURL!)
                              : null,
                          child: profile.photoURL == null
                              ? Text(
                                  profile.displayName?.isNotEmpty == true
                                      ? profile.displayName![0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Color(0xFFE87A9B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.displayName ?? 'Usuario',
                        style: const TextStyle(
                          color: Color(0xFF5A4A66),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE87A9B).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '🌸 Cliente',
                          style: TextStyle(
                              color: Color(0xFFE87A9B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información Personal',
                        style: TextStyle(
                            color: Color(0xFF5A4A66),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                          icon: Icons.email_rounded,
                          label: 'Correo',
                          value: profile.email ?? 'No disponible'),
                      _InfoTile(
                          icon: Icons.phone_rounded,
                          label: 'Teléfono',
                          value: profile.phoneNumber ?? 'No registrado'),
                      const SizedBox(height: 24),

                      // Settings
                      const Text(
                        'Configuración',
                        style: TextStyle(
                            color: Color(0xFF5A4A66),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      _SettingsTile(
                        icon: Icons.lock_rounded,
                        label: 'Cambiar Contraseña',
                        onTap: () {
                          _showChangePasswordDialog(context, ref);
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.notifications_rounded,
                        label: 'Notificaciones',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Próximamente 🌸'),
                              backgroundColor: Color(0xFFE87A9B),
                            ),
                          );
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.location_on_rounded,
                        label: 'Mis Direcciones',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Próximamente 🌸'),
                              backgroundColor: Color(0xFFE87A9B),
                            ),
                          );
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.help_outline_rounded,
                        label: 'Ayuda y Soporte',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Próximamente 🌸'),
                              backgroundColor: Color(0xFFE87A9B),
                            ),
                          );
                        },
                      ),
                      // Occasions Section
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mis Ocasiones Especiales 📅',
                            style: TextStyle(
                                color: Color(0xFF5A4A66),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded,
                                color: Color(0xFFE87A9B)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => OccasionFormDialog(
                                  onSave: (newOccasion) {
                                    ref
                                        .read(occasionNotifierProvider.notifier)
                                        .addOccasion(newOccasion);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      occasionsAsync.when(
                        data: (occasions) {
                          if (occasions.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'No tienes ocasiones registradas.\n¡Agrega fechas especiales para recordarte! 🌸',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF5A4A66), fontSize: 13),
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: occasions.length,
                            itemBuilder: (context, index) {
                              final occasion = occasions[index];
                              return _OccasionItem(
                                occasion: occasion,
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => OccasionFormDialog(
                                      occasion: occasion,
                                      onSave: (updatedOccasion) {
                                        ref
                                            .read(occasionNotifierProvider.notifier)
                                            .updateOccasion(updatedOccasion);
                                      },
                                    ),
                                  );
                                },
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('¿Eliminar ocasión?'),
                                      content: Text('¿Seguro que deseas eliminar "${occasion.name}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm ?? false) {
                                    ref
                                        .read(occasionNotifierProvider.notifier)
                                        .deleteOccasion(occasion.id);
                                  }
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                            child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        )),
                        error: (err, stack) => Center(
                            child: Text('Error: $err',
                                style: const TextStyle(color: Colors.red))),
                      ),
                      const SizedBox(height: 28),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref
                                .read(authStateNotifierProvider.notifier)
                                .signOut();
                          },
                          icon: const Icon(Icons.logout_rounded,
                              color: Color(0xFFE87A9B)),
                          label: const Text('Cerrar Sesión',
                              style: TextStyle(
                                  color: Color(0xFFE87A9B), fontSize: 15)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE87A9B)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFE87A9B)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF5A4A66), fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      color: Color(0xFF5A4A66),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFFE87A9B)),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF5A4A66),
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: Color(0xFFE87A9B)),
          ],
        ),
      ),
    );
  }
}

class _OccasionItem extends StatelessWidget {
  final Occasion occasion;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OccasionItem({
    required this.occasion,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Image / Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (occasion.imageUrl.isNotEmpty)
                ? Image.network(
                    occasion.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackIcon(),
                  )
                : _fallbackIcon(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  occasion.name,
                  style: const TextStyle(
                      color: Color(0xFF5A4A66),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  occasion.description,
                  style: const TextStyle(
                      color: Color(0xFF5A4A66), fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded,
                color: Color(0xFF5A4A66), size: 18),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded,
                color: Color(0xFFFFAAAA), size: 18),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon() {
    return Container(
      width: 50,
      height: 50,
      color: const Color(0xFFFFD6E0),
      child: const Icon(Icons.event_note_rounded,
          color: Color(0xFFE87A9B), size: 24),
    );
  }
}

