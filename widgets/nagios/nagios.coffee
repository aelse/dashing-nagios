class Dashing.Nagios extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    if not (data.hasOwnProperty('warnings') and data.hasOwnProperty('criticals'))
        @status = 'error'
    else if data.criticals
        @status = 'red'
    else if data.warnings
        @status = 'yellow'
    else
        @status = 'green'
