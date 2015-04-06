{div, span, form, label, textarea, input, select, option, br, button} = React.DOM
window.CalendarForm = React.createClass
  displayName: 'CalendarForm'
  getInitialState: ->
    if @props.message.id
      action = '/messages/'+ @props.message.id + '/edit' 
    else
      action = '/messages/new' 
    action: action
    time: moment(@props.message.time*1000).format("HH:mm")
    message: @props.message.message || '' 
    characterCountClass: '' 
    characterCount: @props.message.length || 0
    service: @props.message.service || 'twitter'

  componentWillReceiveProps: ->
    @setMessageContent @props.message.message 
    @setState service: (@props.message.service || 'twitter'), time: moment(@props.message.time*1000).format("HH:mm")
    if @props.message.id
      @setState action: '/messages/'+ @props.message.id + '/edit' 
    else
      @setState action: '/messages/new' 

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

  updateTime: ->
    @setState time: event.target.value
    
  render: ->
    div className: 'col-xs-12',
      form id: 'message-form', method: 'post', action: @state.action,
        input type: 'hidden', name: 'date', value: +@props.date/1000
        if @props.message.id
          input type: 'hidden', name: 'message', value: +@props.message.id
        div className: 'form-group',
          label null, 'Message'
          span className: 'character-count' + @state.characterCountClass, @state.message.length
          textarea className: 'form-control', name: 'message', placeholder: 'Message', rows: 4, value: @state.message, onChange: @updateMessage
        div className: 'form-group',
          label null, 'Time'
          input className: 'form-control time-picker', name: 'time', type: 'time', value: @state.time, onChange: @updateTime
        div className: 'form-group',
          label null, 'Service'
          select className: 'form-control', name: 'service', value: @state.service, onChange: @updateService,
            option value: 'twitter', 'Twitter'
            option value: 'facebook', 'Facebook'
        br null
        div className: 'form-group',
          button className: 'btn btn-primary', type: 'submit', 'Submit'

