output filename {
  value = data.archive_file.zipped_function.output_path
}

output hash {
  value = filebase64sha256(data.archive_file.zipped_function.output_path)
}