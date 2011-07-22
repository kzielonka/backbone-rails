class <%= router_namespace %>Router extends Backbone.Router
  routes:
    "<%= plural_name %>/new": "new<%= class_name %>"
    "<%= plural_name %>/index": "index"
    "<%= plural_name %>/:id/edit": "edit"
    "<%= plural_name %>/:id": "show"

  new<%= class_name %>: ->
    @view = new <%= "#{view_namespace}" %>.NewView(new <%= model_namespace %>())
    $("#<%= plural_name %>").html(@view.render().el)

  index: ->
    @<%= plural_name %> = new <%= collection_namespace %>Collection()
    @<%= plural_name %>.fetch(
        success: ->
            @view = new <%= "#{view_namespace}.IndexView(collection: @#{plural_name})" %>
            $("#<%= plural_name %>").html(@view.render().el)
        error: ->
            alert("error")
    )

  show: (id) ->
    @<%= singular_name %> = new <%= model_namespace %>({id: id})
    @<%= singular_name %>.fetch(
        success: ->
            @view = new <%= "#{view_namespace}" %>.ShowView(model: @<%= singular_name %>)
            $("#<%= plural_name %>").html(@view.render().el)
        error: ->
            alert("error")
    )
    
  edit: (id) ->
    @<%= singular_name %> = new <%= model_namespace %>({id: id})
    @<%= singular_name %>.fetch(
        success: ->
            @view = new <%= "#{view_namespace}" %>.EditView(model: @<%= singular_name %>)
            $("#<%= plural_name %>").html(@view.render().el)
        error: ->
            alert("error")
    )
new <%= router_namespace %>Router()