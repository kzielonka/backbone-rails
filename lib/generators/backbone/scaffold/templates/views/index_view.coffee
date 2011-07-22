<%= view_namespace %> ||= {}

class <%= view_namespace %>.IndexView extends Backbone.View
  template: JST["<%= jst 'index' %>"]
    
  initialize: () ->
    _.bindAll(this, 'render');

  render: ->
    $(this.el).html(this.template({collection: this.collection }))
    
    return this