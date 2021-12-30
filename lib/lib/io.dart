import "dart:io";
import "package:http/http.dart" as http;

enum WebAPIArch{
  raw, //生データ
  grpc,//gRPC/RPC
  migar,//Migarsso/RPC
  va_rpc, //各種RPC
  openapi,//OpenAPI/REST
  raml, //RAML/REST
  fastapi,//FastAPI/REST
  va_rest, //各種REST
  soap,//SOAP
}
abstract class StoredDataIO{
  void loadOverHTTP(String url,WebAPIArch kind);
  void writeOverHTTP(String url,WebAPIArch kind);
  void loadFromLocal(String path);
  void writeToLocal(String path);
}
abstract class GatewayIO{}
class GatewayHTTP extends GatewayIO{
  String url;
  WebAPIArch kind;
  GatewayHTTP(this.url,this.kind);
}
class GatewayLocal extends GatewayIO{
  String path;
  GatewayLocal(this.path);
}