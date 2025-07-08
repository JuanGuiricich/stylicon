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
        background = opts["background"]

        svg = File.read(path)
        doc = Nokogiri::XML(svg)

        svg_node = doc.at_css("svg")
        svg_node.remove_attribute("fill")
        svg_node.remove_attribute("width")
        svg_node.remove_attribute("height")

        doc.css("*[fill]").each { |el| el.remove_attribute("fill") }

        encoded = Base64.strict_encode64(doc.to_xml)

        css << <<~RULE
          #{classes.join(", ")} {
            -webkit-mask-image: url("data:image/svg+xml;base64,#{encoded}");
            -webkit-mask-repeat: no-repeat;
            -webkit-mask-size: contain;
            -webkit-mask-position: center;
            display: inline-block;
            #{background ? "background-color: #{background};" : ""}
          }

        RULE
      end

      File.write(@output_path, css)
      puts "✅ stylicon.css written to #{@output_path}"
    end
  end
end
