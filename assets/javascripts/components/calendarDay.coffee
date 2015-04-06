#= require './calendarOverlay'
{div, span, i} = React.DOM
window.CalendarDay = React.createClass
  displayName: 'CalendarDay'
    
  getInitialState: ->
    classArray = []
    classArray.push 'fc-today' if @props.date.isSame(moment(), 'day')
    classArray.push 'disabled' if isDisabled
    isDisabled = @props.date.isBefore(moment().startOf('day'))
    dayClass: classArray.join(' '), disabled: isDisabled
    twitterMessageCount: _.where(@props.messages, service: 'twitter').length
    facebookMessageCount: _.where(@props.messages, service: 'facebook').length

  componentWillReceiveProps: (nextProps) ->
    isDisabled = nextProps.date.isBefore(moment().startOf('day'))
    classArray = []
    classArray.push 'fc-today' if nextProps.date.isSame(moment(), 'day')
    classArray.push 'disabled' if isDisabled
    @setState 
      dayClass: classArray.join(' ')
      disabled: isDisabled
      twitterMessageCount: _.where(nextProps.messages, service: 'twitter').length
      facebookMessageCount: _.where(nextProps.messages, service: 'facebook').length

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
