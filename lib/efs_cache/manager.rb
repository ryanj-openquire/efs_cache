module EfsCache

  class Manager

    LIFETIMES = {
      DAILY: 'daily',
      MONTHLY: 'monthly',
      WEEKLY: 'weekly'
    }

    def initialize(service)
      @service = service
    end

    def cache_file(bucket, key, timestamp, lifetime = LIFETIMES[:DAILY])
      raise ArgumentError, 'Invalid lifetime specified' unless LIFETIMES.values.include?(lifetime)

      key_name = File.basename(key)
      key_path = File.dirname(key)

      timestamp = SecureRandom.hex(8) if timestamp.blank?

      dir_path = File.join(@service.mount_point, lifetime, bucket, key_path, timestamp.to_s)
      file_path = File.join(dir_path, key_name)

      if !File.exists?(file_path)
        @service.logger.info "cache:miss=#{file_path}"
        FileUtils.mkdir_p(dir_path)

        client = Aws::S3::Client.new
        begin
          response = client.get_object(
            bucket: bucket,
            key: key,
            response_target: file_path
          )
        rescue Aws::S3::Errors::NoSuchKey
          return
        rescue StandardError => se
          @service.logger.error "** ERROR FETCHING: #{bucket}:#{key} (#{se.message})"
          return
        end
        yield file_path if block_given?
      end
      file_path
    end

    protected

    def _download_file(bucket, key, output_file)
    end

  end

end
