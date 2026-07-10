import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_account/repository/repo.dart';
import 'package:pos_account/services/database/database_helper.dart';

@GenerateMocks([http.Client, SharedPreferences, BaseRepo])
void main() {}
