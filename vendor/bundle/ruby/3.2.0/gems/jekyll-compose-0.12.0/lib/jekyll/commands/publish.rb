# frozen_string_literal: true

module Jekyll
  module Commands
    class Publish < Command
      def self.init_with_program(prog)
        prog.command(:publish) do |c|
          c.syntax "publish DRAFT_PATH"
          c.description "Moves a draft into the _posts directory and sets the date"

          options.each { |opt| c.option(*opt) }

          c.action { |args, options| process(args, options) }
        end
      end

      def self.options
        [
          ["date", "-d DATE", "--date DATE", "Specify the post date"],
          ["config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array, "Custom configuration file"],
          ["force", "-f", "--force", "Overwrite a post if it already exists"],
          ["timestamp_format", "--timestamp-format FORMAT", "Custom timestamp format"],
        ]
      end

      def self.process(args = [], options = {})
        config = configuration_from_options(options)
        params = PublishArgParser.new args, options, config
        params.validate!

        movement = DraftMovementInfo.new params

        mover = DraftMover.new movement, params.force?, params.source
        mover.move
      end
    end

    class PublishArgParser < Compose::MovementArgParser
      def resource_type
        "draft"
      end

      def date
        @date ||= options["date"] ? Date.parse(options["date"]) : Time.now
      end

      def name
        File.basename path
      end
    end

    class DraftMovementInfo
      attr_reader :params
      def initialize(params)
        @params = params
      end

      def from
        params.path
      end

      def to
        date_stamp = params.date.strftime Jekyll::Compose::DEFAULT_DATESTAMP_FORMAT
        "_posts/#{date_stamp}-#{params.name}"
      end

      def front_matter(data)
        data["date"] ||= params.date.strftime(params.timestamp_format)
        data
      end
    end

    class DraftMover < Compose::FileMover
      def resource_type_from
        "draft"
      end

      def resource_type_to
        "post"
      end
    end
  end
end
