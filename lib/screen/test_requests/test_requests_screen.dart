import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:labtest/models/lab_request.dart';
import 'package:labtest/models/request_status.dart';
import 'package:labtest/provider/test_request_provider.dart';
import 'package:labtest/store/app_theme.dart';
import 'package:labtest/widget/customTextfield.dart';
import 'package:labtest/widget/custombutton.dart';

class TestRequestsScreen extends StatefulWidget {
  @override
  State<TestRequestsScreen> createState() => _TestRequestsScreenState();
}

class _TestRequestsScreenState extends State<TestRequestsScreen> {
  RequestStatus? _statusFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<TestRequestProvider>();
      provider.fetchTestRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppTheme, TestRequestProvider>(
      builder: (context, theme, provider, child) {
        final colors = theme.colors;
        final requests = _applyFilters(provider.labRequests);

        return Scaffold(
          backgroundColor: colors.background,
          body: Column(
            children: [
              _buildHeader(colors, provider),
              _buildFilters(colors),
              _buildSearchField(colors),
              Expanded(
                child: provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colors.primary,
                        ),
                      )
                    : requests.isEmpty
                        ? _buildEmptyState(colors)
                        : RefreshIndicator(
                            color: colors.primary,
                            onRefresh: () => provider.fetchTestRequests(),
                            child: ListView.builder(
                              padding: ResponsiveHelper.getResponsivePadding(
                                context,
                                mobile: const EdgeInsets.all(16),
                                tablet: const EdgeInsets.all(24),
                                desktop: const EdgeInsets.symmetric(
                                  horizontal: 120,
                                  vertical: 24,
                                ),
                              ),
                              itemCount: requests.length,
                              itemBuilder: (context, index) {
                                final request = requests[index];
                                return _buildRequestCard(colors, provider, request);
                              },
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<LabRequest> _applyFilters(List<LabRequest> requests) {
    final filtered = requests.where((request) {
      if (_statusFilter != null && request.status != _statusFilter) {
        return false;
      }
      if (_searchQuery.isEmpty) {
        return true;
      }
      final query = _searchQuery.toLowerCase();
      final name = request.clientSnapshot?.fullName ??
          request.metadata?['patientName'] as String? ??
          '';
      final tests = request.requestedTests.join(', ').toLowerCase();
      return name.toLowerCase().contains(query) || tests.contains(query);
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  Widget _buildHeader(AppColors colors, TestRequestProvider provider) {
    final total = provider.labRequests.length;
    final pending = provider.labRequests
        .where((request) => request.status == RequestStatus.pending)
        .length;
    final active = provider.labRequests
        .where((request) =>
            request.status == RequestStatus.accepted ||
            request.status == RequestStatus.inProgress)
        .length;
    final completed = provider.labRequests
        .where((request) => request.status == RequestStatus.completed)
        .length;

    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.all(16),
        tablet: const EdgeInsets.all(20),
        desktop: const EdgeInsets.symmetric(horizontal: 120, vertical: 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Iconsax.document_text, color: colors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Requests',
                    style: TextStyle(
                      fontFamily: 'uber',
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 22,
                        tablet: 24,
                        desktop: 28,
                      ),
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    '$total total • $pending pending • $active active • $completed completed',
                    style: TextStyle(
                      fontFamily: 'uber',
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppColors colors) {
    final chips = <Widget>[
      _buildStatusChip(null, 'All'),
      _buildStatusChip(RequestStatus.pending, 'Pending'),
      _buildStatusChip(RequestStatus.accepted, 'Accepted'),
      _buildStatusChip(RequestStatus.inProgress, 'In Progress'),
      _buildStatusChip(RequestStatus.completed, 'Completed'),
      _buildStatusChip(RequestStatus.cancelled, 'Cancelled'),
    ];

    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        desktop: const EdgeInsets.symmetric(horizontal: 120, vertical: 12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: chips,
      ),
    );
  }

  Widget _buildStatusChip(RequestStatus? status, String label) {
    final isSelected = _statusFilter == status;
    final colors = Provider.of<AppTheme>(context, listen: false).colors;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'uber',
          color: isSelected ? colors.onPrimary : colors.textSecondary,
        ),
      ),
      selected: isSelected,
      selectedColor: colors.primary,
      shape: StadiumBorder(
        side: BorderSide(color: colors.border),
      ),
      onSelected: (_) {
        setState(() {
          _statusFilter = status;
        });
      },
    );
  }

  Widget _buildSearchField(AppColors colors) {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        desktop: const EdgeInsets.symmetric(horizontal: 120, vertical: 8),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Iconsax.search_normal),
          hintText: 'Search by patient name or test name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.archive_add, size: 64, color: colors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'No test requests yet',
            style: TextStyle(
              fontFamily: 'uber',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'New requests will appear here once the lab or clients create them.',
            style: TextStyle(
              fontFamily: 'uber',
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    AppColors colors,
    TestRequestProvider provider,
    LabRequest request,
  ) {
    final client = request.clientSnapshot;
    final name = client?.fullName ??
        request.metadata?['patientName'] as String? ??
        'Unnamed Client';
    final requestedTests = request.requestedTests.join(', ');
    final statusColor = _statusColor(request.status, colors);
    final statusLabel = request.status.displayName;
    final createdDate = _formatDate(request.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: colors.primary.withOpacity(0.1),
                  foregroundColor: colors.primary,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(fontFamily: 'uber'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'uber',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        requestedTests.isNotEmpty
                            ? requestedTests
                            : 'Tests pending from client',
                        style: TextStyle(
                          fontFamily: 'uber',
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    statusLabel,
                    style: const TextStyle(fontFamily: 'uber'),
                  ),
                  backgroundColor: statusColor.withOpacity(0.15),
                  labelStyle: TextStyle(color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Iconsax.location, size: 18, color: colors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _formatAddress(request),
                    style: TextStyle(
                      fontFamily: 'uber',
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Iconsax.calendar, size: 18, color: colors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Created $createdDate',
                  style: TextStyle(
                    fontFamily: 'uber',
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<_RequestAction>(
                onSelected: (action) => _handleAction(provider, request, action),
                itemBuilder: (context) => _buildMenuItems(request),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                icon: Icon(Icons.more_horiz, color: colors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<_RequestAction>> _buildMenuItems(LabRequest request) {
    final items = <PopupMenuEntry<_RequestAction>>[
      const PopupMenuItem(
        value: _RequestAction.view,
        child: ListTile(
          leading: Icon(Iconsax.eye),
          title: Text('View details', style: TextStyle(fontFamily: 'uber')),
        ),
      ),
    ];

    if (request.status == RequestStatus.pending) {
      items.addAll([
        const PopupMenuItem(
          value: _RequestAction.accept,
          child: ListTile(
            leading: Icon(Iconsax.verify),
            title: Text('Accept request', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
        const PopupMenuItem(
          value: _RequestAction.edit,
          child: ListTile(
            leading: Icon(Iconsax.edit),
            title: Text('Edit request', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
        const PopupMenuItem(
          value: _RequestAction.cancel,
          child: ListTile(
            leading: Icon(Iconsax.close_circle),
            title: Text('Cancel request', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
      ]);
    }

    if (request.status == RequestStatus.accepted) {
      items.addAll([
        const PopupMenuItem(
          value: _RequestAction.inProgress,
          child: ListTile(
            leading: Icon(Iconsax.activity),
            title: Text('Start collection', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
        const PopupMenuItem(
          value: _RequestAction.complete,
          child: ListTile(
            leading: Icon(Iconsax.tick_circle),
            title: Text('Mark completed', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
        const PopupMenuItem(
          value: _RequestAction.cancel,
          child: ListTile(
            leading: Icon(Iconsax.close_circle),
            title: Text('Cancel request', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
      ]);
    }

    if (request.status == RequestStatus.inProgress) {
      items.addAll([
        const PopupMenuItem(
          value: _RequestAction.complete,
          child: ListTile(
            leading: Icon(Iconsax.tick_circle),
            title: Text('Mark completed', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
        const PopupMenuItem(
          value: _RequestAction.cancel,
          child: ListTile(
            leading: Icon(Iconsax.close_circle),
            title: Text('Cancel request', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
      ]);
    }

    if (request.status == RequestStatus.completed) {
      items.add(
        const PopupMenuItem(
          value: _RequestAction.edit,
          child: ListTile(
            leading: Icon(Iconsax.edit),
            title: Text('Edit summary', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
      );
    }

    if (request.status == RequestStatus.cancelled ||
        request.status == RequestStatus.completed) {
      items.add(
        const PopupMenuItem(
          value: _RequestAction.delete,
          child: ListTile(
            leading: Icon(Iconsax.trash),
            title: Text('Delete request', style: TextStyle(fontFamily: 'uber')),
          ),
        ),
      );
    }

    return items;
  }

  Future<void> _handleAction(
    TestRequestProvider provider,
    LabRequest request,
    _RequestAction action,
  ) async {
    switch (action) {
      case _RequestAction.view:
        _showDetailsDialog(request);
        break;
      case _RequestAction.edit:
        _showEditDialog(provider, request);
        break;
      case _RequestAction.accept:
        _confirmStatusChange(provider, request, RequestStatus.accepted);
        break;
      case _RequestAction.inProgress:
        _confirmStatusChange(provider, request, RequestStatus.inProgress);
        break;
      case _RequestAction.complete:
        _confirmStatusChange(provider, request, RequestStatus.completed);
        break;
      case _RequestAction.cancel:
        _confirmCancel(provider, request);
        break;
      case _RequestAction.delete:
        _confirmDelete(provider, request);
        break;
    }
  }

  void _showDetailsDialog(LabRequest request) {
    final colors = context.read<AppTheme>().colors;
    final client = request.clientSnapshot;
    final metadata = request.metadata ?? {};
    final tests = request.requestedTests.join(', ');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Request Details',
                style: TextStyle(
                  fontFamily: 'uber',
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colors.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailRow('Patient name', client?.fullName ??
                    metadata['patientName'] as String? ?? 'Not specified'),
                _detailRow('Contact number', client?.phoneNumber ??
                    metadata['phoneNumber'] as String? ?? 'Not shared'),
                _detailRow('Email', client?.email ??
                    metadata['email'] as String? ?? 'Not shared'),
                _detailRow('Urgency', request.urgency),
                _detailRow('Requested tests', tests.isNotEmpty ? tests : 'Pending'),
                _detailRow('Location', _formatAddress(request)),
                _detailRow('Coordinates', _formatCoordinates(request)),
                _detailRow('Notes', client?.notes ?? metadata['notes'] as String? ?? '—'),
                const SizedBox(height: 16),
                Text(
                  'History',
                  style: TextStyle(
                    fontFamily: 'uber',
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _detailRow('Created', _formatDate(request.createdAt)),
                if (request.submittedAt != null)
                  _detailRow('Submitted', _formatDate(request.submittedAt!)),
                if (request.acceptedAt != null)
                  _detailRow('Accepted', _formatDate(request.acceptedAt!)),
                if (request.inProgressAt != null)
                  _detailRow('In progress', _formatDate(request.inProgressAt!)),
                if (request.completedAt != null)
                  _detailRow('Completed', _formatDate(request.completedAt!)),
                if (request.cancelledAt != null)
                  _detailRow('Cancelled', _formatDate(request.cancelledAt!)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(TestRequestProvider provider, LabRequest request) {
    final theme = context.read<AppTheme>();
    final colors = theme.colors;
    final nameController = TextEditingController(
      text: request.clientSnapshot?.fullName ??
          request.metadata?['patientName'] as String? ??
          '',
    );
    final locationController = TextEditingController(
      text: request.clientSnapshot?.fullAddress ??
          request.metadata?['addressLine1'] as String? ??
          request.metadata?['location'] as String? ??
          '',
    );
    final testsController = TextEditingController(
      text: request.requestedTests.join(', '),
    );
    String urgency = request.urgency;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Edit Request',
            style: TextStyle(
              fontFamily: 'uber',
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Customtextfield(
                  controller: nameController,
                  labelText: 'Patient Name',
                ),
                const SizedBox(height: 12),
                Customtextfield(
                  controller: locationController,
                  labelText: 'Address or Location',
                ),
                const SizedBox(height: 12),
                Customtextfield(
                  controller: testsController,
                  labelText: 'Requested Tests (comma separated)',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: urgency,
                  decoration: InputDecoration(
                    labelText: 'Urgency',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.border),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                    DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      urgency = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Custombutton(
              text: 'Save',
              onTap: () async {
                Navigator.of(context).pop();
                await provider.updateRequest(
                  requestId: request.id!,
                  patientName: nameController.text.trim(),
                  location: locationController.text.trim(),
                  bloodTestType: testsController.text.trim(),
                  urgency: urgency,
                  context: context,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmStatusChange(
    TestRequestProvider provider,
    LabRequest request,
    RequestStatus target,
  ) {
    final colors = context.read<AppTheme>().colors;
    final actionLabel = target.displayName;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            '$actionLabel request',
            style: TextStyle(
              fontFamily: 'uber',
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to mark this request as $actionLabel?',
            style: TextStyle(
              fontFamily: 'uber',
              color: colors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Custombutton(
              text: actionLabel,
              onTap: () async {
                Navigator.of(context).pop();
                await provider.updateRequestStatus(
                  requestId: request.id!,
                  status: target.value,
                  context: context,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmCancel(TestRequestProvider provider, LabRequest request) {
    final colors = context.read<AppTheme>().colors;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Cancel request',
            style: TextStyle(
              fontFamily: 'uber',
              fontWeight: FontWeight.bold,
              color: colors.error,
            ),
          ),
          content: Text(
            'Canceling will notify the client that this request won\'t be fulfilled. Continue?',
            style: TextStyle(
              fontFamily: 'uber',
              color: colors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
            ),
            Custombutton(
              text: 'Cancel request',
              onTap: () async {
                Navigator.of(context).pop();
                await provider.updateRequestStatus(
                  requestId: request.id!,
                  status: RequestStatus.cancelled.value,
                  context: context,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(TestRequestProvider provider, LabRequest request) {
    final colors = context.read<AppTheme>().colors;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Delete request',
            style: TextStyle(
              fontFamily: 'uber',
              fontWeight: FontWeight.bold,
              color: colors.error,
            ),
          ),
          content: Text(
            'This action cannot be undone. Are you sure you want to delete this request?',
            style: TextStyle(
              fontFamily: 'uber',
              color: colors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Custombutton(
              text: 'Delete',
              onTap: () async {
                Navigator.of(context).pop();
                await provider.deleteRequest(
                  requestId: request.id!,
                  context: context,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Color _statusColor(RequestStatus status, AppColors colors) {
    switch (status) {
      case RequestStatus.pending:
        return colors.warning;
      case RequestStatus.accepted:
        return colors.primary;
      case RequestStatus.inProgress:
        return colors.info;
      case RequestStatus.completed:
        return colors.success;
      case RequestStatus.cancelled:
        return colors.error;
    }
  }

  String _formatAddress(LabRequest request) {
    final client = request.clientSnapshot;
    if (client != null) {
      return client.fullAddress ?? client.addressLine1 ?? 'Location not provided';
    }
    final metadata = request.metadata ?? {};
    final parts = [
      metadata['addressLine1'] as String?,
      metadata['addressLine2'] as String?,
      metadata['city'] as String?,
      metadata['state'] as String?,
      metadata['postalCode'] as String?,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).toList();
    if (parts.isEmpty) {
      return metadata['location'] as String? ?? 'Location not provided';
    }
    return parts.join(', ');
  }

  String _formatCoordinates(LabRequest request) {
    final lat = request.clientSnapshot?.location?.latitude ??
        _toDouble(request.metadata?['coordinates'], 'lat');
    final lng = request.clientSnapshot?.location?.longitude ??
        _toDouble(request.metadata?['coordinates'], 'lng');

    if (lat == null || lng == null) {
      return 'Not provided';
    }
    return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }

  double? _toDouble(dynamic source, String key) {
    if (source is Map) {
      final value = source[key];
      if (value is num) {
        return value.toDouble();
      }
    }
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _detailRow(String label, String value) {
    final colors = context.read<AppTheme>().colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'uber',
              fontSize: 12,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'uber',
              fontSize: 14,
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum _RequestAction {
  view,
  edit,
  accept,
  inProgress,
  complete,
  cancel,
  delete,
}
