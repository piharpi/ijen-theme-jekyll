# frozen_string_literal: true

require "jekyll-compose/version"
require "jekyll-compose/arg_parser"
require "jekyll-compose/movement_arg_parser"
require "jekyll-compose/file_creator"
require "jekyll-compose/file_mover"
require "jekyll-compose/file_info"
require "jekyll-compose/file_editor"

module Jekyll
  module Compose
    DEFAULT_TYPE = "md"
    DEFAULT_LAYOUT = "post"
    DEFAULT_LAYOUT_PAGE = "page"
    DEFAULT_DATESTAMP_FORMAT = "%Y-%m-%d"
    DEFAULT_TIMESTAMP_FORMAT = "%Y-%m-%d %H:%M %z"
  end
end

%w(draft post publish unpublish page rename compose).each do |file|
  require File.expand_path("jekyll/commands/#{file}.rb", __dir__)
end
