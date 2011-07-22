<%= view_namespace %> ||= {}

class <%= view_namespace %>.ShowView extends Backbone.View
  template: JST["<%= jst 'show' %>"]
   
  render: ->
    $(this.el).html(this.template({model: this.model}))
    return this