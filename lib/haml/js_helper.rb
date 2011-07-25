require 'find'
module JsHelper

  def js(text)
    "<%#{text}%>".html_safe
  end

  def create_jst_templates_file
    dir = Dir.new("#{Rails.root}/config/locales")
    dir.each{|file|
      if (file =~ Regexp.new("jst")) == 0
        lang = file.split(".")[1]
        yml = YAML.load(ERB.new(File.read(dir.path + "/#{file}")).result)
        File.open("#{Rails.root}/app/assets/javascripts/backbone/locales/#{lang}.js", "w") do |f|
          f.write("dictionary_#{lang} = {\n")
          @str = ""
          yml[lang].each{|k,v|
            write_locale(k, v)
          }
          f.write(@str.chop.chop)
          f.write("};")
        end
      end
    }
    if Rails.env != "production" || (Rails.env == "production" && File.exists?(Rails.root.to_s + "/app/assets/javascripts/views.js"))
      File.new(Rails.root.to_s + "/app/assets/javascripts/views.js", "w").write(get_templates)
    end
    return nil
  end

  protected

  def write_locale(key,value)
    if value.class.name.to_s == "String"
      @str += "'#{key}':'#{value}',\n"
    else
      value.each{|k,v|
        write_locale("#{key}.#{k}", v)
      }
    end
  end


  def get_templates
    str = "window.JST = window.JST || {}; \n"
    jst_templates.each do |template|
      str << template_tag(template)
    end
    str
  end

  def template_tag template
    text = ActionView::Base.new(lookup_context).render(:partial => template)
    new_line = ""
    body = text.gsub(/<script>(.*?)<\/script>/, "")

    text.scan(/<script>(.*?)<\/script>/){|s| new_line = s.join("\n")}
    "window.JST['#{template.gsub("/","_").gsub(".","_")}'] = _.template('#{body.gsub(/\r?\n/, "\\n").gsub("'", '\\\\\'').html_safe}'); \n#{new_line.gsub("var ","")}".html_safe
  end

  def jst_templates(dir = Rails.root.to_s)
    result = []

    Find.find(dir + "/app/views/") do |partial|
      result << partial.gsub(/\/_/,"/").gsub(/(.*)\/app\/views\//, '').gsub('.haml', '') if partial =~ /.jst.haml/
    end

    result
  end
end

