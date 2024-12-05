# frozen_string_literal: true

module Jekyll
  module Commands
    class Page < Command
      def self.init_with_program(prog)
        prog.command(:page) do |c|
          c.syntax "page NAME"
          c.description "Creates a new page with the given NAME"

          options.each { |opt| c.option(*opt) }

          c.action { |args, options| process(args, options) }
        end
      end

      def self.options
        [
          ["extension", "-x EXTENSION", "--extension EXTENSION", "Specify the file extension"],
          ["layout", "-l LAYOUT", "--layout LAYOUT", "Specify the page layout"],
          ["force", "-f", "--force", "Overwrite a page if it already exists"],
          ["config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array, "Custom configuration file"],
        ]
      end

      def self.process(args = [], options = {})
        config = configuration_from_options(options)
        params = PageArgParser.new(args, options, config)
        params.validate!

        page = PageFileInfo.new(params)

        Compose::FileCreator.new(page, params.force?, params.source).create!
      end

      class PageArgParser < Compose::ArgParser
        def layout
          options["layout"] || Jekyll::Compose::DEFAULT_LAYOUT_PAGE
        end
      end

      class PageFileInfo < Compose::FileInfo
        def resource_type
          "page"
        end

        alias_method :path, :file_name
      end
    end
  end
end
