#= require './calendarOverlay'
{div, span, i} = React.DOM
window.CalendarDay = React.createClass
  displayName: 'CalendarDay'

  getDefaultProps: ->
    # get messages via ajax
    messages: [
      id: 12
      message: 'hello, this is one message'
      service: 'twitter'
      dateTime: 32459502
    ,
      id: 13
      message: 'hello, this is one message'
      service: 'twitter'
      dateTime: 324595042
    ,
      id: 14
      message: 'Dad\'s lost his home grown garlic. This has potential to turn out worse than any greek tragedy. Dad\'s lost his home grown garlic. This has potential to turn out worse than any greek tragedy'
      service: 'facebook'
      dateTime: 324595042
    ]
    
  getInitialState: ->
    isDisabled = @props.date.isBefore(moment().startOf('day'))
    classArray = []
    classArray.push 'fc-today' if @props.date.isSame(moment(), 'day')
    classArray.push 'disabled' if isDisabled
    dayClass: classArray.join(' '), disabled: isDisabled
    twitterMessageCount: _.where(@props.messages, service: 'twitter').length
    facebookMessageCount: _.where(@props.messages, service: 'facebook').length


  componentWillReceiveProps: (nextProps) ->
    isDisabled = nextProps.date.isBefore(moment().startOf('day'))
    classArray = []
    classArray.push 'fc-today' if nextProps.date.isSame(moment(), 'day')
    classArray.push 'disabled' if isDisabled
    @setState dayClass: classArray.join(' '), disabled: isDisabled

  handleClick: ->
    if !@state.disabled
      React.render(
        React.createElement(CalendarOverlay, date: @props.date, messages: @props.messages),
        document.getElementById('calendar-overlay-container')
      )
  render: ->
    div className: @state.dayClass, onClick: @handleClick,
      div className: 'fc-date', @props.date.date()
      if @state.twitterMessageCount
        div className: 'message-scheduled-count twitter', 
          i className: 'fa fa-twitter'
          span className: 'count', @state.twitterMessageCount
      if @state.facebookMessageCount
        div className: 'message-scheduled-count facebook', 
          i className: 'fa fa-facebook'
          span className: 'count', @state.facebookMessageCount
