import 'dart:io';
import 'package:dio/dio.dart';
import 'package:loja_virtual_brothesbeer/models/cepaberto_address.dart';

const token = '9de9eb77ee6c0e487e96d6bc9a25e105';

class CepAbertoServices {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint);

      if (response.data.isEmpty) {
        return Future.error('CEP inválido!');
      }

      final CepAbertoAddress address = CepAbertoAddress.FromMap(response.data);

      return address;
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
