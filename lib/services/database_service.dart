import '../models/child.dart';
import '../models/nutrition_data.dart';

class DatabaseService {
  final List<Child> _children = [];

  Future<bool> addChild(Child child) async {
    // Simulate database operation
    await Future.delayed(const Duration(seconds: 1));
    _children.add(child);
    return true;
  }

  Future<List<Child>> getChildren() async {
    // Simulate database operation
    await Future.delayed(const Duration(milliseconds: 500));
    return _children;
  }

  Future<bool> addGrowthData(String childId, GrowthData growthData) async {
    // Simulate database operation
    await Future.delayed(const Duration(seconds: 1));
    final childIndex = _children.indexWhere((c) => c.id == childId);
    if (childIndex != -1) {
      _children[childIndex].growthHistory.add(growthData.toMap());
      return true;
    }
    return false;
  }

  Future<List<GrowthData>> getGrowthHistory(String childId) async {
    // Simulate database operation
    await Future.delayed(const Duration(milliseconds: 500));
    final childIndex = _children.indexWhere((c) => c.id == childId);
    if (childIndex != -1) {
      return _children[childIndex]
          .growthHistory
          .map((data) => GrowthData.fromMap(data))
          .toList();
    }
    return [];
  }
}
