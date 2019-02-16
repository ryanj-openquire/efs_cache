require 'efs_cache/version'
require 'efs_cache/manager'
require 'efs_cache/file_entry'
require 'yaml'
require 'fileutils'
require 'logger'
require 'securerandom'

module EfsCache

  class << self

    def configure
      raise RuntimeError, 'EfsCache has already been configured' if @settings

      self._configure_from_file
      yield self if block_given?

      raise ArgumentError, 'No mount point specified' unless @settings['mount_point']

      FileUtils.mkdir_p(self.mount_point)
      dir_owner = self.mount_owner
      FileUtils.chown(dir_owner, dir_owner, self.mount_point) unless dir_owner.blank?
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def logger=(new_logger)
      @logger = new_logger
    end

    def manager
      @manager ||= begin
        raise(ArgumentError, 'EfsCache has not been configured') unless @settings['mount_point']
        EfsCache::Manager.new(self)
      end
    end

    def mount_point
      @settings['mount_point']
    end

    def mount_point=(new_mount_point)
      @settings['mount_point'] = new_mount_point
    end

    def mount_owner
      @settings['mount_owner']
    end

    def mount_owner=(new_mount_owner)
      @settings['mount_owner'] = new_mount_owner unless new_mount_owner.blank?
    end

    protected

    def _configure_from_file
      config_file = File.join(Rails.root, 'config', 'efs_cache.yml')
      @settings = if File.exists?(config_file)
        YAML.load_file(config_file)
      else
        {}
      end
    end

  end

end
