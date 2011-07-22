require 'rails'
require 'haml/haml_filter'
require 'haml/js_helper'

module ActionView
  module Helpers
    include JsHelper
  end
end


module BackboneRails
  class Engine < Rails::Engine
  end
end
