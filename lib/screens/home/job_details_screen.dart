import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../models/job.dart';
import '../../models/application.dart';
import '../../services/admob_service.dart';
import '../../services/payment_service.dart';
import 'chat_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final _coverLetterController = TextEditingController();
  bool _isApplying = false;
  bool _hasApplied = false;
  bool _isJobPoster = false;

  @override
  void initState() {
    super.initState();
    _checkIfApplied();
    _checkIfJobPoster();
  }

  Future<void> _checkIfJobPoster() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      setState(() {
        _isJobPoster = user.uid == widget.job.posterId;
      });
    }
  }

  Future<void> _checkIfApplied() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      final applicationDoc = await FirebaseFirestore.instance
          .collection('applications')
          .where('jobId', isEqualTo: widget.job.id)
          .where('applicantId', isEqualTo: user.uid)
          .get();

      setState(() {
        _hasApplied = applicationDoc.docs.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          if (widget.job.isUrgent)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'URGENT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title and Basic Info
            Text(
              widget.job.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: theme.iconTheme.color?.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.job.location,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.category,
                  size: 16,
                  color: theme.iconTheme.color?.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.job.category.toUpperCase(),
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Salary
            if (widget.job.salary != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.job.salary} ${widget.job.salaryType}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Job Description
            Text(
              'Job Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.job.description,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                height: 1.6,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // Posted by and Date
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted ${_getTimeAgo()}',
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  if (widget.job.appHandlesHiring)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'App Handles Hiring',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                if (!_hasApplied && !_isJobPoster) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isApplying ? null : _applyForJob,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.primaryColor,
                      ),
                      child: _isApplying
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Apply Now',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ] else if (_hasApplied) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Application Submitted',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (_isJobPoster) ...[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.business_center, color: theme.primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your Job Post',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (_hasApplied || _isJobPoster)
                  const SizedBox(width: 12),

                if (_hasApplied || _isJobPoster)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _startConversation,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: theme.primaryColor),
                      ),
                      child: const Text(
                        'Message',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),

            // Application Form (only show if not applied and not job poster)
            if (!_hasApplied && !_isJobPoster) ...[
              const SizedBox(height: 20),
              Text(
                'Cover Letter (Optional)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coverLetterController,
                decoration: InputDecoration(
                  hintText: 'Tell the employer why you\'re interested...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                ),
                maxLines: 4,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTimeAgo() {
    final difference = DateTime.now().difference(widget.job.createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  Future<void> _applyForJob() async {
    final messageText = _coverLetterController.text.trim();
    if (messageText.isEmpty) return;

    setState(() => _isApplying = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      final userModel = authProvider.userModel;

      if (user == null || userModel == null) {
        throw Exception('User not authenticated');
      }

      // If app handles hiring, process payment first
      if (widget.job.appHandlesHiring && widget.job.salary != null) {
        final applicationFee = PaymentService.calculateCommission(widget.job.salary!);

        // Show payment dialog
        final paymentResult = await showDialog<Map<String, dynamic>>(
          context: context,
          barrierDismissible: false,
          builder: (context) => PaymentDialog(
            job: widget.job,
            applicationFee: applicationFee,
            applicantName: userModel.name,
            applicantEmail: userModel.email,
          ),
        );

        if (paymentResult == null || !paymentResult['success']) {
          setState(() => _isApplying = false);
          return;
        }
      }

      final application = Application(
        id: FirebaseFirestore.instance.collection('applications').doc().id,
        jobId: widget.job.id,
        applicantId: user.uid,
        message: messageText,
        appliedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('applications')
          .doc(application.id)
          .set(application.toMap());

      setState(() => _hasApplied = true);

      // Show interstitial ad after successful application
      AdMobService.showInterstitialAd();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit application: $e')),
        );
      }
    } finally {
      setState(() => _isApplying = false);
    }
  }

  Future<void> _startConversation() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user;

    if (currentUser == null) return;

    String otherUserId;
    String otherUserName;

    if (_isJobPoster) {
      // Job poster wants to message an applicant
      // For now, we'll get the first applicant, but ideally this should show a list
      final applications = await FirebaseFirestore.instance
          .collection('applications')
          .where('jobId', isEqualTo: widget.job.id)
          .limit(1)
          .get();

      if (applications.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No applicants yet')),
        );
        return;
      }

      final application = Application.fromMap(
        applications.docs.first.data() as Map<String, dynamic>
      );
      otherUserId = application.applicantId;

      // Get applicant name from users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        otherUserName = userData['name'] ?? 'Applicant';
      } else {
        otherUserName = 'Applicant';
      }
    } else {
      // Applicant wants to message job poster
      otherUserId = widget.job.posterId;

      // Get job poster name
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        otherUserName = userData['name'] ?? 'Job Poster';
      } else {
        otherUserName = 'Job Poster';
      }
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            job: widget.job,
            otherUserId: otherUserId,
            otherUserName: otherUserName,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _coverLetterController.dispose();
    super.dispose();
  }
}

class PaymentDialog extends StatefulWidget {
  final Job job;
  final double applicationFee;
  final String applicantName;
  final String applicantEmail;

  const PaymentDialog({
    super.key,
    required this.job,
    required this.applicationFee,
    required this.applicantName,
    required this.applicantEmail,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Complete Application'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job: ${widget.job.title}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Application Fee: ৳${widget.applicationFee.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This fee includes our hiring service. We\'ll handle the payment to the worker and ensure quality service.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Secure payment powered by SSLCommerz',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context, {'success': false}),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _processPayment,
          child: _isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Pay & Apply'),
        ),
      ],
    );
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // For demo purposes, use simulated payment
      final paymentResult = await PaymentService.simulatePayment(
        amount: widget.applicationFee,
        jobTitle: widget.job.title,
      );

      if (mounted) {
        Navigator.pop(context, paymentResult);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
        Navigator.pop(context, {'success': false});
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}