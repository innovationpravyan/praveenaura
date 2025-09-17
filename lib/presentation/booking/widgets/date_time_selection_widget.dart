import 'package:aurame/core/extensions/context_extensions.dart';
import 'package:aurame/core/extensions/date_extensions.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeSelectionWidget extends StatefulWidget {
  final Function(DateTime, String) onDateTimeSelected;
  final DateTime? selectedDate;
  final String? selectedTime;

  const DateTimeSelectionWidget({
    super.key,
    required this.onDateTimeSelected,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  State<DateTimeSelectionWidget> createState() =>
      _DateTimeSelectionWidgetState();
}

class _DateTimeSelectionWidgetState extends State<DateTimeSelectionWidget> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  String? selectedTimeSlot;

  final List<String> morningSlots = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
  ];

  final List<String> afternoonSlots = [
    "12:00 PM",
    "12:30 PM",
    "1:00 PM",
    "1:30 PM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
  ];

  final List<String> eveningSlots = [
    "4:00 PM",
    "4:30 PM",
    "5:00 PM",
    "5:30 PM",
    "6:00 PM",
    "6:30 PM",
    "7:00 PM",
    "7:30 PM",
  ];

  // Mock unavailable slots for demonstration
  final List<String> unavailableSlots = ["10:00 AM", "2:00 PM", "5:30 PM"];

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDate;
    selectedTimeSlot = widget.selectedTime;
    if (selectedDay != null) {
      focusedDay = selectedDay!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date & Time',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textHighEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            'Choose your preferred appointment date and time',
            style: context.bodyMedium.copyWith(
              color: context.textMediumEmphasisColor,
            ),
          ),
          SizedBox(height: context.responsiveLargeSpacing),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  Container(
                    decoration: context.cardDecoration,
                    child: TableCalendar<String>(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 90)),
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          this.selectedDay = selectedDay;
                          this.focusedDay = focusedDay;
                          selectedTimeSlot = null; // Reset time selection
                        });
                      },
                      calendarFormat: CalendarFormat.month,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.textHighEmphasisColor,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: context.primaryColor,
                          size: 24,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: context.primaryColor,
                          size: 24,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: context.bodySmall.copyWith(
                          color: context.textMediumEmphasisColor,
                          fontWeight: FontWeight.w500,
                        ),
                        weekendStyle: context.bodySmall.copyWith(
                          color: context.textMediumEmphasisColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: context.bodyMedium.copyWith(
                          color: context.textHighEmphasisColor,
                        ),
                        defaultTextStyle: context.bodyMedium.copyWith(
                          color: context.textHighEmphasisColor,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: context.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: context.bodyMedium.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        todayDecoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: context.bodyMedium.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  if (selectedDay != null) ...[
                    SizedBox(height: context.responsiveLargeSpacing),
                    Text(
                      'Available Time Slots',
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.textHighEmphasisColor,
                      ),
                    ),
                    SizedBox(height: context.componentSpacing),
                    Text(
                      'Select your preferred time for ${selectedDay!.formatted}',
                      style: context.bodySmall.copyWith(
                        color: context.textMediumEmphasisColor,
                      ),
                    ),
                    SizedBox(height: context.responsiveSmallSpacing),

                    // Morning Slots
                    _buildTimeSlotSection('Morning', morningSlots),
                    SizedBox(height: context.responsiveSmallSpacing),

                    // Afternoon Slots
                    _buildTimeSlotSection('Afternoon', afternoonSlots),
                    SizedBox(height: context.responsiveSmallSpacing),

                    // Evening Slots
                    _buildTimeSlotSection('Evening', eveningSlots),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotSection(String title, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: context.textHighEmphasisColor,
          ),
        ),
        SizedBox(height: context.componentSpacing),
        Wrap(
          spacing: 2.w(context),
          runSpacing: 1.h(context),
          children: slots.map((slot) {
            final isSelected = selectedTimeSlot == slot;
            final isUnavailable = unavailableSlots.contains(slot);

            return InkWell(
              onTap: isUnavailable
                  ? null
                  : () {
                      setState(() {
                        selectedTimeSlot = slot;
                      });
                      if (selectedDay != null) {
                        widget.onDateTimeSelected(selectedDay!, slot);
                      }
                    },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w(context),
                  vertical: 1.5.h(context),
                ),
                decoration: BoxDecoration(
                  color: isUnavailable
                      ? context.dividerColor.withOpacity(0.1)
                      : isSelected
                      ? context.primaryColor
                      : context.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isUnavailable
                        ? context.dividerColor.withOpacity(0.3)
                        : isSelected
                        ? context.primaryColor
                        : context.dividerColor.withOpacity(0.3),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: context.primaryColor.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  slot,
                  style: context.bodyMedium.copyWith(
                    color: isUnavailable
                        ? context.textDisabledColor
                        : isSelected
                        ? context.colorScheme.onPrimary
                        : context.textHighEmphasisColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
