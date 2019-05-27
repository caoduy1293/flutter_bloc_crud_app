import './models/BaseModel.dart';

class AppUtils {
  static int findItemIndexInListById(List<BaseModel> listSource, idItem) {
    var find = listSource.firstWhere(
          (it) => it.id == idItem,
      orElse: () => null,
    );
    if (find != null) return listSource.indexOf(find);
    return -1;
  }
}