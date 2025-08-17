# frozen_string_literal: true

require "fileutils"

module Stylicon
  # BatchTransformer class to transform folders with svg
  class BatchTransformer
    def initialize(output_folder:, input_pattern: nil, input_folder: nil, **transform_options)
      @input_pattern = input_pattern
      @input_folder = input_folder
      @output_folder = output_folder
      @transform_options = transform_options
    end

    def transform
      files = find_svg_files
      FileUtils.mkdir_p(@output_folder)

      files.each do |input_file|
        output_file = File.join(@output_folder, File.basename(input_file))

        Stylicon::Transformer.new(
          input_svg: input_file,
          output_svg: output_file,
          **@transform_options
        ).transform
      end

      puts "🎨 Transformed #{files.length} SVG files to #{@output_folder}"
    end

    private

    def find_svg_files
      if @input_pattern
        Dir.glob(@input_pattern)
      elsif @input_folder
        Dir.glob(File.join(@input_folder, "*.svg"))
      else
        raise ArgumentError, "Must provide an input_pattern or input_folder to select the svg's"
      end
    end
  end
end
