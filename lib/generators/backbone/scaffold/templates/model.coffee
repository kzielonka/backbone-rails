class <%= model_namespace %> extends Backbone.Atlas.Model
  initialize: (attributes) ->
    @has attributes

  url : ->
    base = '<%= plural_name %>'
    if this.isNew()
        return base

    path = '/'
    if base.charAt(base.length - 1) == '/'
        path = ''
    return '<%= plural_name %>' + path + this.id

  paramRoot: '<%= singular_table_name %>'

<% attributes.each do |attribute| -%>
    <%= attribute.name %>: null
<% end -%>
  
class <%= collection_namespace %>Collection extends Backbone.Atlas.Collection
  model: <%= model_namespace %>
  url: '<%= route_url %>'