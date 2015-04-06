{div, p, span, h5, a, i} = React.DOM
window.Message = React.createClass
  displayName: 'Message'
  render: ->
    div className: 'message text-left',
      div className: 'time', moment(@props.message.dateTime).format("HH:MM")
      a className: 'edit', 'Edit'
      h5 null,
        i className: 'fa fa-'+@props.message.service.toLowerCase()
        span null, @props.message.service
      div null, @props.message.message

