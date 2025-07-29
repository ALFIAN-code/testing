import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/preference_constants.dart';
import '../../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../../../core/utils/app/app_status.dart';
import '../../../../core/utils/formz.dart';
import '../../../../data/models/role/role_model.dart';
import '../../../../dependency_injection.dart';
import '../button/basic_button.dart';

class PickRoleDialog extends StatefulWidget {
  final void Function(FormzSubmissionStatus action)? onResult;

  const PickRoleDialog({super.key, this.onResult});

  @override
  State<PickRoleDialog> createState() => _PickRoleDialogState();
}

class _PickRoleDialogState extends State<PickRoleDialog> {
  final SecureStorageService _secureStorageService = serviceLocator.get();
  List<RoleModel> _roles = [];
  String? _selectedRole;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final String? currentRole = await _secureStorageService.get(PreferenceConstants.roleCode);
      _selectedRole = currentRole;

      final String? data = await _secureStorageService.get(PreferenceConstants.roleList);
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data) as List<dynamic>;
        _roles = decoded.map((e) => RoleModel.fromJson(e as Map<String, dynamic>)).toList();

        if (_roles.length == 1) {
          _selectedRole = _roles.first.code;
        }
      }
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onSave() async {
    if (_selectedRole != null) {
      try {
        await _secureStorageService.set(PreferenceConstants.roleCode, _selectedRole!);
        if (context.mounted) {
          widget.onResult?.call(FormzSubmissionStatus.success);
        }
      } catch (e) {
        widget.onResult?.call(FormzSubmissionStatus.failure);
      }
    } else {
      widget.onResult?.call(FormzSubmissionStatus.failure);
    }
  }

  void _onCancel() {
    widget.onResult?.call(FormzSubmissionStatus.canceled);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Colors.white,
    title: const Text(
      'Pilih Peran Anda',
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    content: SizedBox(
      height: 400,
      width: 300,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _roles.isEmpty
          ? const Center(child: Text('Tidak ada peran tersedia'))
          : ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (BuildContext context, int index) {
          final RoleModel role = _roles[index];
          final bool isSelected = _selectedRole == role.code;
          return ListTile(
            title: Text(
              role.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            leading: Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            selected: isSelected,
            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
            onTap: () {
              setState(() {
                _selectedRole = role.code;
              });
            },
          );
        },
      ),
    ),
    actions: [
      BasicButton(
        onClick: _onCancel,
        text: 'Batal',
        variant: ButtonVariant.outlined,
      ),
      BasicButton(
        onClick: _onSave,
        text: 'Simpan',
      ),
    ],
  );
}
