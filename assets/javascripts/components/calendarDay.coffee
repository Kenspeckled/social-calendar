#= require './calendarOverlay'
{div, span, i} = React.DOM
window.CalendarDay = React.createClass
  displayName: 'CalendarDay'
  getInitialState: ->
    isDisabled = @props.date.isBefore(moment().startOf('day'))
    classArray = []
    classArray.push 'fc-today' if @props.date.isSame(moment(), 'day')
    classArray.push 'disabled' if isDisabled
    dayClass: classArray.join(' '), disabled: isDisabled

  componentWillReceiveProps: (nextProps) ->
    isDisabled = nextProps.date.isBefore(moment().startOf('day'))
    classArray = []
    classArray.push 'fc-today' if nextProps.date.isSame(moment(), 'day')
    classArray.push 'disabled' if isDisabled
    @setState dayClass: classArray.join(' '), disabled: isDisabled

  handleClick: ->
    if !@state.disabled
      # get messages via ajax
      messages = [
        message: 'hello, this is one message'
        service: 'Twitter'
        dateTime: 32459502
      ,
        message: 'hello, this is one message'
        service: 'Twitter'
        dateTime: 324595042
      ,
        message: 'Dad\'s lost his home grown garlic. This has potential to turn out worse than any greek tragedy. Dad\'s lost his home grown garlic. This has potential to turn out worse than any greek tragedy'
        service: 'Facebook'
        dateTime: 324595042
      ]
      React.render(
        React.createElement(CalendarOverlay, date: @props.date, messages: messages),
        document.getElementById('calendar-overlay-container')
      )
  render: ->
    div className: @state.dayClass, onClick: @handleClick,
      div className: 'fc-date', @props.date.date()
      div className: 'message-scheduled-count twitter', 
        i className: 'fa fa-twitter'
        span className: 'count', 4
      div className: 'message-scheduled-count facebook', 
        i className: 'fa fa-facebook'
        span className: 'count', 4
