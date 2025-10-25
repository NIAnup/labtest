import 'package:flutter/material.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/responsive/responsive_layout.dart';

class PendingScreen extends StatefulWidget {
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Map<String, dynamic>> pendingRequests = [
    {
      'name': 'Sarah Wilson',
      'phone': '123-456-7890',
      'email': 'sarahw@example.com',
      'profilePic':
          'https://media.istockphoto.com/id/1392528328/photo/portrait-of-smiling-handsome-man-in-white-t-shirt-standing-with-crossed-arms.jpg?s=612x612&w=0&k=20&c=6vUtfKvHhNsK9kdNWb7EJlksBDhBBok1bNjNRULsAYs=',
      'status': 'Pending',
      'requestDate': '2024-01-15',
      'service': 'Blood Test',
      'location': 'Downtown Medical Center',
      'urgency': 'Normal',
      'estimatedTime': '2-3 hours'
    },
    {
      'name': 'Michael Brown',
      'phone': '987-654-3210',
      'email': 'michaelb@example.com',
      'profilePic':
          'https://media.istockphoto.com/id/1392528328/photo/portrait-of-smiling-handsome-man-in-white-t-shirt-standing-with-crossed-arms.jpg?s=612x612&w=0&k=20&c=6vUtfKvHhNsK9kdNWb7EJlksBDhBBok1bNjNRULsAYs=',
      'status': 'Pending',
      'requestDate': '2024-01-15',
      'service': 'X-Ray',
      'location': 'City Hospital',
      'urgency': 'High',
      'estimatedTime': '1-2 hours'
    },
    {
      'name': 'Emily Davis',
      'phone': '555-123-4567',
      'email': 'emilyd@example.com',
      'profilePic':
          'https://media.istockphoto.com/id/1392528328/photo/portrait-of-smiling-handsome-man-in-white-t-shirt-standing-with-crossed-arms.jpg?s=612x612&w=0&k=20&c=6vUtfKvHhNsK9kdNWb7EJlksBDhBBok1bNjNRULsAYs=',
      'status': 'Pending',
      'requestDate': '2024-01-14',
      'service': 'Lab Test',
      'location': 'Medical Plaza',
      'urgency': 'Low',
      'estimatedTime': '3-4 hours'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showDetailsDialog(Map<String, dynamic> request) {
    final theme = AppTheme();
    final colors = theme.colors;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isMobile(context) ? 350 : 500,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Request Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        fontFamily: "uber",
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: colors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Profile section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(request['profilePic']),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.warning,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        request['name'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontFamily: "uber",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.warning,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          request['status'],
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontFamily: "uber",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Details section
                _buildDetailRow(Icons.phone, "Phone", request['phone'], colors),
                _buildDetailRow(Icons.email, "Email", request['email'], colors),
                _buildDetailRow(Icons.medical_services, "Service",
                    request['service'], colors),
                _buildDetailRow(
                    Icons.location_on, "Location", request['location'], colors),
                _buildDetailRow(Icons.calendar_today, "Request Date",
                    request['requestDate'], colors),
                _buildDetailRow(Icons.schedule, "Estimated Time",
                    request['estimatedTime'], colors),
                _buildDetailRow(
                    Icons.priority_high, "Urgency", request['urgency'], colors),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontFamily: "uber",
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontFamily: "uber",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showCancelDialog(int index) {
    final theme = AppTheme();
    final colors = theme.colors;
    TextEditingController rejectReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isMobile(context) ? 350 : 450,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cancel_rounded,
                    color: colors.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "Cancel Request",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontFamily: "uber",
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  "Please provide a reason for canceling this request.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.textSecondary,
                    fontFamily: "uber",
                  ),
                ),
                const SizedBox(height: 20),

                // Reason input
                TextField(
                  controller: rejectReasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Reason for cancellation",
                    hintText: "Enter reason for canceling this request...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: colors.border),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontFamily: "uber",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            pendingRequests.removeAt(index);
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Request canceled",
                                style: TextStyle(fontFamily: "uber"),
                              ),
                              backgroundColor: colors.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.error,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel Request",
                          style: TextStyle(
                            color: colors.onError,
                            fontFamily: "uber",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    final colors = theme.colors;
    final isMobile = ResponsiveHelper.isMobile(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.background,
                colors.background.withOpacity(0.95),
              ],
            ),
          ),
          child: Column(
            children: [
              // Header section
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.pending_actions_rounded,
                            color: colors.warning,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pending Requests",
                                style: TextStyle(
                                  fontSize: isMobile ? 24 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                  fontFamily: "uber",
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${pendingRequests.length} pending requests",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors.textSecondary,
                                  fontFamily: "uber",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content section
              Expanded(
                child: pendingRequests.isEmpty
                    ? _buildEmptyState(colors)
                    : ResponsiveLayout(
                        mobile: _buildMobileList(colors),
                        tablet: _buildTabletList(colors),
                        desktop: _buildDesktopList(colors),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colors.warning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pending_actions_rounded,
              size: 64,
              color: colors.warning,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Pending Requests",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: "uber",
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "New requests will appear here",
            style: TextStyle(
              fontSize: 16,
              color: colors.textSecondary,
              fontFamily: "uber",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(AppColors colors) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(pendingRequests[index], index, colors, true);
      },
    );
  }

  Widget _buildTabletList(AppColors colors) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(pendingRequests[index], index, colors, false);
      },
    );
  }

  Widget _buildDesktopList(AppColors colors) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(pendingRequests[index], index, colors, false);
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, int index,
      AppColors colors, bool isMobile) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.only(
                bottom: isMobile ? 16 : 0,
                top: index * 10.0 * (1 - _fadeAnimation.value),
              ),
              child: Card(
                elevation: 8,
                shadowColor: colors.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.surface,
                        colors.surface.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with profile and status
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.warning,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: isMobile ? 25 : 30,
                                backgroundImage:
                                    NetworkImage(request['profilePic']),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request['name'],
                                    style: TextStyle(
                                      fontSize: isMobile ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimary,
                                      fontFamily: "uber",
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.warning,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      request['status'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colors.onPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "uber",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Service info
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 16,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                request['service'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.textPrimary,
                                  fontFamily: "uber",
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: colors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                request['location'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colors.textSecondary,
                                  fontFamily: "uber",
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Urgency and time
                        Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              size: 16,
                              color:
                                  _getUrgencyColor(request['urgency'], colors),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              request['urgency'],
                              style: TextStyle(
                                fontSize: 14,
                                color: _getUrgencyColor(
                                    request['urgency'], colors),
                                fontWeight: FontWeight.w600,
                                fontFamily: "uber",
                              ),
                            ),
                            const Spacer(),
                            Text(
                              request['estimatedTime'],
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textSecondary,
                                fontFamily: "uber",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Action buttons - only View and Cancel for pending requests
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              icon: Icons.visibility,
                              label: "View Details",
                              color: colors.info,
                              onPressed: () => showDetailsDialog(request),
                            ),
                            _buildActionButton(
                              icon: Icons.cancel,
                              label: "Cancel Request",
                              color: colors.error,
                              onPressed: () => showCancelDialog(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getUrgencyColor(String urgency, AppColors colors) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return colors.error;
      case 'normal':
        return colors.warning;
      case 'low':
        return colors.success;
      default:
        return colors.textSecondary;
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: "uber",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
