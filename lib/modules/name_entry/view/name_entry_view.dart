import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ============================================================================
// MODELS
// ============================================================================

/// Represents a participant in the lucky wheel game
class Participant {
  final String id;
  final String name;
  final Color color;
  final String imageUrl;
  final DateTime createdAt;

  Participant({
    String? id,
    required this.name,
    required this.color,
    required this.imageUrl,
  })  : id = id ?? _generateId(),
        createdAt = DateTime.now();

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Participant copyWith({
    String? name,
    Color? color,
    String? imageUrl,
  }) {
    return Participant(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Participant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// ============================================================================
// CONSTANTS
// ============================================================================

class AppConstants {
  // Validation
  static const int minParticipants = 2;
  static const int maxParticipants = 20;
  static const int maxNameLength = 30;

  // Session
  static const String defaultSessionId = 'ABC123';

  // Messages
  static const String errorMinParticipants = 'MINIMUM 2 NAMES REQUIRED';
  static const String errorMaxParticipants = 'MAXIMUM 20 PARTICIPANTS ALLOWED';
  static const String errorEmptyName = 'Name cannot be empty';
  static const String errorDuplicateName = 'Name already exists';
  static const String successNameAdded = 'Participant added!';
  static const String successNameRemoved = 'Participant removed';
  static const String successSessionCopied = 'Session ID Copied!';
}

class AppColors {
  static const List<Color> backgroundGradient = [
    Color(0xFF1a1a2e),
    Color(0xFF16213e),
    Color(0xFF0f3460),
  ];

  static const Color primaryButton = Color(0xFFE91E63);
  static const Color accentCyan = Color(0xFF4ECDC4);
  static final Color cardBackground = Colors.white.withOpacity(0.1);

  static final List<Color> avatarColors = [
    Color(0xFFFF6B6B), // Red
    Color(0xFFAA96DA), // Purple
    Color(0xFF4ECDC4), // Cyan
    Color(0xFFFFE66D), // Yellow
    Color(0xFFF38181), // Pink
    Color(0xFF95E1D3), // Mint
    Color(0xFFFF8E53), // Orange
    Color(0xFF6C5CE7), // Indigo
  ];
}

// ============================================================================
// NAME ENTRY VIEW
// ============================================================================

class NameEntryView extends StatefulWidget {
  const NameEntryView({super.key});

  @override
  State<NameEntryView> createState() => _NameEntryViewState();
}

class _NameEntryViewState extends State<NameEntryView>
    with SingleTickerProviderStateMixin {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  // State
  final List<Participant> _participants = [];
  String? _errorMessage;
  bool _isButtonPressed = false;

  // Session
  final String _sessionId = AppConstants.defaultSessionId;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  // ============================================================================
  // BUSINESS LOGIC
  // ============================================================================

  String? _validateName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return AppConstants.errorEmptyName;
    }

    if (trimmedName.length > AppConstants.maxNameLength) {
      return 'Name too long (max ${AppConstants.maxNameLength} characters)';
    }

    if (_participants.any((p) => p.name.toLowerCase() == trimmedName.toLowerCase())) {
      return AppConstants.errorDuplicateName;
    }

    if (_participants.length >= AppConstants.maxParticipants) {
      return AppConstants.errorMaxParticipants;
    }

    return null;
  }

  void _addParticipant(String name) {
    final validationError = _validateName(name);

    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      _showErrorSnackbar(validationError);
      return;
    }

    final trimmedName = name.trim();
    final participantColor =
    AppColors.avatarColors[_participants.length % AppColors.avatarColors.length];
    final imageUrl = 'https://i.pravatar.cc/150?img=${_participants.length + 1}';

    setState(() {
      _participants.add(
        Participant(
          name: trimmedName,
          color: participantColor,
          imageUrl: imageUrl,
        ),
      );
      _nameController.clear();
      _errorMessage = null;
    });

    _showSuccessSnackbar(AppConstants.successNameAdded);

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _removeParticipantAt(int index) {
    if (index < 0 || index >= _participants.length) return;

    setState(() {
      _participants.removeAt(index);
      if (_participants.length < AppConstants.minParticipants) {
        _errorMessage = AppConstants.errorMinParticipants;
      }
    });

    _showInfoSnackbar(AppConstants.successNameRemoved);
    HapticFeedback.mediumImpact();
  }

  void _navigateToSpinWheel() {
    if (_participants.length < AppConstants.minParticipants) {
      setState(() {
        _errorMessage = AppConstants.errorMinParticipants;
      });
      _showErrorSnackbar(AppConstants.errorMinParticipants);
      return;
    }

    // Unfocus keyboard before navigation
    _nameFocusNode.unfocus();

    // Heavy haptic feedback for important action
    HapticFeedback.heavyImpact();

    // Navigate with participants data
    Get.to(
          () => SpinWheelView(participants: List.from(_participants)),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _copySessionId() {
    Clipboard.setData(ClipboardData(text: _sessionId));
    _showSuccessSnackbar(AppConstants.successSessionCopied);
    HapticFeedback.selectionClick();
  }

  // ============================================================================
  // SNACKBAR HELPERS
  // ============================================================================

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.accentCyan.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInfoSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ============================================================================
  // BUILD METHODS
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            Positioned.fill(
              child: CustomPaint(
                painter: StarsPainter(),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          _buildTitle(),
                          const SizedBox(height: 20),
                          _buildNameInput(),
                          const SizedBox(height: 30),
                          _buildParticipantsSection(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // Bottom button
                  _buildBottomButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Logo/Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryButton.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.casino,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Lucky Wheel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          // Session ID
          _buildSessionIdChip(),
        ],
      ),
    );
  }

  Widget _buildSessionIdChip() {
    return GestureDetector(
      onTap: _copySessionId,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryButton.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryButton.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _sessionId,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.copy_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create Your Game',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add participants to start spinning!',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildNameInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLength: AppConstants.maxNameLength,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Enter participant name...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                counterText: '',
              ),
              onSubmitted: _addParticipant,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _addParticipant(_nameController.text),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: AppColors.accentCyan,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Participants',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accentCyan.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${_participants.length}/${AppConstants.maxParticipants}',
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _participants.isEmpty
            ? _buildEmptyState()
            : _buildParticipantsList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 60,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No participants yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add at least 2 participants to start',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsList() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _participants.length,
        itemBuilder: (context, index) {
          return _buildParticipantCard(_participants[index], index);
        },
      ),
    );
  }

