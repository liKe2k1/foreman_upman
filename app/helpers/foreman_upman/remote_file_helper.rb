module ForemanUpman
  module RemoteFileHelper

    require 'open-uri'
    require "tmpdir"
    require 'securerandom'


    def download(url)

      filename = begin
        Dir::Tmpname.make_tmpname(["x"], nil)
      rescue NoMethodError
        require "securerandom"
        "#{SecureRandom.urlsafe_base64}"
      end
      tmp_file = File.join(Dir.tmpdir, filename)

      begin
        File.write tmp_file, open(url).read.force_encoding('UTF-8')
      rescue StandardError => err
        logger.error "[RemoteFileHelper] Can't download #{url} #{err.message}"
      end
      tmp_file
    end


    def download_to_string(url)
      tmp_file = download(url)
      File.open(tmp_file, 'rb') { |f| f.read }
    end

  end
end