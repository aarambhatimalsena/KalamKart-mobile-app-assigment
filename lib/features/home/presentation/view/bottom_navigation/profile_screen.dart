import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// User Profile Model
class UserProfile {
  String name;
  String email;
  String phone;
  String address;
  String bio;
  String? profileImagePath;

  UserProfile({
    required this.name,
    required this.email,
    this.phone = '',
    this.address = '',
    this.bio = '',
    this.profileImagePath,
  });
}

// Profile Menu Item Widget
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool showArrow;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B3E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? Colors.amber).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? Colors.amber, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto_Condensed-Bold',
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'Roboto_Condensed-Regular',
                  ),
                )
                : null,
        trailing:
            showArrow
                ? const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 16,
                )
                : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
  
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final _dio = Dio();

  File? _selectedImage;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;

  String? _profileImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(text: widget.userProfile.phone);
    _addressController = TextEditingController(
      text: widget.userProfile.address,
    );
    _bioController = TextEditingController(text: widget.userProfile.bio);
    _profileImagePath = widget.userProfile.profileImagePath;


  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Simulate image picker
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _profileImagePath = '/placeholder.svg?height=100&width=100';
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture updated!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _profileImagePath = image.path; // Show local image immediately
      });

      // Upload to Cloudinary
      final uploadedUrl = await _uploadImageToCloudinary(_selectedImage!);
      if (uploadedUrl != null) {
        setState(() {
          _profileImagePath = uploadedUrl;
        });

        // Save to secure storage
        await secureStorage.write(key: 'profile_image', value: uploadedUrl);

        // Send to backend
        final token = await secureStorage.read(key: 'auth_token');
        if (token != null) {
          try {
            await _dio.put(
              'http://192.168.100.66:5000/api/users/profile',
              data: {'profileImage': uploadedUrl},
              options: Options(headers: {'Authorization': 'Bearer $token'}),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile image updated!')),
            );
          } catch (e) {
            print('Failed to update profile image: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update profile image')),
            );
          }
        }
      }
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    const cloudName = 'dgccsdcs5';
    const uploadPreset = 'kalamkart';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final responseData = json.decode(res.body);
      return responseData['secure_url'];
    } else {
      print('Cloudinary upload failed: ${res.body}');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token == null) return;

    Map<String, dynamic> updatePayload = {};

    if (_nameController.text != widget.userProfile.name) {
      updatePayload['name'] = _nameController.text;
    }

    updatePayload['role'] =
        'user'; // Default to 'user', or implement your own logic if needed

    if (_selectedImage != null) {
      final imageUrl = await _uploadImageToCloudinary(_selectedImage!);
      if (imageUrl != null) {
        updatePayload['profileImage'] = imageUrl;
      }
    }

    try {
      final response = await _dio.put(
        'http://192.168.100.66:5000/api/users/profile',
        data: updatePayload,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated!')));
        Navigator.pop(context);
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Roboto_Condensed-Bold',
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isLoading ? Colors.white54 : Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        _profileImagePath != null
                            ? (_profileImagePath!.startsWith('http')
                                ? NetworkImage(_profileImagePath!)
                                : FileImage(File(_profileImagePath!))
                                    as ImageProvider)
                            : null,
                    child:
                        _profileImagePath == null
                            ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.amber,
                            )
                            : null,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.amber,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildTextField('Full Name', _nameController, Icons.person),
            const SizedBox(height: 16),
            _buildTextField(
              'Email',
              _emailController,
              Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _isLoading
                      ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Saving...',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                      : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto_Condensed-Bold',
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.amber),
        filled: true,
        fillColor: const Color(0xFF1A2B3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Email' && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}

// Account Info Screen
class AccountInfoScreen extends StatelessWidget {
  final UserProfile userProfile;

  const AccountInfoScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Roboto_Condensed-Bold',
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInfoCard('Personal Information', [
            _buildInfoRow('Name', userProfile.name),
            _buildInfoRow('Email', userProfile.email),
            _buildInfoRow(
              'Phone',
              userProfile.phone.isEmpty ? 'Not provided' : userProfile.phone,
            ),
            _buildInfoRow(
              'Address',
              userProfile.address.isEmpty
                  ? 'Not provided'
                  : userProfile.address,
            ),
          ]),
          const SizedBox(height: 20),
          _buildInfoCard('Account Details', [
            _buildInfoRow('Account Type', 'Premium Customer'),
            _buildInfoRow('Member Since', 'January 2024'),
            _buildInfoRow('Last Login', 'Today, 2:30 PM'),
            _buildInfoRow('Account Status', 'Active'),
          ]),
          const SizedBox(height: 20),
          _buildInfoCard('Shopping Statistics', [
            _buildInfoRow('Total Orders', '15'),
            _buildInfoRow('Favorite Items', '12'),
            _buildInfoRow('Total Spent', '\$1,245.50'),
            _buildInfoRow('Loyalty Points', '2,450'),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B3E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto_Condensed-Bold',
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Roboto_Condensed-Regular',
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto_Condensed-Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Generic Info Screen for About Us, Privacy Policy, Terms
class InfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const InfoScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Roboto_Condensed-Bold',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2B3E),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.6,
              fontFamily: 'Roboto_Condensed-Regular',
            ),
          ),
        ),
      ),
    );
  }
}

