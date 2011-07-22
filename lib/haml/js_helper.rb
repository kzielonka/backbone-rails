require 'find'
module JsHelper

  def js(text)
    "<%#{text}%>".html_safe
  end

  def get_templates
    str = "window.JST = window.JST || {}; \n"
    jst_templates.each do |template|
      str << template_tag(template)
    end
    str
  end


  def template_tag template
    text = (render :partial => template)
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

  def create_jst_templates_file
    if ENV['RAILS_ENV'] != "production" || (ENV['RAILS_ENV'] == "production" && File.exists?(Rails.root.to_s + "/app/assets/javascripts/views.js"))
      File.new(Rails.root.to_s + "/app/assets/javascripts/views.js", "w").write(get_templates)
    end
  end
end