# frozen_string_literal: true

require_relative "stylicon/version"
require_relative "stylicon/generator"
require_relative "stylicon/transformer"
require_relative "stylicon/batch_transformer"

module Stylicon
  class Error < StandardError; end
end
