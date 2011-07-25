require 'rails'
require 'haml/haml_filter'
require 'haml/js_helper'
require 'haml/template_generator'

module ActionView
  module Helpers
    include JsHelper
  end
end

#module Sprockets
#  autoload :ViewTemplate,           "haml/template_generator"
#end

#ActionController::Base.send(:include, TemplateGenerator)


module BackboneRails
  class Engine < Rails::Engine
  end
end
