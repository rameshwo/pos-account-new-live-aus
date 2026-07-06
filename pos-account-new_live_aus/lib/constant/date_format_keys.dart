import 'package:intl/intl.dart';

final DATE_FORMAT = DateFormat('EEEE, d MMM y');
final DATE_TIME_FORMAT = DateFormat('EEE d MMM, h:mm a');

// final YMD_FORMAT = DateFormat('dd/MM/yyyy');
// final TIME_FORMAT = DateFormat('kk:mm a');

final YMD_T_FORMAT = DateFormat('dd_MM_yyyy_HH_mm_ss');
// final TABLE_DATE_FORMAT = DateFormat('MM/dd/yyyy HH:mm');
// DateFormat('yyyy/MM/dd HH:mm');

final CAL_WEEK_FORMAT1 = DateFormat('MMM dd - ');
final CAL_WEEK_FORMAT2 = DateFormat('dd, yyyy');

final CAL_TIME_FORMAT = DateFormat('hh:mm a');
final CAL_DATE_TIME_FORMAT = DateFormat('MMM dd, hh:mm a');

final CAL_TIME_FORMAT1 = DateFormat('h a');

final GET_MONTH = DateFormat('MMMM'); // July
final GET_DAY = DateFormat('EEEE'); // Tuesday
final GET_TIME = DateFormat('HH:mm:ss'); // 10:44:32

final DAY_NAME = DateFormat('EEEE');

final RESERVE_DATE_FORMAT = DateFormat('yyyy-MM-dd HH:mm:ss');

DateFormat GET_DATE_FORMAT(String val) => DateFormat(val);
