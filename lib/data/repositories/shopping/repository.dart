
import 'package:miogra/data/data_sources/shopping/remote_data_sources.dart';
import 'package:miogra/domain/entities/shopping/entity.dart';
import 'package:miogra/domain/repositories/shopping/mobile_repo.dart';

class MobileRepoImplData extends MobileRepoDomain {

MobileRemoteDataSource mobileRemoteDataSource = MobileRemoteDataSourceImpl();

  @override
  Future<List<MobileEntity>> getMobileDataFromDataSourceRepoDomain() async{
    
    final mobilesData = await mobileRemoteDataSource.getMobileDataFromApi();

    return mobilesData;

  }


}