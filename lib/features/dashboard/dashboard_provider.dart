import 'package:auth_katalog_app/core/network/dio/dio_client.dart';
import 'package:auth_katalog_app/core/providers/network_info.dart';
import 'package:auth_katalog_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:auth_katalog_app/features/dashboard/infrastructure/datasources/dashboard_remote_data_source.dart';
import 'package:auth_katalog_app/features/dashboard/infrastructure/repositories/dashboard_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

@Riverpod(keepAlive: true)
DashboardRepository dashboardRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final remoteDataSource = DashboardRemoteDataSourceImpl(dio: dio);

  return DashboardRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
}
