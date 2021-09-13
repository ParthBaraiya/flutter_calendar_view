// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import '../enumerations.dart';

/// Creates Weekday sequence using given arguments.
///
/// This sequence defines
class WeekdaySequence {
  List<WeekDays> _sequence = [];

  List<WeekDays> get sequence => _sequence.toList(growable: false);

  /// Creates a sequence from list of [WeekDays].
  ///
  /// ex,
  ///
  /// ```dart
  /// WeekdaySequence.fromList(
  ///   sequence: [WeekDays.monday, WeekDays.tuesday],
  /// )
  /// ```
  ///
  /// If you provide above sequence in [WeekView],
  /// It will generate week view for two days.
  WeekdaySequence({
    List<WeekDays> sequence = WeekDays.values,
  })  : _sequence = sequence.toList(),
        assert(sequence.isNotEmpty, "sequence can not be empty.");

  WeekdaySequence.continuous({
    required WeekDays startDay,
    required WeekDays endDay,
  }) {
    if (startDay == endDay) {
      _sequence.add(startDay);
    } else {
      final currentDays = WeekDays.values;
      var i = 0;
      while (currentDays[i] != startDay) i++;

      while (currentDays[i] != endDay) {
        _sequence.add(currentDays[i]);
        i = (i + 1) % currentDays.length;
      }
    }

    assert(_sequence.isNotEmpty, "Generated sequence can not be empty.");
  }

  WeekdaySequence.offset({required int offset}) {
    final currentDays = WeekDays.values;

    for (var i = offset, counter = 0; counter < 7; i++, counter++) {
      _sequence.add(currentDays[i % currentDays.length]);
    }
  }
}
