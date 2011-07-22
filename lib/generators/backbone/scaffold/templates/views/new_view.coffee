<%= view_namespace %> ||= {}

class <%= view_namespace %>.NewView extends Backbone.View    
  template: JST["<%= jst 'new' %>"]
  
  events:
    "submit #new-<%= singular_name %>": "save"
    
  constructor: (options) ->
    super(options)
    @options.model = new @options.collection.model()

    @options.model.bind("change:errors", () =>
      this.render()
    )
    
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    the_model = this.model
    that = this
    this.model.unset("errors")
    
    this.model.create(this.model.toJSON(),
      success: (data) =>
        the_model = data
        window.location.hash = "/#{the_model.id}"
        
      error: (model, jqXHR) =>
        that.model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  render: ->
    $(this.el).html(this.template({model :this.model}))
    
    return this