module EfsCache

  class Manager

    def initialize(settings)
      @settings = settings
      @mount_point = @settings['mount_point']
    end

    def cache_file(bucket, key, timestamp)
      key_name = File.basename(key)
      key_path = File.dirname(key)

      dir_path = File.join(@mount_point, bucket, key_path, timestamp)
      file_path = File.join(dir_path, key_name)

      if !File.exists?(file_path)
        FileUtils.mkdir_p(dir_path)

        client = Aws::S3::Client.new
        response = client.get_object(
          bucket: bucket,
          key: key,
          response_target: file_path
        )
        yield file_path if block_given?
      end
      file_path
    end

  end

end