  Widget _buildParticipantCard(Participant participant, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar container
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      participant.color,
                      participant.color.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: participant.color.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    participant.name.isNotEmpty
                        ? participant.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Delete button
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () => _removeParticipantAt(index),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 90,
            child: Text(
              participant.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final canSpin = _participants.length >= AppConstants.minParticipants;
    final remaining = AppConstants.minParticipants - _participants.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.backgroundGradient.last.withOpacity(0.95),
            AppColors.backgroundGradient.last,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error message
          if (_errorMessage != null && !canSpin)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    remaining > 0
                        ? 'Add $remaining more participant${remaining > 1 ? 's' : ''}'
                        : _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          // Main button
          GestureDetector(
            onTapDown: canSpin ? (_) => _buttonAnimationController.forward() : null,
            onTapUp: canSpin ? (_) => _buttonAnimationController.reverse() : null,
            onTapCancel: () => _buttonAnimationController.reverse(),
            onTap: canSpin ? _navigateToSpinWheel : null,
            child: ScaleTransition(
              scale: _buttonScaleAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: canSpin
                        ? [AppColors.primaryButton, const Color(0xFFC2185B)]
                        : [Colors.grey.shade700, Colors.grey.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: canSpin
                      ? [
                    BoxShadow(
                      color: AppColors.primaryButton.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      canSpin ? Icons.play_circle_filled : Icons.lock_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      canSpin ? 'START SPINNING' : 'ADD MORE PARTICIPANTS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CUSTOM PAINTERS
// ============================================================================

class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final random = Random(42);

    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2.5 + 0.5;

      paint.color = Colors.white.withOpacity(random.nextDouble() * 0.6 + 0.2);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// PLACEHOLDER SPIN WHEEL VIEW (Replace with your actual implementation)
// ============================================================================

class SpinWheelView extends StatelessWidget {
  final List<Participant> participants;

  const SpinWheelView({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin Wheel'),
        backgroundColor: AppColors.backgroundGradient.first,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Received Participants:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...participants.map((p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${p.name}',
                  style: TextStyle(
                    fontSize: 18,
                    color: p.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

