# frozen_string_literal: true

module Jekyll
  module Commands
    class Rename < Command
      def self.init_with_program(prog)
        prog.command(:rename) do |c|
          c.syntax "rename PATH NAME"
          c.description "Moves a file to a given NAME and sets the title and date"

          options.each { |opt| c.option(*opt) }

          c.action { |args, options| process(args, options) }
        end
      end

      def self.options
        [
          ["force", "-f", "--force", "Overwrite a post if it already exists"],
          ["config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array, "Custom configuration file"],
          ["date", "-d DATE", "--date DATE", "Specify the date"],
          ["now", "--now", "Specify the date as now"],
        ]
      end

      def self.process(args = [], options = {})
        config = configuration_from_options(options)
        params = RenameArgParser.new(args, options, config)
        params.validate!

        movement = RenameMovementInfo.new(params)

        mover = RenameMover.new(movement, params.force?, params.source)
        mover.move
      end
    end

    class RenameArgParser < Compose::ArgParser
      def validate!
        raise ArgumentError, "You must specify current path and the new title." if args.length < 2

        if options.values_at("date", "now").compact.length > 1
          raise ArgumentError, "You can only specify one of --date DATE or --now."
        end
      end

      def current_path
        @current_path ||= args[0]
      end

      def path
        File.join(source, current_path).sub(%r!\A/!, "")
      end

      def dirname
        @dirname ||= File.dirname(current_path)
      end

      def basename
        @basename ||= File.basename(current_path)
      end

      def title
        @title ||= args.drop(1).join(" ")
      end

      def touch?
        !!options["date"] || options["now"]
      end

      def date
        @date ||= if options["now"]
                    Time.now
                  elsif options["date"]
                    Date.parse(options["date"])
                  end
      end

      def date_from_filename
        Date.parse(Regexp.last_match(1)) if basename =~ Jekyll::Document::DATE_FILENAME_MATCHER
      end

      def post?
        dirname == "_posts"
      end

      def draft?
        dirname == "_drafts"
      end
    end

    class RenameMovementInfo < Compose::FileInfo
      attr_reader :params
      def initialize(params)
        @params = params
      end

      def from
        params.path
      end

      def resource_type
        if @params.post?
          "post"
        elsif @params.draft?
          "draft"
        else
          "file"
        end
      end

      def to
        if @params.post?
          File.join(@params.dirname, "#{date_stamp}-#{file_name}")
        else
          File.join(@params.dirname, file_name)
        end
      end

      def front_matter(data)
        data["title"] = params.title
        data["date"] = time_stamp if @params.touch?
        data
      end

      private

      def date_stamp
        if @params.touch?
          @params.date.strftime Jekyll::Compose::DEFAULT_DATESTAMP_FORMAT
        else
          @params.date_from_filename.strftime Jekyll::Compose::DEFAULT_DATESTAMP_FORMAT
        end
      end

      def time_stamp
        @params.date.strftime Jekyll::Compose::DEFAULT_TIMESTAMP_FORMAT
      end
    end

    class RenameMover < Compose::FileMover
      def resource_type_from
        @movement.resource_type
      end
      alias_method :resource_type_to, :resource_type_from
    end
  end
end
