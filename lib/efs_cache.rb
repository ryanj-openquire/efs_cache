require "efs_cache/version"
require 'efs_cache/manager'
require 'yaml'
require 'fileutils'
require 'logger'

module EfsCache

  class << self

    def configure
      raise RuntimeError, 'EfsCache has already been configured' if @settings

      self._configure_from_file
      yield self if block_given?

      raise ArgumentError, 'No mount point specified' unless @settings['mount_point']
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def logger=(new_logger)
      @logger = new_logger
    end

    def manager
      @manager ||= EfsCache::Manager.new(self)
    end

    def mount_point
      @settings['mount_point']
    end

    def mount_point=(new_mount_point)
      @settings['mount_point'] = new_mount_point
    end

    protected

    def _configure_from_file
      @settings = YAML.load_file(Rails.root.join('config', 'efs_cache.yml'))
    end

  end

end
