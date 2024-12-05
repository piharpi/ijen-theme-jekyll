# frozen_string_literal: true

#
# This class is aimed to open the created file in the selected editor.
# To use this feature specify at Jekyll config:
#
# ```
#  jekyll_compose:
#    auto_open: true
# ```
#
# And make sure, that you have JEKYLL_EDITOR, VISUAL, or EDITOR environment variables set up.
# This will allow to open the file in your default editor automatically.

module Jekyll
  module Compose
    class FileEditor
      class << self
        attr_reader  :compose_config
        alias_method :jekyll_compose_config, :compose_config

        def bootstrap(config)
          @compose_config = config["jekyll_compose"] || {}
        end

        def open_editor(filepath)
          run_editor(post_editor, File.expand_path(filepath)) if post_editor
        end

        def run_editor(editor_name, filepath)
          system("#{editor_name} #{filepath}")
        end

        def post_editor
          return unless auto_open?

          ENV["JEKYLL_EDITOR"] || ENV["VISUAL"] || ENV["EDITOR"]
        end

        def auto_open?
          compose_config["auto_open"]
        end
      end
    end
  end
end
