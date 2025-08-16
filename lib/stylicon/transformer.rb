require "nokogiri"

module Stylicon
  class Transformer
    def initialize(input_svg:, output_svg:, style: nil, classes: nil, fill: nil, stroke: nil, width: nil, height: nil)
      @input_svg = input_svg
      @output_svg = output_svg
      @style = style
      @classes = classes
      @fill = fill
      @stroke = stroke
      @width = width
      @height = height
    end

    def transform
      doc = Nokogiri::XML(File.read(@input_svg))
      svg = doc.at_css("svg")

      svg["style"] = [svg["style"], @style].compact.join("; ") if @style
      svg["class"] = [svg["class"], @classes].compact.join(" ") if @classes

      if @fill
        doc.css("*[fill]").each do |element|
          element["fill"] = @fill unless element["fill"] == "none"
        end
      end

      if @width
        svg["width"] = @width
      end

      if @height
        svg["height"] = @height
      end

      if @stroke
        doc.css("*[stroke]").each do |element|
          element["stroke"] = @stroke unless element["stroke"] == "none"
        end
      end

      File.write(@output_svg, doc.to_xml)
      puts "🎨 Transformed SVG written to #{@output_svg}"
    end
  end
end
