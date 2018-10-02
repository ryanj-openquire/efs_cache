require "efs_cache/version"
require 'efs_cache/manager'
require 'yaml'
require 'fileutils'

module EfsCache

  class << self

    def configure
      raise RuntimeError, 'EfsCache has already been configured' if @settings

      self._configure_from_file
      yield self if block_given?
    end

    def manager
      @manager ||= EfsCache::Manager.new(@settings)
    end

    protected

    def _configure_from_file
      @settings = YAML.load_file(Rails.root.join('config', 'efs_cache.yml'))
    end

  end

end
