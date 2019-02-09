module EfsCache

  class FileEntry

    def initialize(service, bucket, key, timestamp, lifetime)
      @service = service
      @bucket = bucket
      @key = key
      @timestamp = if timestamp.blank?
        SecureRandom.hex(8)
      else
        timestamp
      end
      @lifetime = lifetime
      @cache_miss = false
      @present = false
    end

    def absolute_path
      @absolute_path ||= begin
        File.join(@service.mount_point, self.relative_path)
      end
    end

    def cache_miss?
      @cache_miss
    end

    def ensure
      if !File.exists?(self.absolute_path)
        @cache_miss = true
        @service.logger.info "cache:miss=#{self.absolute_path}"
        FileUtils.mkdir_p(File.join(@service.mount_point, self.base_path))

        client = Aws::S3::Client.new
        begin
          response = client.get_object(
            bucket: @bucket,
            key: @key,
            response_target: self.absolute_path
          )
        rescue Aws::S3::Errors::NoSuchKey, Aws::S3::Errors::AccessDenied
          return
        rescue StandardError => se
          @service.logger.error "** ERROR FETCHING: #{bucket}:#{key} (#{se.message})"
          return
        end
      end
      @present = true
    end

    def present?
      @present
    end

    def relative_path
      @relative_path ||= begin
        File.join(self.base_path, File.basename(@key))
      end
    end

    protected

    def base_path
      @base_path ||= begin
        key_path = File.dirname(@key)
        File.join(@lifetime, @bucket, key_path, @timestamp.to_s)
      end
    end

  end
end
