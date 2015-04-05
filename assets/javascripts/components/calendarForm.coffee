{div, span, form, label, textarea, input, select, option, br, button} = React.DOM
window.CalendarForm = React.createClass
  displayName: 'CalendarForm'
  getInitialState: ->
    startTime: moment().format("HH:mm")
    message: ''
    characterCountClass: '' 
    characterCount: 0
    service: 'twitter'

  componentWillReceiveProps: ->
    #reset state on form change
    @setState @getInitialState()

  componentDidMount: ->
    document.getElementsByClassName('time-picker')[0].setAttribute('value', @state.startTime)

  setMessageContent: (message) ->
    if @state.service == 'twitter'
      @setState message: message.slice(0, 140)
      @setState characterCountClass: (if @state.message.length > 135 then ' danger' else '')
    else
      @setState message: message
      @setState characterCountClass: ''

  updateMessage: -> 
    @setMessageContent(event.target.value)

  updateService: ->
    @setState service: event.target.value
    @setMessageContent(@state.message)
    
  render: ->
    div className: 'col-xs-12',
      form id: 'message-form', method: 'post', action: '/messages/new',
        input type: 'hidden', name: 'date', value: +@props.date
        div className: 'form-group',
          label null, 'Message'
          span className: 'character-count' + @state.characterCountClass, @state.message.length
          textarea className: 'form-control', name: 'message', placeholder: 'Message', rows: 4, value: @state.message, onChange: @updateMessage
        div className: 'form-group',
          label null, 'Time'
          input className: 'form-control time-picker', name: 'time', type: 'time'
        div className: 'form-group',
          label null, 'Service'
          select className: 'form-control', name: 'service', selected: @state.service, onChange: @updateService,
            option value: 'twitter', 'Twitter'
            #option value: 'facebook', 'Facebook'
        br null
        div className: 'form-group',
          button className: 'btn btn-primary', type: 'submit', 'Submit'

