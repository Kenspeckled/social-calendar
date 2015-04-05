#= require './calendarForm'
{div, span, h4, form, textarea, input, select, option, button} = React.DOM
window.CalendarOverlay = React.createClass
  displayName: 'CalendarOverlay'
  getInitialState: ->
    style: {}
  componentDidMount: ->
    setTimeout( =>
      @setState style: top: '0%'
    , 0)
  componentWillReceiveProps: ->
    @setState style: top: '0%'
  closeOverlay: ->
    @setState style: {} 
  render: ->
    div className: 'custom-content-reveal', style: @state.style,
      h4 null, "Events for " + @props.date.format("MMMM Do YYYY")
      span className: 'custom-content-close', onClick: @closeOverlay
      React.createElement CalendarForm, date: @props.date

