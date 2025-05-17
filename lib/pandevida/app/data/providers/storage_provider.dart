import 'dart:io';
import 'request_handler.dart';

class FirebaseStorageProvider {
  final String bucket;
  late String uploadUrlBase;
  late String storageUrlBase;

  FirebaseStorageProvider({
    required this.bucket,
  }) {
    uploadUrlBase =
        'https://storage.googleapis.com/upload/storage/v1/b/$bucket/o';
    storageUrlBase = 'https://storage.googleapis.com/storage/v1/b/$bucket/o';
  }

  Future<Map<String, dynamic>> uploadImage(
    File image,
    String path, {
    Map<String, String>? headers,
  }) async {
    final uploadUrl = '$uploadUrlBase?name=${Uri.encodeComponent(path)}';

    // Additional headers for Firebase Storage
    final Map<String, String> storageHeaders = {
      'Content-Type': 'application/octet-stream',
      ...(headers ?? {}),
    };

    // Read the file as bytes
    final bytes = await image.readAsBytes();

    // Convert bytes to a map format that sendRequest can accept
    final Map<String, dynamic> data = {
      'file': bytes,
    };

    return await sendRequest(
      Method.POST,
      uploadUrl,
      data: data,
      headers: storageHeaders,
    );
  }

  Future<Map<String, dynamic>> getImageMetadata(
    String path, {
    Map<String, String>? headers,
  }) async {
    final metadataUrl = '$storageUrlBase/${Uri.encodeComponent(path)}';
    return await sendRequest(Method.GET, metadataUrl, headers: headers);
  }

  String getImageDownloadUrl(String path) {
    return '$storageUrlBase/${Uri.encodeComponent(path)}?alt=media';
  }

  Future<Map<String, dynamic>> deleteImage(
    String path, {
    Map<String, String>? headers,
  }) async {
    final deleteUrl = '$storageUrlBase/${Uri.encodeComponent(path)}';
    return await sendRequest(Method.DELETE, deleteUrl, headers: headers);
  }

  Future<Map<String, dynamic>> listImages({
    String? prefix,
    Map<String, String>? headers,
  }) async {
    String listUrl = storageUrlBase;
    if (prefix != null) {
      listUrl += '?prefix=${Uri.encodeComponent(prefix)}';
    }
    return await sendRequest(Method.GET, listUrl, headers: headers);
  }
}
