class FileUploadData {
  final String path;
  final String name; // Field name for FormData (e.g., 'attachments[]')
  final String? fileName; // Optional filename, defaults to path basename

  FileUploadData({required this.path, required this.name, this.fileName});
}