// Main Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // ✅ Fetch user data
  }

  Future<void> _loadUserProfile() async {
    const secureStorage = FlutterSecureStorage();

    String? name = await secureStorage.read(key: 'user_name');
    String? email = await secureStorage.read(key: 'user_email');
    String? profileImage = await secureStorage.read(key: 'profile_image');


    setState(() {
      userProfile = UserProfile(
        name: name ?? 'Unknown User',
        email: email ?? 'unknown@email.com',
        phone: '', // optional
        address: '',
        bio: '',
        profileImagePath: profileImage,
      );
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A2B3E),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () async {
                // 1. Close the drawer safely
                Navigator.of(context).pop();

                // 2. Delete all secure storage
                const FlutterSecureStorage secureStorage =
                    FlutterSecureStorage();
                await secureStorage.deleteAll();

                // 3. Debug output to verify everything is removed
                final remainingData = await secureStorage.readAll();
                debugPrint("✅ Secure Storage after logout: $remainingData");

                // 4. Navigate to login screen using named route
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login', // ✅ Make sure this matches your MaterialApp route
                  (route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Icon(Icons.person, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Roboto_Condensed-Bold',
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2B3E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      userProfile.profileImagePath != null
                          ? NetworkImage(userProfile.profileImagePath!)
                          : null,
                  child:
                      userProfile.profileImagePath == null
                          ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.amber,
                          )
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userProfile.name ?? 'Unknown User',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto_Condensed-Bold',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userProfile.email ?? 'Unknown Email',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'Roboto_Condensed-Regular',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.black),
                  label: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Roboto_Condensed-Bold',
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                EditProfileScreen(userProfile: userProfile),
                      ),
                    );
                    if (result != null) {
                      _loadUserProfile();
                      setState(() {
                        userProfile = result;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu Items
          ProfileMenuItem(
            icon: Icons.account_circle,
            title: 'Account Information',
            subtitle: 'View your account details and statistics',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AccountInfoScreen(userProfile: userProfile),
                ),
              );
            },
          ),

          ProfileMenuItem(
            icon: Icons.store,
            title: 'About Us',
            subtitle: 'Learn about KalamKart Stationery',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const InfoScreen(
                        title: 'About Us',
                        content: '''Welcome to KalamKart Stationery!

🎯 Your One-Stop Stationery Destination

At KalamKart Stationery, we believe that the right tools can inspire creativity, boost productivity, and make everyday tasks more enjoyable. Since our founding in 2020, we've been dedicated to providing high-quality stationery and office supplies to students, professionals, artists, and stationery enthusiasts worldwide.

📚 Our Story

What started as a small passion project by two college friends who couldn't find quality, affordable stationery has grown into a trusted online destination for thousands of customers. We understand the joy of writing with a perfect pen, the satisfaction of organizing with beautiful planners, and the inspiration that comes from quality art supplies.

🎨 Our Product Range

• Premium Pens & Pencils - From everyday ballpoints to luxury fountain pens
• Notebooks & Journals - Dotted, lined, blank, and specialty papers
• Art Supplies - Markers, colored pencils, paints, and drawing tools
• Office Essentials - Staplers, paper clips, folders, and organizers
• Planning & Organization - Planners, calendars, sticky notes, and washi tape
• School Supplies - Everything students need for academic success
• Specialty Items - Unique stationery finds from around the world

🌟 Our Mission

To make quality stationery accessible to everyone while fostering creativity and organization in daily life. We carefully curate our products to ensure they meet our high standards for quality, functionality, and design.

💝 Why Choose KalamKart?

• Quality Guaranteed - We test every product before adding it to our catalog
• Fast Shipping - Most orders ship within 24 hours
• Customer First - Our support team is here to help with any questions
• Eco-Friendly Options - Sustainable and recycled products available
• Competitive Prices - Great value without compromising quality
• Expert Curation - Products chosen by stationery enthusiasts

🏆 Our Achievements

• Over 50,000 happy customers served
• 4.8/5 average customer rating
• Featured in "Best Stationery Stores 2024" by Office Weekly
• Carbon-neutral shipping since 2023
• Partnership with local schools for supply donations

🤝 Community & Values

We're more than just a store - we're a community of people who appreciate the power of good stationery. We regularly feature customer creations, provide organization tips, and support educational initiatives in our local community.

Our core values:
• Quality over quantity
• Customer satisfaction
• Environmental responsibility
• Supporting creativity and education
• Fair and ethical business practices

📞 Connect With Us

Follow us on social media for daily inspiration, new product announcements, and stationery tips. Join our newsletter for exclusive deals and early access to new collections.

Thank you for choosing KalamKart Stationery. Here's to making every day a little more organized and a lot more creative! ✨

- The KalamKart Team''',
                      ),
                ),
              );
            },
          ),

          ProfileMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we protect your personal information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const InfoScreen(
                        title: 'Privacy Policy',
                        content: '''KalamKart Stationery Privacy Policy

Last updated: January 2024

At KalamKart Stationery, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our mobile application and services.

1. INFORMATION WE COLLECT

Personal Information:
• Name, email address, and phone number
• Shipping and billing addresses
• Payment information (processed securely through third-party providers)
• Account preferences and profile information

Shopping Information:
• Purchase history and order details
• Product preferences and wishlist items
• Shopping cart contents
• Product reviews and ratings

Technical Information:
• Device information (model, operating system, app version)
• IP address and location data (with permission)
• App usage analytics and performance data
• Cookies and similar tracking technologies

2. HOW WE USE YOUR INFORMATION

We use your information to:
• Process and fulfill your orders
• Provide customer support and respond to inquiries
• Send order confirmations and shipping updates
• Personalize your shopping experience
• Recommend products based on your preferences
• Send promotional emails (with your consent)
• Improve our app and services
• Prevent fraud and ensure security
• Comply with legal obligations

3. INFORMATION SHARING

We do not sell your personal information. We may share your data with:

Service Providers:
• Payment processors (Stripe, PayPal)
• Shipping companies (FedEx, UPS, USPS)
• Email service providers
• Analytics services (Google Analytics)
• Customer support platforms

Legal Requirements:
• When required by law or legal process
• To protect our rights and prevent fraud
• In case of business merger or acquisition

4. DATA SECURITY

We implement industry-standard security measures:
• SSL encryption for all data transmission
• Secure payment processing (PCI DSS compliant)
• Regular security audits and updates
• Limited access to personal information
• Secure data storage with backup systems

5. YOUR RIGHTS AND CHOICES

You have the right to:
• Access your personal information
• Update or correct your data
• Delete your account and data
• Opt-out of marketing communications
• Request data portability
• Withdraw consent for data processing

To exercise these rights, contact us at privacy@KalamKartstationery.com

6. COOKIES AND TRACKING

We use cookies to:
• Remember your login status
• Keep items in your shopping cart
• Personalize your experience
• Analyze app usage and performance

You can manage cookie preferences in your device settings.

7. THIRD-PARTY SERVICES

Our app may contain links to third-party websites or services. We are not responsible for their privacy practices. Please review their privacy policies before providing any information.

8. CHILDREN'S PRIVACY

Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13. If we become aware of such collection, we will delete the information immediately.

9. INTERNATIONAL DATA TRANSFERS

Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data during such transfers.

10. DATA RETENTION

We retain your information for as long as necessary to:
• Provide our services
• Comply with legal obligations
• Resolve disputes
• Enforce our agreements

Account information is retained until you request deletion or close your account.

11. CHANGES TO THIS POLICY

We may update this Privacy Policy periodically. We will notify you of significant changes through:
• Email notifications
• In-app notifications
• Updates to this page

Continued use of our services after changes constitutes acceptance of the updated policy.

12. CONTACT US

For privacy-related questions or concerns:

Email: privacy@KalamKartstationery.com
Phone: +1 (555) 123-PAPER
Address: KalamKart Stationery, 123 Creative Lane, Art City, AC 12345

Data Protection Officer: privacy-officer@KalamKartstationery.com

Your privacy is important to us. We are committed to maintaining the trust you place in us by handling your information responsibly and transparently.''',
                      ),
                ),
              );
            },
          ),

          ProfileMenuItem(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Terms of service for using our app',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const InfoScreen(
                        title: 'Terms & Conditions',
                        content: '''KalamKart Stationery Terms & Conditions

Last updated: January 2024

Welcome to KalamKart Stationery! These Terms and Conditions ("Terms") govern your use of our mobile application and services. By accessing or using our app, you agree to be bound by these Terms.

1. ACCEPTANCE OF TERMS

By creating an account or making a purchase through our app, you acknowledge that you have read, understood, and agree to these Terms and our Privacy Policy. If you do not agree, please discontinue use of our services.

2. ACCOUNT REGISTRATION

To use certain features, you must create an account by providing:
• Accurate and complete information
• A valid email address
• A secure password

You are responsible for:
• Maintaining the confidentiality of your account
• All activities that occur under your account
• Notifying us of any unauthorized use

3. PRODUCT INFORMATION AND AVAILABILITY

We strive to provide accurate product descriptions, images, and pricing. However:
• Product colors may vary due to display settings
• We reserve the right to correct errors in pricing or descriptions
• Product availability is subject to change without notice
• We may discontinue products at any time

4. ORDERING AND PAYMENT

Order Process:
• Orders are subject to acceptance and availability
• We reserve the right to refuse or cancel orders
• Order confirmation does not guarantee product availability

Payment Terms:
• Payment is required at time of order
• We accept major credit cards and digital payment methods
• All prices are in USD unless otherwise specified
• Prices include applicable taxes where required

5. SHIPPING AND DELIVERY

Shipping Policies:
• We ship to addresses within the United States and select international locations
• Shipping costs are calculated at checkout
• Delivery times are estimates and not guaranteed
• Risk of loss transfers to you upon delivery

International Shipping:
• Additional customs fees may apply
• Delivery times may be longer
• Some products may not be available for international shipping

6. RETURNS AND EXCHANGES

Return Policy:
• Items may be returned within 30 days of delivery
• Items must be in original condition and packaging
• Return shipping costs are the customer's responsibility (unless item is defective)
• Refunds will be processed within 5-7 business days

Non-Returnable Items:
• Personalized or custom products
• Items marked as final sale
• Products damaged by misuse

7. INTELLECTUAL PROPERTY

Our Content:
• All app content, including text, images, logos, and designs, is owned by KalamKart Stationery
• You may not reproduce, distribute, or create derivative works without permission

Your Content:
• You retain ownership of content you submit (reviews, photos, etc.)
• You grant us a license to use your content for promotional purposes
• You are responsible for ensuring your content doesn't infringe on others' rights

8. PROHIBITED USES

You may not use our app to:
• Violate any laws or regulations
• Infringe on intellectual property rights
• Transmit harmful or malicious code
• Attempt to gain unauthorized access to our systems
• Use automated systems to access our services
• Resell products for commercial purposes without authorization

9. USER REVIEWS AND CONTENT

Guidelines for Reviews:
• Reviews should be honest and based on personal experience
• No offensive, discriminatory, or inappropriate language
• No promotional content or spam
• We reserve the right to remove reviews that violate these guidelines

10. LIMITATION OF LIABILITY

To the fullest extent permitted by law:
• Our liability is limited to the amount you paid for the product
• We are not liable for indirect, incidental, or consequential damages
• We do not warrant that our service will be uninterrupted or error-free

11. INDEMNIFICATION

You agree to indemnify and hold harmless KalamKart Stationery from any claims, damages, or expenses arising from:
• Your use of our services
• Your violation of these Terms
• Your violation of any third-party rights

12. DISPUTE RESOLUTION

Governing Law:
• These Terms are governed by the laws of [State/Country]
• Any disputes will be resolved in the courts of [Jurisdiction]

Arbitration:
• For disputes under Npr 10,000, we encourage resolution through binding arbitration
• Class action lawsuits are waived

13. MODIFICATIONS TO TERMS

We may update these Terms periodically. Changes will be effective upon posting. Continued use of our services constitutes acceptance of modified Terms.

14. TERMINATION

We may terminate or suspend your account if you:
• Violate these Terms
• Engage in fraudulent activity
• Abuse our return policy
• Use our services inappropriately

15. FORCE MAJEURE

We are not liable for delays or failures due to circumstances beyond our control, including natural disasters, government actions, or supply chain disruptions.

16. SEVERABILITY

If any provision of these Terms is found unenforceable, the remaining provisions will continue in full force and effect.

17. CONTACT INFORMATION

For questions about these Terms:

KalamKart Stationery
Email: legal@KalamKartstationery.com
Phone: +1 (555) 123-PAPER
Address: 123 Creative Lane, Art City, AC 12345

Customer Service Hours:
Monday - Friday: 9:00 AM - 6:00 PM EST
Saturday: 10:00 AM - 4:00 PM EST
Sunday: Closed

Thank you for choosing KalamKart Stationery. We appreciate your business and look forward to serving your stationery needs!''',
                      ),
                ),
              );
            },
          ),

          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help with orders and products',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const InfoScreen(
                        title: 'Help & Support',
                        content: '''KalamKart Stationery Help & Support

We're here to help make your stationery shopping experience amazing! Find answers to common questions below or contact our friendly support team.

📋 FREQUENTLY ASKED QUESTIONS

🛒 ORDERING & ACCOUNT
Q: How do I create an account?
A: Tap "Sign Up" on the login screen, enter your email and create a password. Verify your email to activate your account.

Q: Can I modify my order after placing it?
A: Orders can be modified within 1 hour of placement. Contact us immediately at orders@KalamKartstationery.com.

Q: How do I track my order?
A: Go to "My Orders" in your profile. You'll receive tracking information via email once your order ships.

Q: Can I save items for later?
A: Yes! Use the heart icon to add items to your favorites, or save them in your cart for up to 30 days.

📦 SHIPPING & DELIVERY
Q: What are your shipping options?
A: We offer Standard (5-7 days), Express (2-3 days), and Overnight shipping. International shipping available to select countries.

Q: Do you offer free shipping?
A: Yes! Free standard shipping on orders over \$35 within the US.

Q: What if my package is damaged or lost?
A: Contact us within 48 hours of delivery. We'll replace damaged items or investigate lost packages with the carrier.

Q: Do you ship internationally?
A: Yes, we ship to Canada, UK, Australia, and select European countries. Additional customs fees may apply.

💳 PAYMENT & PRICING
Q: What payment methods do you accept?
A: We accept Visa, MasterCard, American Express, Discover, PayPal, Apple Pay, and Google Pay.

Q: Are prices shown in my local currency?
A: Prices are displayed in USD. International customers will see converted amounts at checkout.

Q: Do you offer student discounts?
A: Yes! Students get 15% off with valid student ID verification through our student portal.

🔄 RETURNS & EXCHANGES
Q: What is your return policy?
A: Items can be returned within 30 days in original condition. Return shipping is free for defective items.

Q: How do I return an item?
A: Go to "My Orders," select the item, and click "Return Item." Print the prepaid label and drop off at any shipping location.

Q: When will I receive my refund?
A: Refunds are processed within 5-7 business days after we receive your return.

📝 PRODUCT QUESTIONS
Q: Are your notebooks fountain pen friendly?
A: Yes! Look for the "Fountain Pen Friendly" badge on product pages. We test all paper with various ink types.

Q: Do you offer bulk discounts?
A: Yes! Contact our business sales team at bulk@KalamKartstationery.com for orders over 50 units.

Q: Can I request specific products?
A: Send product requests to suggestions@KalamKartstationery.com. We review all suggestions monthly.

🎨 PRODUCT CARE TIPS
• Store pens horizontally to prevent ink settling
• Keep paper products in dry, cool places
• Clean erasers with a kneaded eraser for best performance
• Store markers cap-down to maintain ink flow

📞 CONTACT OUR SUPPORT TEAM

📧 Email Support:
• General Questions: support@KalamKartstationery.com
• Order Issues: orders@KalamKartstationery.com
• Returns: returns@KalamKartstationery.com
• Technical Issues: tech@KalamKartstationery.com

📱 Phone Support:
+1 (555) 123-PAPER (72737)

Business Hours:
• Monday - Friday: 8:00 AM - 8:00 PM EST
• Saturday: 9:00 AM - 6:00 PM EST
• Sunday: 10:00 AM - 4:00 PM EST

💬 Live Chat:
Available in the app during business hours. Look for the chat bubble in the bottom right corner.

📱 Social Media:
• Instagram: @KalamKartstationery
• Facebook: KalamKart Stationery
• Twitter: @KalamKart_shop
• TikTok: @KalamKartstationary

🏪 Visit Our Showroom:
KalamKart Stationery Flagship Store
123 Creative Lane, Art City, AC 12345
Open Monday-Saturday 10 AM - 7 PM

⚡ QUICK SOLUTIONS

Order Status: Check "My Orders" in your profile
Change Address: Contact us within 1 hour of ordering
Cancel Order: Use "Cancel Order" button in "My Orders"
Report Problem: Use "Report Issue" in order details
Update Payment: Go to "Payment Methods" in settings

🎁 ADDITIONAL SERVICES

• Gift Wrapping: Available for \$3.99 per item
• Personal Shopping: Schedule a consultation with our stationery experts
• Corporate Accounts: Special pricing for businesses and schools
• Subscription Boxes: Monthly curated stationery delivered to your door

💡 TIPS FOR BEST EXPERIENCE

• Enable push notifications for order updates
• Add items to favorites for easy reordering
• Check our blog for organization tips and product spotlights
• Join our loyalty program for exclusive discounts
• Follow us on social media for daily inspiration

Still need help? Our team is standing by to assist you! We typically respond to emails within 2 hours during business hours.

Happy Shopping! 📝✨
The KalamKart Team''',
                      ),
                ),
              );
            },
          ),

          ProfileMenuItem(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'App preferences and notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings screen coming soon!'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Logout Button
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            iconColor: Colors.red,
            onTap: _logout,
            showArrow: false,
          ),

          const SizedBox(height: 20),

          // App Version
          Center(
            child: Text(
              'KalamKart Stationery v1.0.0',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontFamily: 'Roboto_Condensed-Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
