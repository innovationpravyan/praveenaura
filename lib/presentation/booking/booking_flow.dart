import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../models/booking_model.dart';
import '../../models/service_model.dart';
import '../../models/salon_model.dart';
import '../../providers/salon_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/base_screen.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final String? salonId;
  final String? serviceId;

  const BookingFlowScreen({
    super.key,
    this.salonId,
    this.serviceId,
  });

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Booking data
  SalonModel? _selectedSalon;
  List<ServiceModel> _selectedServices = [];
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String _serviceType = 'salon'; // 'salon' or 'home'
  String _specialRequests = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    // Load salon and service if provided
    if (widget.salonId != null) {
      final salonState = ref.read(salonProvider);
      if (salonState.salons.isNotEmpty) {
        _selectedSalon = salonState.salons.firstWhere(
              (salon) => salon.id == widget.salonId,
          orElse: () => salonState.salons.first,
        );
      }
    }
    if (widget.serviceId != null) {
      final serviceState = ref.read(serviceProvider);
      if (serviceState.services.isNotEmpty) {
        final service = serviceState.services.firstWhere(
              (service) => service.id == widget.serviceId,
          orElse: () => serviceState.services.first,
        );
        _selectedServices = [service];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildServiceSelectionStep(),
                  _buildDateTimeSelectionStep(),
                  _buildDetailsStep(),
                  _buildConfirmationStep(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Book Appointment',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (_currentStep > 0) {
            _previousStep();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isCompleted = index < _currentStep;
          final isActive = index == _currentStep;

          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 8 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isCompleted || isActive
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).dividerColor,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildServiceSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Services',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the services you want to book',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildServiceTypeToggle(),
          const SizedBox(height: 24),
          if (_selectedSalon != null) ...[
            _buildSalonCard(_selectedSalon!),
            const SizedBox(height: 24),
          ],
          _buildServicesList(),
        ],
      ),
    );
  }

  Widget _buildServiceTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildServiceTypeOption('salon', 'At Salon', Icons.store),
          ),
          Expanded(
            child: _buildServiceTypeOption('home', 'At Home', Icons.home),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeOption(String type, String label, IconData icon) {
    final isSelected = _serviceType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _serviceType = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).disabledColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalonCard(SalonModel salon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.store,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    salon.shortAddress,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: AppColors.getWarningColor(
                          isDark: Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        salon.ratingText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    final serviceState = ref.watch(serviceProvider);
    final services = _selectedSalon != null
        ? serviceState.services.where((service) => service.salonId == _selectedSalon!.id).toList()
        : serviceState.services;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Services',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...services.map((service) {
          final isSelected = _selectedServices.contains(service);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedServices.remove(service);
                  } else {
                    _selectedServices.add(service);
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.design_services,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '₹${service.price.toInt()}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Theme.of(context).disabledColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${service.duration}min',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedServices.add(service);
                          } else {
                            _selectedServices.remove(service);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDateTimeSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date & Time',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose your preferred appointment slot',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildCalendar(),
          const SizedBox(height: 24),
          if (_selectedDate != null) _buildTimeSlots(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = _selectedDate != null &&
                      AppDateUtils.isSameDay(_selectedDate!, date);
                  final isToday = AppDateUtils.isToday(date);

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          _selectedTimeSlot = null; // Reset time slot
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isToday
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppDateUtils.getDayName(date),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).disabledColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppDateUtils.getDay(date),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).textTheme.bodyLarge?.color,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppDateUtils.getMonth(date),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).disabledColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    final timeSlots = AppDateUtils.getTimeSlots(
      startTime: '09:00',
      endTime: '21:00',
      slotDuration: const Duration(minutes: 30),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Time Slots',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = timeSlots[index];
                final isSelected = _selectedTimeSlot == timeSlot;
                final isBooked = _isTimeSlotBooked(timeSlot);

                return InkWell(
                  onTap: isBooked
                      ? null
                      : () {
                    setState(() {
                      _selectedTimeSlot = timeSlot;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Theme.of(context).disabledColor.withValues(alpha: 0.1)
                          : isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBooked
                            ? Theme.of(context).disabledColor.withValues(alpha: 0.3)
                            : isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        timeSlot,
                        style: TextStyle(
                          color: isBooked
                              ? Theme.of(context).disabledColor
                              : isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Provide any special instructions or preferences',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildBookingSummary(),
          const SizedBox(height: 24),
          _buildSpecialInstructions(),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    final totalAmount = _selectedServices.fold(0.0, (sum, service) => sum + service.price);
    final totalDuration = _selectedServices.fold(0, (sum, service) => sum + service.duration);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedSalon != null) ...[
              Row(
                children: [
                  Icon(Icons.store, size: 18, color: Theme.of(context).disabledColor),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_selectedSalon!.displayName)),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Theme.of(context).disabledColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedDate != null && _selectedTimeSlot != null
                        ? '${AppDateUtils.formatDate(_selectedDate!)} at $_selectedTimeSlot'
                        : 'Not selected',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Theme.of(context).disabledColor),
                const SizedBox(width: 8),
                Expanded(child: Text(_serviceType == 'salon' ? 'At Salon' : 'At Home')),
              ],
            ),
            const Divider(height: 24),
            ..._selectedServices.map((service) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(service.name)),
                    Text('₹${service.price.toInt()}'),
                  ],
                ),
              );
            }).toList(),
            const Divider(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Duration: ${AppDateUtils.formatDuration(Duration(minutes: totalDuration))}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  '₹${totalAmount.toInt()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Instructions (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Any specific requirements, allergies, or preferences...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                _specialRequests = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            size: 80,
            color: AppColors.getSuccessColor(
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Booking Confirmed!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your appointment has been successfully booked.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildBookingSummary(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back to Home'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to booking history
                  },
                  child: const Text('View Booking'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? _nextStep : null,
              child: Text(_getNextButtonText()),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Continue';
      case 1:
        return 'Continue';
      case 2:
        return 'Book Now';
      case 3:
        return 'Done';
      default:
        return 'Next';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedServices.isNotEmpty;
      case 1:
        return _selectedDate != null && _selectedTimeSlot != null;
      case 2:
        return true;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _confirmBooking();
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedSalon == null ||
        _selectedServices.isEmpty ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      return;
    }

    try {
      // Parse time slot and create booking datetime
      final time = _parseTimeSlot(_selectedTimeSlot!);
      final bookingDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        time.hour,
        time.minute,
      );

      // Create booking using provider
      await ref.read(bookingProvider.notifier).createBooking(
        salonId: _selectedSalon!.id,
        serviceIds: _selectedServices.map((s) => s.id).toList(),
        bookingDateTime: bookingDateTime,
        serviceType: _serviceType,
        specialInstructions: _specialRequests.isNotEmpty ? _specialRequests : null,
      );

      // Show success message and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking confirmed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  TimeOfDay _parseTimeSlot(String timeSlot) {
    // Parse time slot like "10:00 AM" or "2:30 PM"
    final parts = timeSlot.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isTimeSlotBooked(String timeSlot) {
    // Mock implementation - in real app, check against existing bookings
    final bookedSlots = ['10:00 AM', '02:00 PM', '04:30 PM'];
    return bookedSlots.contains(timeSlot);
  }

  // Mock data methods
  SalonModel _getMockSalon(String salonId) {
    return SalonModel(
      id: salonId,
      name: 'Elegance Beauty Salon',
      description: 'Premium beauty services',
      address: '123 Mall Road',
      city: 'Varanasi',
      state: 'Uttar Pradesh',
      pincode: '221001',
      latitude: 25.3176,
      longitude: 82.9739,
      phoneNumber: '+91 9876543210',
      email: 'info@elegancebeauty.com',
      ownerId: 'owner1',
      rating: 4.8,
      totalReviews: 156,
      isActive: true,
    );
  }

  ServiceModel _getMockService(String serviceId) {
    return ServiceModel(
      id: serviceId,
      name: 'Hair Cut & Style',
      description: 'Professional hair cutting and styling',
      price: 800.0,
      duration: 45,
      category: 'Hair',
      salonId: 'salon1',
      isActive: true,
    );
  }

  List<ServiceModel> _getMockServices() {
    return [
      ServiceModel(
        id: 'service1',
        name: 'Hair Cut & Style',
        description: 'Professional hair cutting and styling',
        price: 800.0,
        duration: 45,
        category: 'Hair',
        salonId: 'salon1',
        isActive: true,
      ),
      ServiceModel(
        id: 'service2',
        name: 'Facial Treatment',
        description: 'Deep cleansing facial with natural ingredients',
        price: 1200.0,
        duration: 60,
        category: 'Skin Care',
        salonId: 'salon1',
        isActive: true,
      ),
      ServiceModel(
        id: 'service3',
        name: 'Manicure & Pedicure',
        description: 'Complete nail care and styling',
        price: 600.0,
        duration: 75,
        category: 'Nail Care',
        salonId: 'salon1',
        isActive: true,
      ),
    ];
  }
}