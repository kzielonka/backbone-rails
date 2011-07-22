<%= view_namespace %> ||= {}

class <%= view_namespace %>.ShowView extends Backbone.View
  template: (attr) ->
    JST.<%= jst 'show' %>(attr)
   
  render: ->
    $(this.el).html(this.template({model: this.model}))
    return this