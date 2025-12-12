import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/child.dart';
import '../models/growth_data.dart';
import '../models/development_target.dart';

class DatabaseServiceAPI with ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2/kumbanga_api/';

  /// ===========================
  /// ⚙️ Helper – Safe JSON decode
  /// ===========================
  dynamic _safeJsonDecode(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      debugPrint("JSON decode error: $e");
      return null;
    }
  }

  /// ===========================
  /// 📌 INFORMASI
  /// ===========================

  Future<List<Map<String, dynamic>>> getInformasi() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}get_informasi.php'),
      );

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      debugPrint("❌ getInformasi error: $e");
    }

    return [];
  }

  Future<bool> addInformasi(String judul, String deskripsi) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}add_informasi.php'),
        body: {
          "judul": judul,
          "deskripsi": deskripsi,
        },
      );

      final data = _safeJsonDecode(response.body);
      return data != null && data['success'] == true;
    } catch (e) {
      debugPrint("❌ addInformasi error: $e");
      return false;
    }
  }

  Future<bool> updateInformasi(
      String id, String judul, String deskripsi) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}update_informasi.php'),
        body: {
          "id": id,
          "judul": judul,
          "deskripsi": deskripsi,
        },
      );

      final data = _safeJsonDecode(response.body);
      return data != null && data['success'] == true;
    } catch (e) {
      debugPrint("❌ updateInformasi error: $e");
      return false;
    }
  }

  Future<bool> deleteInformasi(String id) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}delete_informasi.php'),
        body: {"id": id},
      );

      final data = _safeJsonDecode(response.body);
      return data != null && data['success'] == true;
    } catch (e) {
      debugPrint("❌ deleteInformasi error: $e");
      return false;
    }
  }

  /// ===========================
  /// 👤 USERS (Admin View)
  /// ===========================
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('${baseUrl}get_all_users.php'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['users']);
      }
      return [];
    }

    throw Exception("Gagal mengambil data user");
  }

  /// ===========================
  /// 🧒 ADD CHILD
  /// ===========================
  Future<bool> addChild(Child child, {required String userId}) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register_child.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'user_id': userId,
          'name': child.name,
          'birth_date': child.birthDate.toIso8601String().split('T').first,
          'gender': child.gender,
        },
      );

      final data = _safeJsonDecode(response.body);
      return data != null && data['success'] == true;
    } catch (e) {
      debugPrint("❌ addChild error: $e");
      return false;
    }
  }

  /// ===========================
  /// 🧒 GET CHILDREN BY USER
  /// ===========================
  Future<List<Child>> getChildrenByUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}get_children.php?user_id=$userId'),
      );

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return (data['children'] as List)
            .map((e) => Child.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint("❌ getChildrenByUser error: $e");
      return [];
    }
  }

  /// ===========================
  /// 📈 ADD GROWTH DATA
  /// ===========================
  Future<bool> addGrowthData(String childId, GrowthData growth) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}add_growth_data.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'child_id': childId,
          'weight': growth.weight.toString(),
          'height': growth.height.toString(),
          'head_circumference': growth.headCircumference.toString(),
          'date': growth.date.toIso8601String().split('T').first,
          'notes': growth.notes,
        },
      );

      final data = _safeJsonDecode(response.body);
      return data != null && data['success'] == true;
    } catch (e) {
      debugPrint("❌ addGrowthData error: $e");
      return false;
    }
  }

  /// ===========================
  /// 📊 GET GROWTH DATA
  /// ===========================
  Future<List<GrowthData>> getGrowthDataByChild(String childId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}get_growth_data.php?child_id=$childId'),
      );

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return (data['growth_data'] as List)
            .map((e) => GrowthData.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint("❌ getGrowthData error: $e");
      return [];
    }
  }

  /// ===========================
  /// 🎯 SAVE DEVELOPMENT TARGET
  /// ===========================
  Future<bool> saveDevelopmentTarget({
    required String childId,
    required int ageInMonths,
    required bool physicalDone,
    required bool cognitiveDone,
    required bool socialDone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}save_development_target.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'child_id': childId,
          'age_in_months': ageInMonths.toString(),
          'physical_done': physicalDone ? "1" : "0",
          'cognitive_done': cognitiveDone ? "1" : "0",
          'social_done': socialDone ? "1" : "0",
        },
      );

      debugPrint("📤 saveDevelopmentTarget response: ${response.body}");

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("❌ saveDevelopmentTarget error: $e");
      return false;
    }
  }

  /// ===========================
  /// 🎯 GET DEVELOPMENT TARGETS
  /// ===========================
  Future<List<DevelopmentTarget>> getDevelopmentTargets(String childId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}get_development_targets.php?child_id=$childId'),
      );

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return (data['targets'] as List)
            .map((e) => DevelopmentTarget.fromMap(e))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint("❌ getDevelopmentTargets error: $e");
      return [];
    }
  }

  /// ===========================
  /// 💚 DONATION – GET CAMPAIGNS
  /// ===========================
  Future<List<Map<String, dynamic>>> getDonationCampaigns() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}donations/get_campaigns.php'),
      );

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      debugPrint("❌ getDonationCampaigns error: $e");
    }
    return [];
  }

  /// ===========================
  /// 💚 DONATION – GET DETAIL
  /// ===========================
  Future<Map<String, dynamic>?> getDonationDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}donations/get_campaign_detail.php?id=$id'),
      );

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return data['data'];
      }
    } catch (e) {
      debugPrint("❌ getDonationDetail error: $e");
    }
    return null;
  }

  /// ===========================
  /// 💚 DONATION – CREATE CAMPAIGN (Admin)
  /// ===========================
  Future<bool> createDonationCampaign({
    required String title,
    required String description,
    String? base64Image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}donations/create_campaign.php'),
        body: {
          'title': title,
          'description': description,
          'image_base64': base64Image ?? '',
        },
      );

      final data = _safeJsonDecode(response.body);
      return data != null && data['success'] == true;
    } catch (e) {
      debugPrint("❌ createDonationCampaign error: $e");
      return false;
    }
  }

  /// ===========================
  /// 💚 DONATION – DONATE (User)
  /// ===========================
  Future<bool> donateToCampaign({
    required String campaignId,
    required String userId,
    required int amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}donations/donate.php'),
        body: {
          'campaign_id': campaignId,
          'user_id': userId,
          'amount': amount.toString(),
        },
      );

      final data = _safeJsonDecode(response.body);
      return data != null && data['success'] == true;
    } catch (e) {
      debugPrint("❌ donateToCampaign error: $e");
      return false;
    }
  }

  /// ===========================
  /// 💚 DONATION – GET DONATIONS LIST
  /// ===========================
  Future<List<Map<String, dynamic>>> getDonationsByCampaign(
      String campaignId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${baseUrl}donations/get_donations.php?campaign_id=$campaignId'),
      );

      final data = _safeJsonDecode(response.body);

      if (data != null && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      debugPrint("❌ getDonationsByCampaign error: $e");
    }
    return [];
  }
}
