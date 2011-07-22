<%= view_namespace %> ||= {}

class <%= view_namespace %>.<%= singular_name.capitalize %>View extends Backbone.View
  template: (attr) ->
    JST.<%= jst singular_name %>(attr)
  
  events:
    "click .destroy" : "destroy"
      
  tagName: "tr"
  
  destroy: () ->
    this.model.destroy()
    this.remove()
    
    return false
    
  render: ->
    $(this.el).html(this.template({ model: this.model }));
    return this