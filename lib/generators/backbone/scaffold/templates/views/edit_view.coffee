<%= view_namespace %> ||= {}

class <%= view_namespace %>.EditView extends Backbone.View
  template: JST["<%= jst 'edit' %>"]
  
  events:
    "submit #edit-<%= singular_name %>": "update"
    
  update: (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    this.model.save(null,
      success:(data) =>
        this.model = data
        window.location.hash = "/#{this.model.id}"
    )
    
  render: ->
    $(this.el).html(this.template({model:this.model}))
    
    return this