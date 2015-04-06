#= require './calendarForm'
#= require './MessageList'
{div, span, h4} = React.DOM
window.CalendarOverlay = React.createClass
  displayName: 'CalendarOverlay'

  getInitialState: ->
    style: {}, showForm: false, message: null

  componentDidMount: ->
    setTimeout( =>
      @setState style: top: '0%'
    , 0)

  componentWillReceiveProps: ->
    @setState style: top: '0%'

  closeOverlay: ->
    @setState style: {}
    setTimeout =>
      @setState showForm: false 
    , 500 

  showForm: (message) ->
    @setState message: message if message 
    @setState showForm: true 

  render: ->
    div className: 'custom-content-reveal', style: @state.style,
      h4 null, "Events for " + @props.date.format("MMMM Do YYYY")
      span className: 'custom-content-close', onClick: @closeOverlay
      if @state.showForm
        React.createElement CalendarForm, date: @props.date, message: @state.message
      else
        React.createElement MessageList, messages: @props.messages, showFormCallback: @showForm, date: @props.date

