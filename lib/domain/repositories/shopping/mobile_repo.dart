
import 'package:miogra/domain/entities/shopping/entity.dart';

abstract class MobileRepoDomain {

  Future<List<MobileEntity>> getMobileDataFromDataSourceRepoDomain();
}