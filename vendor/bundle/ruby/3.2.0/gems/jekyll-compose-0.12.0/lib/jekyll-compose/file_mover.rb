# frozen_string_literal: true

module Jekyll
  module Compose
    class FileMover
      attr_reader :force, :movement, :root
      def initialize(movement, force = false, root = nil)
        @movement = movement
        @force = force
        @root = root
      end

      def resource_type_from
        "file"
      end

      def resource_type_to
        "file"
      end

      def move
        return unless valid_source? && valid_destination?

        ensure_directory_exists
        update_front_matter
        move_file
      end

      def validate_source
        raise ArgumentError, "There was no #{resource_type_from} found at '#{from}'." unless File.exist? from
      end

      def ensure_directory_exists
        dir = File.dirname to
        Dir.mkdir(dir) unless Dir.exist?(dir)
      end

      def validate_should_write!
        raise ArgumentError, "A #{resource_type_to} already exists at #{to}" if File.exist?(to) && !force
      end

      def move_file
        FileUtils.mv(from, to)
        Jekyll.logger.info "#{resource_type_from.capitalize} #{from} was moved to #{to}"
      end

      def update_front_matter
        content = File.read(from)
        if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
          content = $POSTMATCH
          match = Regexp.last_match[1] if Regexp.last_match
          data = movement.front_matter(Psych.safe_load(match))
          File.write(from, "#{Psych.dump(data)}---\n#{content}")
        end
      rescue Psych::SyntaxError => e
        Jekyll.logger.warn e
      rescue StandardError => e
        Jekyll.logger.warn e
      end

      private

      def valid_source?
        return true if File.exist?(from)

        invalidate_with "There was no #{resource_type_from} found at '#{from}'."
      end

      def valid_destination?
        return true if force
        return true unless File.exist?(to)

        invalidate_with "A #{resource_type_to} already exists at #{to}"
      end

      def invalidate_with(msg)
        Jekyll.logger.warn msg
        false
      end

      def from
        movement.from
      end

      def to
        file_path(movement.to)
      end

      def file_path(path)
        return path if root.nil? || root.empty?

        File.join(root, path)
      end
    end
  end
end
