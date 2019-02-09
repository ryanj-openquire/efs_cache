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
      entry = self.cache_file_as_entry(bucket, key, timestamp, lifetime)
      yield entry.absolute_path if entry.cache_miss?
      entry.absolute_path
    end

    def cache_file_as_entry(bucket, key, timestamp, lifetime = LIFETIMES[:DAILY])
      raise ArgumentError, 'Invalid lifetime specified' unless LIFETIMES.values.include?(lifetime)

      entry = FileEntry.new(@service, bucket, key, timestamp, lifetime)
      entry.ensure

      entry
    end

  end

end
