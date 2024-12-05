# frozen_string_literal: true

module Jekyll
  module Commands
    class ComposeCommand < Command
      def self.init_with_program(prog)
        prog.command(:compose) do |c|
          c.syntax "compose NAME"
          c.description "Creates a new document with the given NAME"

          options.each { |opt| c.option(*opt) }

          c.action { |args, options| process(args, options) }
        end
      end

      def self.options
        [
          ["extension", "-x EXTENSION", "--extension EXTENSION", "Specify the file extension"],
          ["layout", "-l LAYOUT", "--layout LAYOUT", "Specify the document layout"],
          ["force", "-f", "--force", "Overwrite a document if it already exists"],
          ["date", "-d DATE", "--date DATE", "Specify the document date"],
          ["collection", "-c COLLECTION", "--collection COLLECTION", "Specify the document collection"],
          ["post", "--post", "Create a new post (default)"],
          ["draft", "--draft", "Create a new draft"],
          ["config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array, "Custom configuration file"],
        ]
      end

      def self.process(args = [], options = {})
        config = configuration_from_options(options)
        params = ComposeCommandArgParser.new(args, options, config)
        params.validate!

        document = ComposeCommandFileInfo.new(params)

        file_creator = Compose::FileCreator.new(document, params.force?, params.source)
        file_creator.create!

        Compose::FileEditor.bootstrap(config)
        Compose::FileEditor.open_editor(file_creator.file_path)
      end

      class ComposeCommandArgParser < Compose::ArgParser
        def validate!
          if options.values_at("post", "draft", "collection").compact.length > 1
            raise ArgumentError, "You can only specify one of --post, --draft, or --collection COLLECTION."
          end

          super
        end

        def date
          @date ||= options["date"] ? Date.parse(options["date"]) : Time.now
        end

        def collection
          if (coll = options["collection"])
            coll
          elsif options["draft"]
            "drafts"
          else
            "posts"
          end
        end
      end

      class ComposeCommandFileInfo < Compose::FileInfo
        def initialize(params)
          @params = params
          @collection = params.collection
        end

        def resource_type
          case @collection
          when "posts"  then "post"
          when "drafts" then "draft"
          else
            "file"
          end
        end

        def path
          File.join("_#{@collection}", file_name)
        end

        def file_name
          @collection == "posts" ? "#{date_stamp}-#{super}" : super
        end

        def content(custom_front_matter = {})
          default_front_matter = front_matter_defaults_for(@collection)
          custom_front_matter.merge!(default_front_matter) if default_front_matter.is_a?(Hash)

          super({ "date" => time_stamp }.merge!(custom_front_matter))
        end

        private

        def date_stamp
          @params.date.strftime(Jekyll::Compose::DEFAULT_DATESTAMP_FORMAT)
        end

        def time_stamp
          @params.date.strftime(Jekyll::Compose::DEFAULT_TIMESTAMP_FORMAT)
        end
      end
    end
  end
end
