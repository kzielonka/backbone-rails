require 'find'
module JsHelper

  def js(text)
    "<%#{text}%>".html_safe
  end
end

