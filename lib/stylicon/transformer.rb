require "nokogiri"

module Stylicon
  class Transformer
    def initialize(input_svg:, output_svg:, style: nil, classes: nil)
      @input_svg = input_svg
      @output_svg = output_svg
      @style = style
      @classes = classes
    end

    def transform
      doc = Nokogiri::XML(File.read(@input_svg))
      svg = doc.at_css("svg")

      svg["style"] = [svg["style"], @style].compact.join("; ") if @style
      svg["class"] = [svg["class"], @classes].compact.join(" ") if @classes

      File.write(@output_svg, doc.to_xml)
      puts "🎨 Transformed SVG written to #{@output_svg}"
    end
  end
end
