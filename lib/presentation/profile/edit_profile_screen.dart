import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _isLoading = false;
  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _addressController.text = user.address ?? '';
      _cityController.text = user.city ?? '';
      _stateController.text = user.state ?? '';
      _pincodeController.text = user.pincode ?? '';
      _selectedGender = user.gender;
      _selectedDate = user.dateOfBirth;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // If user is not authenticated, show login required screen
    if (authState.requiresLogin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: _buildLoginRequiredView(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSaveProfile,
            child: Text(
              'Save',
              style: context.bodyMedium.copyWith(
                color: _isLoading
                    ? context.textDisabledColor
                    : context.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(6.w(context)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfilePictureSection(context, authState.user),
                  SizedBox(height: 6.h(context)),
                  _buildPersonalInfoSection(context),
                  SizedBox(height: 4.h(context)),
                  _buildContactInfoSection(context),
                  SizedBox(height: 4.h(context)),
                  _buildAddressSection(context),
                  SizedBox(height: 8.h(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRequiredView(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: context.textMediumEmphasisColor,
            ),
            SizedBox(height: 4.h(context)),
            Text(
              'Login Required',
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h(context)),
            Text(
              'You need to be logged in to edit your profile.',
              style: context.bodyMedium.copyWith(
                color: context.textMediumEmphasisColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h(context)),
            ElevatedButton(
              onPressed: () => context.navigateToLogin(),
              child: const Text('Login Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context, user) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 30.w(context),
                height: 30.w(context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor,
                      context.primaryColor.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: user?.photoURL != null && user!.photoURL!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          user.photoURL!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar(context, user);
                          },
                        ),
                      )
                    : _buildDefaultAvatar(context, user),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _handleProfilePictureChange,
                  child: Container(
                    width: 10.w(context),
                    height: 10.w(context),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h(context)),
          Text(
            'Tap to change photo',
            style: context.bodySmall.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context, user) {
    return Center(
      child: Text(
        user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
        style: context.headlineLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 3.h(context)),

        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Name is required';
            }
            return null;
          },
        ),

        SizedBox(height: 3.h(context)),

        _buildGenderField(context),

        SizedBox(height: 3.h(context)),

        _buildDateOfBirthField(context),
      ],
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 3.h(context)),

        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Phone number is required';
            }
            if (value!.length < 10) {
              return 'Enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Information',
          style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 3.h(context)),

        _buildTextField(
          controller: _addressController,
          label: 'Address',
          hint: 'Enter your address',
          icon: Icons.home_outlined,
          maxLines: 2,
        ),

        SizedBox(height: 3.h(context)),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _cityController,
                label: 'City',
                hint: 'Enter city',
                icon: Icons.location_city_outlined,
              ),
            ),
            SizedBox(width: 4.w(context)),
            Expanded(
              child: _buildTextField(
                controller: _stateController,
                label: 'State',
                hint: 'Enter state',
                icon: Icons.map_outlined,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h(context)),

        _buildTextField(
          controller: _pincodeController,
          label: 'Pincode',
          hint: 'Enter pincode',
          icon: Icons.pin_drop_outlined,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isNotEmpty == true && value!.length != 6) {
              return 'Enter a valid 6-digit pincode';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.labelLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 1.h(context)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: context.textMediumEmphasisColor),
            filled: true,
            fillColor: context.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w(context)),
              borderSide: BorderSide(color: context.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w(context)),
              borderSide: BorderSide(color: context.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w(context)),
              borderSide: BorderSide(color: context.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w(context)),
              borderSide: BorderSide(color: context.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w(context)),
              borderSide: BorderSide(color: context.errorColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: context.labelLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 1.h(context)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.dividerColor),
            borderRadius: BorderRadius.circular(3.w(context)),
            color: context.surfaceColor,
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.wc_outlined,
                color: context.textMediumEmphasisColor,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 2.h(context),
                horizontal: 4.w(context),
              ),
            ),
            hint: Text('Select gender'),
            items: ['male', 'female', 'other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value.substring(0, 1).toUpperCase() + value.substring(1),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: context.labelLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 1.h(context)),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 2.h(context),
              horizontal: 4.w(context),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: context.dividerColor),
              borderRadius: BorderRadius.circular(3.w(context)),
              color: context.surfaceColor,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: context.textMediumEmphasisColor,
                ),
                SizedBox(width: 3.w(context)),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select date of birth',
                  style: context.bodyMedium.copyWith(
                    color: _selectedDate != null
                        ? context.textHighEmphasisColor
                        : context.textMediumEmphasisColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: context.textMediumEmphasisColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .updateProfile(
            displayName: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            city: _cityController.text.trim(),
            userState: _stateController.text.trim(),
            pincode: _pincodeController.text.trim(),
            dateOfBirth: _selectedDate,
          );

      if (mounted) {
        context.showSuccessSnackBar('Profile updated successfully!');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to update profile: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleProfilePictureChange() {
    context.showInfoSnackBar('Profile picture change coming soon!');
  }
}
