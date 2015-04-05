#= require './calendarOverlay'
{div, span} = React.DOM
window.CalendarDay = React.createClass
  displayName: 'CalendarDay'
  handleClick: ->
    React.render(
      React.createElement(CalendarOverlay, date: @props.date),
      document.getElementById('calendar-overlay-container')
    )
  render: ->
    div className: (if @props.date.isSame(moment(), 'day') then 'fc-today'), onClick: @handleClick,
      span className: 'fc-date', @props.date.date()
