data "archive_file" "zipped_function" {
  type        = "zip"
  source_dir = var.dist_dir
  output_path = var.zip_file_name
}