#require "haml"
#require "yaml"

module HamlJsTemplate
  class J

    class << self

      def link_to(text, url, options={})
        "\"<a href=\'\" + #{get_url url} + \"\' #{options_for(options)} >\" + #{J.compile_text text} + \"</a>\""
      end

      def image_tag(source, options = {})
        tag "img", options.merge({:src => "\" + #{source} + \""})
      end

      def tag(tag, options = {})
        "\"<#{tag} #{options_for(options)} />\""
      end

      def options_for(options)
        params = ""
        options.each{|k,v|
          params << " #{k}=\'#{v}\'"
        }
        params
      end

      def get_url(url)
        case url
          when /^#/
            "\"#{url}\""
          else
            url
        end
      end

      def compile_text(text)
        begin
          Kernel.eval text
        rescue Exception => e
          text
        end
      end
    end

  end

  module Filters

    # Tag for inserting javascripts.
    # Available tags: =, if, else, elseif, end, each, endeach
    # Example:
    # :js
    #   = model.get("value")
    #   = model.get("name")
    #
    # Produces:
    # <%= model.get("value") %>
    # <%= model.get("name") %>
    #
    # You can also use this tag to add other javascript constent, like:
    #
    # Other examples:
    # :js
    #   if condition
    # .some_class
    #   some text
    # :js
    #   else
    # alternative text
    # :js
    #   end
    #
    # Full example:
    # :js
    #   each collection item
    # .test.div_class
    #   %p
    #     Paragraph text:
    #     :js
    #       = tab.get('body')
    # :js
    #   endeach
    #
    # This will produce:
    # "<% tabs.each(function(tab) { %>"
    # <div><p>Paragraph text:<%= tab.get('body') %></p></div>
    # "<% } %>""
    #
    # HELPERS
    # Available: link_to, imiage_tag
    # :js
    #   = J.link_to J.image_tag("item.imageUrl()"), "item.url()"
    #   = J.link_to "Some link text", "item.url()"
    #   = J.image_tag("item.imageUrl()")
    #
    module Js
      include Haml::Filters::Base

      def render(text)
        js = ""
        text.split("\n").each{|line|
          js += "<%#{get_tag(line)} %>"
        }
        js
      end

      def compile_text(text)
        J.compile_text text.strip
      end

      private
      def get_tag(line)
        case line
          when /^=/
            "= #{compile_text line[1..line.size]}"
          when /^if/
            " if(#{line.gsub("if ","")}) {"
          when /^elseif/
            "<% } else if(#{line.gsub("elseif ","").chop}) {"
          when /^else/
            " } else {"
          when /^endeach/
            " });"
          when /^end/
            " }"
          when /^each/
            options = line.split(' ')
            " #{options[1] || "collection"}.each(function(#{options[2] || "item"}) {"
          else
            ' ' + line
        end
      end

    end
  end
end

