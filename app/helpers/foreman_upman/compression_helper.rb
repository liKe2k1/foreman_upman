module ForemanUpman
  module CompressionHelper

    require "zlib"

    def gunzip_file_to_string(file_path)

      infile = open(file_path)
      gz = Zlib::GzipReader.new(infile)
      body = gz.read
      gz.close

      return body
    end

  end
end