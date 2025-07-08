require "yaml"
require "base64"
require "nokogiri"

module Stylicon
  class Generator
    def initialize(config_path, output_path = "stylicon.css")
      @config_path = config_path
      @output_path = output_path
    end

    def generate
      config = YAML.load_file(@config_path)
      css = ""

      config.each do |name, opts|
        path = opts["path"]
        fill = opts["fill"]
        width = opts["width"]
        height = opts["height"]
        classes = Array(opts["class"] || ".icon-#{name}")

        svg = File.read(path)
        doc = Nokogiri::XML(svg)

        svg_node = doc.at_css("svg")
        svg_node["fill"] = fill if fill
        svg_node["width"] = width.to_s if width
        svg_node["height"] = height.to_s if height

        doc.css("*[fill]").each { |el| el.remove_attribute("fill") }

        encoded = Base64.strict_encode64(doc.to_xml)

        css << <<~RULE
          #{classes.join(", ")} {
            background-image: url("data:image/svg+xml;base64,#{encoded}");
            background-repeat: no-repeat;
            background-size: contain;
            width: #{width}px;
            height: #{height}px;
          }

        RULE
      end

      File.write(@output_path, css)
      puts "✅ stylicon.css written to #{@output_path}"
    end
  end
end
