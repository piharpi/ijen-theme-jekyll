# frozen_string_literal: true

module Jekyll
  module Compose
    class FileCreator
      attr_reader :file, :force, :root
      def initialize(file_info, force = false, root = nil)
        @file = file_info
        @force = force
        @root = root
      end

      def create!
        return unless create?

        ensure_directory_exists
        write_file
      end

      def file_path
        return file.path if root.nil? || root.empty?

        File.join(root, file.path)
      end

      private

      def create?
        return true if force
        return true unless File.exist?(file_path)

        Jekyll.logger.warn "A #{file.resource_type} already exists at #{file_path}"
        false
      end

      def ensure_directory_exists
        dir = File.dirname file_path
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      end

      def write_file
        File.open(file_path, "w") do |f|
          f.puts(file.content)
        end

        Jekyll.logger.info "New #{file.resource_type} created at #{file_path.cyan}"
      end
    end
  end
end
