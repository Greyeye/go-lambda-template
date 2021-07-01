output filename {
  value = data.archive_file.zipped_function.output_path
}

output hash {
  value = data.archive_file.zipped_function.output_md5
}

output filebase64sha256 {
  value = filebase64sha256(data.archive_file.zipped_function.output_path)
}