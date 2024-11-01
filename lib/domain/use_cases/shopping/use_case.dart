import 'package:miogra/data/repositories/shopping/repository.dart';
import 'package:miogra/domain/entities/shopping/entity.dart';
import 'package:miogra/domain/repositories/shopping/mobile_repo.dart';

class MobileUseCases {

  MobileRepoDomain  mobileRepoDomain = MobileRepoImplData();

  Future<List<MobileEntity>> getMobilesDataFromDataSourceUseCases () async {
    
    final postss = await mobileRepoDomain.getMobileDataFromDataSourceRepoDomain();

    return postss;

   
  }
    
}