class Dashing.Nagios extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    status = switch
      when not (data.hasOwnProperty('warnings') and data.hasOwnProperty('criticals')) then 'error'
      when @get('criticals') > 0 then 'red'
      when @get('warnings') > 0 then 'yellow'
      else 'green'

    @set 'status', status
