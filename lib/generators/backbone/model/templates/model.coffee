class <%= model_namespace %> extends Backbone.Atlas.Model
  initialize: (attributes) ->
    @has attributes

  url : ->
    base = '<%= plural_name %>'
    if this.isNew()
        return base
    return '<%= plural_name %>' + (base.charAt(base.length - 1) == '/' ? '' : '/') + this.id


  paramRoot: '<%= singular_table_name %>'

  
class <%= collection_namespace %>Collection extends Backbone.Atlas.Collection
  model: <%= model_namespace %>
  url: '<%= route_url %>'