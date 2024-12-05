# frozen_string_literal: true

module Jekyll
  module Commands
    class Draft < Command
      def self.init_with_program(prog)
        prog.command(:draft) do |c|
          c.syntax "draft NAME"
          c.description "Creates a new draft post with the given NAME"

          options.each { |opt| c.option(*opt) }

          c.action { |args, options| process(args, options) }
        end
      end

      def self.options
        [
          ["extension", "-x EXTENSION", "--extension EXTENSION", "Specify the file extension"],
          ["layout", "-l LAYOUT", "--layout LAYOUT", "Specify the draft layout"],
          ["force", "-f", "--force", "Overwrite a draft if it already exists"],
          ["config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array, "Custom configuration file"],
        ]
      end

      def self.process(args = [], options = {})
        config = configuration_from_options(options)
        params = Compose::ArgParser.new(args, options, config)
        params.validate!

        draft = DraftFileInfo.new(params)

        file_creator = Compose::FileCreator.new(draft, params.force?, params.source)
        file_creator.create!

        Compose::FileEditor.bootstrap(config)
        Compose::FileEditor.open_editor(file_creator.file_path)
      end

      class DraftFileInfo < Compose::FileInfo
        def resource_type
          "draft"
        end

        def path
          "_drafts/#{file_name}"
        end

        def content(custom_front_matter = {})
          default_front_matter = front_matter_defaults_for("drafts")
          custom_front_matter.merge!(default_front_matter) if default_front_matter.is_a?(Hash)

          super(custom_front_matter)
        end
      end
    end
  end
end
